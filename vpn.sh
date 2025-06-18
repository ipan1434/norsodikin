VPN_SERVER_IP=$(curl -s ifconfig.me || curl -s ipinfo.io/ip)
VPN_USER="vpnuser"
VPN_PASS="vpnpassword"

echo "⚙️ Update dan install paket StrongSwan..."
apt update -y && apt upgrade -y
apt install strongswan strongswan-pki libstrongswan-extra-plugins iptables iptables-persistent -y

echo "📁 Buat direktori sertifikat..."
mkdir -p /etc/ipsec.d/{certs,private}

echo "🔐 Buat CA (Certificate Authority)..."
ipsec pki --gen --outform pem > ca.key.pem
ipsec pki --self --in ca.key.pem --dn "CN=VPN Root CA" --ca --outform pem > ca.cert.pem

echo "🔐 Buat sertifikat server..."
ipsec pki --gen --outform pem > server.key.pem
ipsec pki --pub --in server.key.pem | ipsec pki --issue --cacert ca.cert.pem --cakey ca.key.pem \
    --dn "CN=$VPN_SERVER_IP" --san "$VPN_SERVER_IP" --flag serverAuth --flag ikeIntermediate --outform pem > server.cert.pem

echo "📁 Pindahkan sertifikat ke direktori IPsec..."
cp ca.cert.pem /etc/ipsec.d/certs/
cp server.cert.pem /etc/ipsec.d/certs/
cp server.key.pem /etc/ipsec.d/private/

echo "⚙️ Konfigurasi IPsec..."
cat > /etc/ipsec.conf << EOF
config setup
  charondebug="ike 1, knl 1, cfg 0"

conn ikev2-vpn
  auto=add
  compress=no
  type=tunnel
  keyexchange=ikev2
  fragmentation=yes
  forceencaps=yes
  dpdaction=clear
  dpddelay=300s
  rekey=no
  left=%any
  leftid=$VPN_SERVER_IP
  leftcert=server.cert.pem
  leftsendcert=always
  leftsubnet=0.0.0.0/0
  right=%any
  rightid=%any
  rightauth=eap-mschapv2
  rightsourceip=10.10.10.0/24
  rightdns=1.1.1.1,8.8.8.8
  eap_identity=%identity
EOF

echo "🔐 Tambahkan user VPN ke ipsec.secrets..."
cat > /etc/ipsec.secrets << EOF
: RSA server.key.pem
$VPN_USER : EAP "$VPN_PASS"
EOF

echo "📡 Aktifkan IP forwarding..."
echo 'net.ipv4.ip_forward=1' >> /etc/sysctl.conf
sysctl -p

echo "🌐 Atur NAT iptables..."
iptables -t nat -A POSTROUTING -s 10.10.10.0/24 -o eth0 -j MASQUERADE
netfilter-persistent save

echo "🚀 Restart StrongSwan..."
systemctl restart ipsec
systemctl enable ipsec

ufw allow 500,4500/udp

echo "✅ VPN IKEv2 telah berhasil dikonfigurasi!"
echo ""
echo "📱 Gunakan data ini untuk menghubungkan HP Anda:"
echo "──────────────────────────────────────────────"
echo "Server     : $VPN_SERVER_IP"
echo "Tipe       : IKEv2/IPSec MSCHAPv2"
echo "Username   : $VPN_USER"
echo "Password   : $VPN_PASS"
echo "Remote ID  : $VPN_SERVER_IP"
echo "──────────────────────────────────────────────"

PROXY_FILE="${1:-proxy.txt}"
CHECK_URLS="${2:-https://www.google.com}"
PROXY_URLS=("https://raw.githubusercontent.com/monosans/proxy-list/main/proxies/all.txt" "https://raw.githubusercontent.com/dpangestuw/Free-Proxy/refs/heads/main/All_proxies.txt")

function getColor() {
    local color_name=$1
    case "$color_name" in
        WHITE) echo -e "\033[1;38;5;231m" ;;
        PURPLE) echo -e "\033[1;38;5;93m" ;;
        BLUE) echo -e "\033[1;38;5;21m" ;;
        GREEN) echo -e "\033[1;38;5;46m" ;;
        YELLOW) echo -e "\033[1;38;5;226m" ;;
        CYAN) echo -e "\033[1;38;5;51m" ;;
        RESET) echo -e "\033[0m" ;;
    esac
}

function log() {
    local level=$1
    shift
    local message="$*"
    local timestamp=$(TZ="Asia/Jakarta" date +"%Y-%m-%d %H:%M:%S %Z")

    declare -A colors=(
        [RESET]=$(getColor RESET)
        [RED]=$(getColor RED)
        [GREEN]=$(getColor GREEN)
        [YELLOW]=$(getColor YELLOW)
        [BLUE]=$(getColor BLUE)
        [PURPLE]=$(getColor PURPLE)
        [CYAN]=$(getColor CYAN)
        [WHITE]=$(getColor WHITE)
    )

    case "$level" in
        DEBUG) color=${colors[CYAN]} ;;
        INFO) color=${colors[GREEN]} ;;
        WARNING) color=${colors[YELLOW]} ;;
        ERROR) color=${colors[RED]} ;;
        CRITICAL) color=${colors[PURPLE]} ;;
    esac

    printf "${colors[WHITE]}[ ${timestamp} ]${colors[RESET]} ${colors[PURPLE]}|${colors[RESET]} ${color}%-8s${colors[RESET]} ${colors[PURPLE]}|${colors[RESET]} ${colors[BLUE]}${BASH_SOURCE[1]:-unknown}:${FUNCNAME[1]:-unknown}:${BASH_LINENO[1]:-0}${colors[RESET]} ${colors[PURPLE]}|${colors[RESET]} ${color}%s${colors[RESET]}\n" "$level" "$message"
}

function fetchProxies() {
    > "$PROXY_FILE"
    for url in "${PROXY_URLS[@]}"; do
        local temp_file=$(mktemp)
        if ! curl -s --max-time 30 "$url" | sed '/^$/d' > "$temp_file"; then
            log ERROR "Gagal mengambil proxy dari $url"
        else
            local count=$(wc -l < "$temp_file" || echo 0)
            cat "$temp_file" >> "$PROXY_FILE"
            log INFO "Berhasil mengambil $count proxy dari $url"
        fi
        rm -f "$temp_file"
    done
}

function checkProxy() {
    local proxy=$1

    if curl -sx "$proxy" --connect-timeout 15 --max-time 20 "$CHECK_URLS" &> /dev/null; then
        echo "$proxy" >> "$PROXY_FILE.tmp"
    fi
}

function validateProxies() {
    log INFO "Memvalidasi proxy..."
    local start_time=$(date +%s)
    local total_proxies=$(wc -l < "$PROXY_FILE" || echo 0)
    local valid_count=0
    local current=0

    > "$PROXY_FILE.tmp"
    while IFS= read -r proxy; do
        checkProxy "$proxy" &
        ((current++))

        local temp_valid_count=$(wc -l < "$PROXY_FILE.tmp" || echo 0)

        local percentage=$((current * 100 / total_proxies))
        local remaining=$((total_proxies - current))
        local elapsed=$(($(date +%s) - start_time))
        local formatted_time=$(date -u -d @$elapsed +'%H:%M:%S')
        local timestamp=$(TZ="Asia/Jakarta" date +"%Y-%m-%d %H:%M:%S %Z")

        printf "\r\e[K$(getColor WHITE)[ ${timestamp} ]$(getColor RESET) $(getColor PURPLE)|$(getColor RESET) $(getColor BLUE)Validasi proxy: $(getColor GREEN)%d/%d (%d%%)$(getColor RESET) $(getColor PURPLE)|$(getColor RESET) $(getColor YELLOW)Sisa: %d proxy$(getColor RESET) $(getColor PURPLE)|$(getColor RESET) $(getColor GREEN)Valid Proxy: %d$(getColor RESET) $(getColor PURPLE)|$(getColor RESET) $(getColor CYAN)Waktu: %s$(getColor RESET)" \
            "$current" "$total_proxies" "$percentage" "$remaining" "$temp_valid_count" "$formatted_time"
    done < "$PROXY_FILE"
    wait

    mv "$PROXY_FILE.tmp" "$PROXY_FILE"
    valid_count=$(wc -l < "$PROXY_FILE" || echo 0)

    local end_time=$(date +%s)
    local duration=$((end_time - start_time))
    local formatted_duration=$(date -u -d @$duration +'%H:%M:%S')
    printf "\r\e[K"

    log INFO "Validasi selesai dalam $formatted_duration. Tersimpan $valid_count/$total_proxies proxy valid."
}

function main() {
    fetchProxies
    validateProxies
}

main

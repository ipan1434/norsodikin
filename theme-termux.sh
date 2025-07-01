function apply_theme() {
    echo "$1" > ~/.termux/colors.properties
    termux-reload-settings
    if [ $? -eq 0 ]; then
        echo "Tema berhasil diterapkan!"
    else
        echo "Gagal menerapkan tema. Silakan cek konfigurasi."
    fi
}

themes=(
    "Catppuccin Mocha"
    "Catppuccin Latte"
    "Monokai Pro"
    "Rose Pine"
    "Everforest"
    "Solarized Light"
    "Oceanic Next"
    "Material Palenight"
    "Horizon"
    "Nord"
    "Dracula"
    "Tokyo Night"
    "Synthwave"
    "Gruvbox Dark"
    "Gruvbox Light"
)

theme_configs=(
"background: #1e1e2e
foreground: #cdd6f4
cursor: #f5e0dc
color0: #181825
color1: #ed8796
color2: #a6da95
color3: #eed49f
color4: #8aadf4
color5: #c6a0f6
color6: #8bd5ca
color7: #b8c0e0
color8: #45475a
color9: #ed8796
color10: #a6da95
color11: #eed49f
color12: #8aadf4
color13: #c6a0f6
color14: #8bd5ca
color15: #ffffff"

"background: #eff1f5
foreground: #4c4f69
cursor: #d20f39
color0: #e6e9ef
color1: #d20f39
color2: #40a02b
color3: #df8e1d
color4: #1e66f5
color5: #8839ef
color6: #179299
color7: #4c4f69
color8: #bcc0cc
color9: #d20f39
color10: #40a02b
color11: #df8e1d
color12: #1e66f5
color13: #8839ef
color14: #179299
color15: #ffffff"

"background: #2d2a2e
foreground: #fcfcfa
cursor: #ff6188
color0: #2d2a2e
color1: #ff6188
color2: #a9dc76
color3: #ffd866
color4: #78dce8
color5: #ab9df2
color6: #78dce8
color7: #fcfcfa
color8: #75715e
color9: #ff6188
color10: #a9dc76
color11: #ffd866
color12: #78dce8
color13: #ab9df2
color14: #78dce8
color15: #fcfcfa"

"background: #191724
foreground: #e0def4
cursor: #ebbcba
color0: #1f1d2e
color1: #eb6f92
color2: #9ccfd8
color3: #f6c177
color4: #31748f
color5: #c4a7e7
color6: #528a7f
color7: #e0def4
color8: #6e6a86
color9: #eb6f92
color10: #9ccfd8
color11: #f6c177
color12: #31748f
color13: #c4a7e7
color14: #528a7f
color15: #ffffff"

"background: #2d353b
foreground: #d3c6aa
cursor: #a7c080
color0: #262c2e
color1: #e67e80
color2: #a7c080
color3: #dbbc7f
color4: #7fbbb3
color5: #d699b6
color6: #83c092
color7: #d3c6aa
color8: #3e4b51
color9: #e67e80
color10: #a7c080
color11: #dbbc7f
color12: #7fbbb3
color13: #d699b6
color14: #83c092
color15: #ffffff"

"background: #fdf6e3
foreground: #586e75
cursor: #cb4b16
color0: #eee8d5
color1: #dc322f
color2: #859900
color3: #b58900
color4: #268bd2
color5: #6c71c4
color6: #2aa198
color7: #073642
color8: #fdf6e3
color9: #cb4b16
color10: #586e75
color11: #657b83
color12: #839496
color13: #6c71c4
color14: #93a1a1
color15: #002b36"

"background: #1b2b34
foreground: #d8dee9
cursor: #5fb3b3
color0: #1c3657
color1: #ec5f67
color2: #99c794
color3: #fac863
color4: #6699cc
color5: #c594c5
color6: #5fb3b3
color7: #d8dee9
color8: #65737e
color9: #ec5f67
color10: #99c794
color11: #fac863
color12: #6699cc
color13: #c594c5
color14: #5fb3b3
color15: #ffffff"

"background: #292d3e
foreground: #a6accd
cursor: #bb80b3
color0: #232530
color1: #ff5370
color2: #c3e88d
color3: #ffcb6b
color4: #82aaff
color5: #c792ea
color6: #89ddff
color7: #d9d9d9
color8: #434758
color9: #ff5370
color10: #c3e88d
color11: #ffcb6b
color12: #82aaff
color13: #c792ea
color14: #89ddff
color15: #ffffff"

"background: #1c1e26
foreground: #e6e1cf
cursor: #e95678
color0: #16161e
color1: #e95678
color2: #29d398
color3: #fad000
color4: #26bbd9
color5: #ee64ac
color6: #29d398
color7: #e6e1cf
color8: #414868
color9: #e95678
color10: #29d398
color11: #fad000
color12: #26bbd9
color13: #ee64ac
color14: #29d398
color15: #ffffff"

"background: #2e3440
foreground: #d8dee9
cursor: #88c0d0
color0: #3b4252
color1: #bf616a
color2: #a3be8c
color3: #ebcb8b
color4: #81a1c1
color5: #b48ead
color6: #88c0d0
color7: #e5e9f0
color8: #4c566a
color9: #bf616a
color10: #a3be8c
color11: #ebcb8b
color12: #81a1c1
color13: #b48ead
color14: #8fbcbb
color15: #eceff4"

"background: #282a36
foreground: #f8f8f2
cursor: #ff79c6
color0: #21222c
color1: #ff5555
color2: #50fa7b
color3: #f1fa8c
color4: #bd93f9
color5: #ff79c6
color6: #8be9fd
color7: #f8f8f2
color8: #6272a4
color9: #ff6e6e
color10: #69ff94
color11: #ffffa5
color12: #d6acff
color13: #ff92df
color14: #a4ffff
color15: #ffffff"

"background: #1a1b26
foreground: #a9b1d6
cursor: #7aa2f7
color0: #16161e
color1: #f7768e
color2: #9ece6a
color3: #e0af68
color4: #7aa2f7
color5: #ad8ee6
color6: #449dab
color7: #c0caf5
color8: #414868
color9: #f7768e
color10: #9ece6a
color11: #e0af68
color12: #7aa2f7
color13: #ad8ee6
color14: #89ddff
color15: #ffffff"

"background: #2b213a
foreground: #ff7edb
cursor: #ffcc00
color0: #16161e
color1: #ff007f
color2: #00ff9f
color3: #ff9f00
color4: #009fff
color5: #ff00ff
color6: #00ffff
color7: #ffffff
color8: #414868
color9: #ff007f
color10: #00ff9f
color11: #ff9f00
color12: #009fff
color13: #ff00ff
color14: #00ffff
color15: #ffffff"

"background: #282828
foreground: #ebdbb2
cursor: #fabd2f
color0: #1d2021
color1: #cc241d
color2: #98971a
color3: #d79921
color4: #458588
color5: #b16286
color6: #689d6a
color7: #a89984
color8: #504945
color9: #fb4934
color10: #b8bb26
color11: #fabd2f
color12: #83a598
color13: #d3869b
color14: #8ec07c
color15: #ebdbb2"

"background: #fbf1c7
foreground: #3c3836
cursor: #d79921
color0: #fbf1c7
color1: #cc241d
color2: #98971a
color3: #d79921
color4: #458588
color5: #b16286
color6: #689d6a
color7: #7c6f64
color8: #928374
color9: #9d0006
color10: #79740e
color11: #b57614
color12: #076678
color13: #8f3f71
color14: #427b58
color15: #3c3836"
)

echo "Pilih tema untuk Termux:"
for i in "${!themes[@]}"; do
    echo "$((i+1)). ${themes[$i]}"
done

read -p "Masukkan nomor tema: " choice

if [[ $choice -ge 1 && $choice -le ${#themes[@]} ]]; then
    selected_theme="${theme_configs[$((choice-1))]}"
    apply_theme "$selected_theme"
else
    echo "Pilihan tidak valid!"
fi

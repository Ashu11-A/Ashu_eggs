#!/bin/sh

# Configuração de Estilo: "box" (default) ou "ascii"
: "${FMT_STYLE:=box}"
: "${FMT_BORDER_COLOR:=\033[1;34m}"
RESET="\033[0m"

# Larguras fixas configuradas
STATUS_W1=10
STATUS_W2=42

# Helper para repetir caracteres multibyte
repeat_char() {
    char="$1"; n="$2"
    [ "$n" -le 0 ] && return
    printf "%*s" "$n" "" | sed "s/ /$char/g"
}

# Helper para calcular a largura visual real (colunas ocupadas no terminal)
get_visual_width() {
    local str="$1"
    # Remove cores para o cálculo
    local visible
    visible=$(printf "%b" "$str" | sed 's/\x1b\[[0-9;]*m//g')
    
    # Tenta usar wc -L (GNU) que mede colunas visuais.
    # Fallback para a contagem de caracteres do Bash se wc -L não estiver disponível.
    local width
    width=$(printf "%s" "$visible" | wc -L 2>/dev/null)
    if [ $? -eq 0 ] && [ -n "$width" ]; then
        echo "$width"
    else
        # Fallback manual para o bash (conta caracteres, não colunas)
        echo "${#visible}"
    fi
}

# Helper para imprimir célula com padding correto ignorando cores e tratando emojis
print_cell() {
    content="$1"; width="$2"; align="$3"
    v_len=$(get_visual_width "$content")
    pad_total=$((width - v_len))
    [ "$pad_total" -lt 0 ] && pad_total=0

    if [ "$align" = "center" ]; then
        p_left=$((pad_total / 2))
        p_right=$((pad_total - p_left))
        printf "%*s%b%*s" "$p_left" "" "$content" "$p_right" ""
    else
        printf " %b%*s" "$content" "$((pad_total - 1))" ""
    fi
}

if [ "$FMT_STYLE" = "box" ]; then
    TL="╭"; TR="╮"; BL="╰"; BR="╯"; VL="│"; HL="─"; ML="├"; MR="┤"; TC="┬"; BC="┴"; MC="┼"
else
    TL="+"; TR="+"; BL="+"; BR="+"; VL="|"; HL="-"; ML="+"; MR="+"; TC="+"; BC="+"; MC="+"
fi

HLINE1=$(repeat_char "$HL" "$STATUS_W1")
HLINE2=$(repeat_char "$HL" "$STATUS_W2")

print_status_header() {
    h1="$1"; h2="$2"
    echo -e "${FMT_BORDER_COLOR}${TL}${HLINE1}${TC}${HLINE2}${TR}${RESET}"
    printf "${FMT_BORDER_COLOR}${VL}${RESET}"
    print_cell "$h1" "$STATUS_W1" "center"
    printf "${FMT_BORDER_COLOR}${VL}${RESET}"
    print_cell "$h2" "$STATUS_W2" "left"
    printf "${FMT_BORDER_COLOR}${VL}${RESET}\n"
    echo -e "${FMT_BORDER_COLOR}${ML}${HLINE1}${MC}${HLINE2}${MR}${RESET}"
}

print_status_row() {
    c1="$1"; c2="$2"
    printf "${FMT_BORDER_COLOR}${VL}${RESET}"
    print_cell "$c1" "$STATUS_W1" "center"
    printf "${FMT_BORDER_COLOR}${VL}${RESET}"
    print_cell "$c2" "$STATUS_W2" "left"
    printf "${FMT_BORDER_COLOR}${VL}${RESET}\n"
}

print_status_footer() {
    echo -e "${FMT_BORDER_COLOR}${BL}${HLINE1}${BC}${HLINE2}${BR}${RESET}"
}

# Tabela Dinâmica também respeitando o novo método de repetição
print_dynamic_table() {
    h1="$1"; shift; h2="$1"; shift
    w1=$(get_visual_width "$h1")
    w2=$(get_visual_width "$h2")

    for row in "$@"; do
        c1=$(echo "$row" | cut -d'|' -f1); c2=$(echo "$row" | cut -d'|' -f2)
        v1=$(get_visual_width "$c1"); v2=$(get_visual_width "$c2")
        [ "$v1" -gt "$w1" ] && w1="$v1"
        [ "$v2" -gt "$w2" ] && w2="$v2"
    done
    w1=$((w1 + 2)); w2=$((w2 + 2))

    L1=$(repeat_char "$HL" "$w1"); L2=$(repeat_char "$HL" "$w2")
    
    echo -e "\n${FMT_BORDER_COLOR}${TL}${L1}${TC}${L2}${TR}${RESET}"
    printf "${FMT_BORDER_COLOR}${VL}${RESET}"
    print_cell "$h1" "$w1" "center"
    printf "${FMT_BORDER_COLOR}${VL}${RESET}"
    print_cell "$h2" "$w2" "left"
    printf "${FMT_BORDER_COLOR}${VL}${RESET}\n"
    echo -e "${FMT_BORDER_COLOR}${ML}${L1}${MC}${L2}${MR}${RESET}"
    
    for row in "$@"; do
        c1=$(echo "$row" | cut -d'|' -f1); c2=$(echo "$row" | cut -d'|' -f2)
        printf "${FMT_BORDER_COLOR}${VL}${RESET}"
        print_cell "$c1" "$w1" "left"
        printf "${FMT_BORDER_COLOR}${VL}${RESET}"
        print_cell "$c2" "$w2" "left"
        printf "${FMT_BORDER_COLOR}${VL}${RESET}\n"
    done
    echo -e "${FMT_BORDER_COLOR}${BL}${L1}${BC}${L2}${BR}${RESET}\n"
}

#!/bin/sh

# ============================================================
# FUNÇÃO 1: Tabela Dinâmica (Para o Help/Menu)
# Calcula a largura baseada no conteúdo.
# Uso: print_dynamic_table "Header1" "Header2" "item1|desc1" "item2|desc2" ...
# ============================================================
print_dynamic_table() {
    h1="$1"; shift
    h2="$1"; shift

    # 1. Calcular larguras
    w1=${#h1}
    w2=${#h2}

    # Varre os argumentos restantes para achar o maior tamanho
    for row in "$@"; do
        c1=$(echo "$row" | awk -F'|' '{print $1}')
        c2=$(echo "$row" | awk -F'|' '{print $2}')
        
        [ ${#c1} -gt "$w1" ] && w1=${#c1}
        [ ${#c2} -gt "$w2" ] && w2=${#c2}
    done

    # Adiciona padding extra
    w1=$((w1 + 2))
    w2=$((w2 + 2))

    # Cria linha separadora
    sep="+$(printf '%*s' "$w1" "" | tr ' ' '-')+$(printf '%*s' "$w2" "" | tr ' ' '-')+"
    fmt="| %-$((w1-1))s | %-$((w2-1))s |\n"

    # Imprime
    echo ""
    echo "$sep"
    printf "$fmt" " $h1" " $h2"
    echo "$sep"
    
    for row in "$@"; do
        c1=$(echo "$row" | awk -F'|' '{print $1}')
        c2=$(echo "$row" | awk -F'|' '{print $2}')
        printf "$fmt" " $c1" " $c2"
    done
    
    echo "$sep"
    echo ""
}

# ============================================================
# FUNÇÃO 2: Tabela de Status (Para o Install)
# Largura fixa para permitir impressão linha por linha.
# ============================================================

# Larguras fixas configuradas
STATUS_W1=10
STATUS_W2=33

print_status_header() {
    h1="$1"
    h2="$2"
    
    # Linha separadora
    sep="+$(printf '%*s' "$STATUS_W1" "" | tr ' ' '-')+$(printf '%*s' "$STATUS_W2" "" | tr ' ' '-')+"
    fmt="| %-$((STATUS_W1-1))s | %-$((STATUS_W2-1))s |\n"
    
    echo "$sep"
    printf "$fmt" " $h1" " $h2"
    echo "$sep"
}

print_status_row() {
    c1="$1"
    c2="$2"
    fmt="| %-$((STATUS_W1-1))s | %-$((STATUS_W2-1))s |\n"
    printf "$fmt" " $c1" " $c2"
}

print_status_footer() {
    sep="+$(printf '%*s' "$STATUS_W1" "" | tr ' ' '-')+$(printf '%*s' "$STATUS_W2" "" | tr ' ' '-')+"
    echo "$sep"
}
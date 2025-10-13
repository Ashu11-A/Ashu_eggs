#!/bin/bash

# ==============================================================================
# Função: set_toml_value
# Descrição: Altera um valor em um arquivo .toml.
#
# Parâmetros:
#   $1: Caminho para o arquivo .toml (ex: "config.toml")
#   $2: Chave a ser alterada (ex: "auth.token" ou "port")
#   $3: Novo valor a ser definido (ex: "novo-token-secreto")
# ==============================================================================
function set_toml_value() {
  local file="$1"
  local full_key="$2"
  local new_value="$3"

  # --- Validação dos Argumentos ---
  if [[ -z "$file" || -z "$full_key" || -z "$new_value" ]]; then
    echo "Erro: Argumentos insuficientes." >&2
    echo "Uso: set_toml_value <arquivo.toml> <chave> <novo_valor>" >&2
    return 1
  fi

  if [[ ! -f "$file" ]]; then
    echo "Erro: O arquivo '$file' não foi encontrado." >&2
    return 1
  fi

  # --- Preparação das variáveis para o awk ---
  local section=""
  local sub_key="$full_key"

  if [[ "$full_key" == *.* ]]; then
    section="${full_key%%.*}"
    sub_key="${full_key#*.}"
  fi
  
  # Escapa pontos na chave para uso seguro em expressões regulares do awk.
  # Usar [.] em vez de \. é mais portável e evita warnings.
  local full_key_escaped
  full_key_escaped=$(echo "$full_key" | sed 's/\./[.]/g')

  # --- Lógica de substituição com awk ---
  local temp_file
  temp_file=$(mktemp)

  awk -v section="$section" \
      -v sub_key="$sub_key" \
      -v full_key="$full_key" \
      -v full_key_escaped="$full_key_escaped" \
      -v new_value="$new_value" \
  '
  BEGIN {
    in_target_section = (section == "") ? 1 : 0;
    key_found = 0;
  }

  /^[[:space:]]*\[.+\][[:space:]]*$/ {
    if ($0 ~ "^[[:space:]]*\\[" section "\\][[:space:]]*$") {
      in_target_section = 1;
    } else {
      in_target_section = 0;
    }
  }

  {
    if (!key_found) {
      if (in_target_section && section != "" && $0 ~ "^[[:space:]]*" sub_key "[[:space:]]*=") {
          match($0, /^[[:space:]]*/);
          indent = substr($0, RSTART, RLENGTH);
          # Detecta se o valor é um número (inteiro ou decimal)
          if (new_value ~ /^[0-9]+(\.[0-9]+)?$/) {
            $0 = indent sub_key " = " new_value;
          } else {
            $0 = indent sub_key " = \"" new_value "\"";
          }
          key_found = 1;
      }
      else if ($0 ~ "^[[:space:]]*" full_key_escaped "[[:space:]]*=") {
          match($0, /^[[:space:]]*/);
          indent = substr($0, RSTART, RLENGTH);
          # Detecta se o valor é um número (inteiro ou decimal)
          if (new_value ~ /^[0-9]+(\.[0-9]+)?$/) {
            $0 = indent full_key " = " new_value;
          } else {
            $0 = indent full_key " = \"" new_value "\"";
          }
          key_found = 1;
      }
    }
    print
  }
  ' "$file" > "$temp_file"

  mv "$temp_file" "$file"
}
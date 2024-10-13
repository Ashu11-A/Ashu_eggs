export DEBUG=1
## export LANG_PATH="Lang/test.conf"

export LANG_PATH="https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/refs/heads/main/Lang/test.conf"

source Utils/loadLang.sh

rm -r logs

# Usar as traduções como variáveis globais
echo "$hello"
echo "$world"
# Carrega as traduções
loadAllTranslations "$selected_language"

# Variáveis
version_egg="1.0"
version_script="1.0"

# Usando as variáveis de tradução
echo "${version_script}"
if [[ -f "./logs/egg_version" ]]; then
    versions="$(cat ./logs/egg_version)"
    comm1=$(printf '%s\n' "$versions" | tr -d '.')
    comm2=$(printf '%s\n' "${version_egg}" | tr -d '.')
    if [ "${ATZ_SYSTEM}" = "1" ]; then
        if [ "${comm1}" -ge "${comm2}" ]; then
            echo "${egg_updated}"
        else
            echo "
${egg_outdated}
${installed_version}
${latest_version}
${access_link}
"
        fi
    fi
else
    echo "
${egg_outdated}
${installed_version}
${reinstall_message}
${latest_version}
${access_link}
"
fi
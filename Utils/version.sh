export LANG_PATH="https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/refs/heads/main/Lang/version.conf"
source <(curl -s https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/refs/heads/main/Utils/lang.sh)

# Usando as variáveis de tradução
printf "$version_script\n" "$version_script_egg"

if [[ -f "./logs/egg_version" ]]; then
    versions="$(cat ./logs/egg_version)"
    comm1=$(printf '%s\n' "$versions" | tr -d '.')
    comm2=$(printf '%s\n' "$version_egg" | tr -d '.')

    if [ "$ATZ_SYSTEM" = "1" ]; then
        if [ "$comm1" -ge "$comm2" ]; then
            echo "$egg_updated"
        else
            echo "$egg_outdated"
            printf "$installed_version\n" "$versions"
            printf "$latest_version\n" "$version_egg"
            echo "$access_link"
        fi
    fi
else
    echo "$egg_outdated"
    printf "$installed_version\n" "1.0 ($respectively)"
    echo "$reinstall_message"
    printf "$latest_version\n" "$version_egg"
    echo "$access_link"
fi
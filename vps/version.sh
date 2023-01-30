version_egg="2.0"
version_script="2.1"

if [[ -f "./libraries/version" ]]; then
    versions=" $(cat ./libraries/version) " 
    comm1=$( printf '%s\n' "$versions" | tr -d '.' )
    comm2=$( printf '%s\n' "$version_egg" | tr -d '.' )
    if [[ -f "./libraries/version_system" ]]; then
        version_system=" $(cat ./libraries/version_system) " 
        if [ "$version_system" = "true" ]; then
            if [ "$comm1" -ge "$comm2"  ]; then
                echo "✅  Egg Atualizado."
            else
                echo "
    
⚠️  Egg Desatualizado.
🔴  Versão Instalado: ${versions}
🟢  Versão mais Recente: ${version_egg}
🌐  Acesse: https://github.com/Ashu11-A/Ashu_eggs
    
"
            fi
        fi
    fi
else
    echo "
    
⚠️  Egg Desatualizado.
🔴  Versão Instalado: 1.0 (respectivamente).
🟠  Caso tenha acabado de atualizar o Egg, basta Reinstalar seu Servidor (nada será apagado).
🟢  Versão mais Recente: ${version_egg}
🌐  Acesse: https://github.com/Ashu11-A/Ashu_eggs
    
"
fi
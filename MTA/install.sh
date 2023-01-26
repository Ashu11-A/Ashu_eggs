#!/bin/bash
if [[ -f "./mta-server64" ]]; then
    bash <(curl -s https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/MTA/start.sh)
else

    mkdir -p /mnt/server
    cd /mnt/server
    curl -L -o multitheftauto_linux_x64.tar.gz https://linux.mtasa.com/dl/multitheftauto_linux_x64.tar.gz
    curl -L -o mta-baseconfig.tar.gz https://linux.mtasa.com/dl/baseconfig.tar.gz
    curl -L -o mtasa-resources-latest.zip http://mirror.mtasa.com/mtasa/resources/mtasa-resources-latest.zip
    tar -xvzf multitheftauto_linux_x64.tar.gz
    cp -rf multitheftauto_linux_x64/* ./
    if [ ! -f /mnt/server/x64/libmysqlclient.so.16 ]; then
        curl -L http://nightly.mtasa.com/files/libmysqlclient.so.16 -o /mnt/server/x64/libmysqlclient.so.16
    fi
    mkdir -p /mnt/server/mods/deathmatch/resources
    unzip -o -d /mnt/server/mods/deathmatch/resources mtasa-resources-latest.zip
    mkdir -p /mnt/server-conf
    tar -xvf mta-baseconfig.tar.gz
    cp -rf baseconfig/* /mnt/server/mods/deathmatch
    rm multitheftauto_linux_x64.tar.gz
    rm mtasa-resources-latest.zip
    rm mta-baseconfig.tar.gz
    cat <<EOF > /mnt/server/mods/deathmatch/mtaserver.conf
<config>
<!-- Este parâmetro especifica o nome que o servidor estará visível como no navegador
do servidor do jogo e no Game-Monitor. É um parâmetro obrigatório. -->
<servername>Default MTA Server</servername>
<serverport>22003</serverport>
<!-- Este parâmetro especifica o número máximo de slots de jogador disponíveis no servidor;
valor padrão: 32. É um parâmetro obrigatório. -->
<maxplayers>32</maxplayers>
<!-- Este parâmetro especifica se o servidor http construído será utilizado.
Valores: 0 - Desativado , 1 - Ativado ; valor padrão: 1. Parâmetro opcional. -->
<httpserver>1</httpserver>
<!-- Este parâmetro especifica a porta TCP na qual o servidor estará aceitando http de entrada
conexões. Pode ser ajustado para o mesmo valor que <serverport>. É um parâmetro obrigatório
se <httpserver> estiver definido para 1. -->
<httpport>22005</httpport>
<!-- Se definido, os jogadores terão que fornecer uma senha especificada abaixo, antes de poderem se conectar ao
servidor. Se deixado em branco, o servidor não requer uma senha deles. -->
<password></password>
<!-- Este parâmetro reduz o uso da largura de banda do servidor, utilizando várias otimizações.
Valores: none, medium or maximum ; valor padrão: medium -->
<bandwidth_reduction>medium</bandwidth_reduction>
<!-- Especifica o limite de taxa de quadros que será aplicado para conectar clientes.
Faixa disponível: 25 a 100. Default: 36. -->
<fpslimit>36</fpslimit>
</config>
EOF
chown -R root:root /mnt
export HOME=/mnt/server
echo "done"
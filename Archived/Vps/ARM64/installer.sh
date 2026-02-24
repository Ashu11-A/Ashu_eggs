#!/bin/bash
HOME="/home/container"
HOMEA="$HOME/linux/.apt"
STAR1="$HOMEA/lib:$HOMEA/usr/lib:$HOMEA/var/lib:$HOMEA/usr/lib/x86_64-linux-gnu:$HOMEA/lib/x86_64-linux-gnu:$HOMEA/lib:$HOMEA/usr/lib/sudo"
STAR2="$HOMEA/usr/include/x86_64-linux-gnu:$HOMEA/usr/include/x86_64-linux-gnu/bits:$HOMEA/usr/include/x86_64-linux-gnu/gnu"
STAR3="$HOMEA/usr/share/lintian/overrides/:$HOMEA/usr/src/glibc/debian/:$HOMEA/usr/src/glibc/debian/debhelper.in:$HOMEA/usr/lib/mono"
STAR4="$HOMEA/usr/src/glibc/debian/control.in:$HOMEA/usr/lib/x86_64-linux-gnu/libcanberra-0.30:$HOMEA/usr/lib/x86_64-linux-gnu/libgtk2.0-0"
STAR5="$HOMEA/usr/lib/x86_64-linux-gnu/gtk-2.0/modules:$HOMEA/usr/lib/x86_64-linux-gnu/gtk-2.0/2.10.0/immodules:$HOMEA/usr/lib/x86_64-linux-gnu/gtk-2.0/2.10.0/printbackends"
STAR6="$HOMEA/usr/lib/x86_64-linux-gnu/samba/:$HOMEA/usr/lib/x86_64-linux-gnu/pulseaudio:$HOMEA/usr/lib/x86_64-linux-gnu/blas:$HOMEA/usr/lib/x86_64-linux-gnu/blis-serial"
STAR7="$HOMEA/usr/lib/x86_64-linux-gnu/blis-openmp:$HOMEA/usr/lib/x86_64-linux-gnu/atlas:$HOMEA/usr/lib/x86_64-linux-gnu/tracker-miners-2.0:$HOMEA/usr/lib/x86_64-linux-gnu/tracker-2.0:$HOMEA/usr/lib/x86_64-linux-gnu/lapack:$HOMEA/usr/lib/x86_64-linux-gnu/gedit"
STARALL="$STAR1:$STAR2:$STAR3:$STAR4:$STAR5:$STAR6:$STAR7"
export LD_LIBRARY_PATH=$STARALL
export PATH="/bin:/usr/bin:/usr/local/bin:/sbin:$HOMEA/bin:$HOMEA/usr/bin:$HOMEA/sbin:$HOMEA/usr/sbin:$HOMEA/etc/init.d:$PATH"
export BUILD_DIR=$HOMEA

bold=$(echo -en "\e[1m")
nc=$(echo -en "\e[0m")
lightblue=$(echo -en "\e[94m")
lightgreen=$(echo -en "\e[92m")
lightred=$(echo -en "\e[31m")
redback=$(echo -en "\e[41m")

version_egg="2.0"
version_script="2.0"

echo "
${bold}${lightgreen}===================================================================================
                                                                                                  
${bold}${lightblue}@@@@@@@   @@@@@@@  @@@@@@@@  @@@@@@@    @@@@@@      @@@  @@@  @@@@@@@    @@@@@@   
${bold}${lightblue}@@@@@@@@  @@@@@@@  @@@@@@@@  @@@@@@@@  @@@@@@@@     @@@  @@@  @@@@@@@@  @@@@@@@   
${bold}${lightblue}@@!  @@@    @@!    @@!       @@!  @@@  @@!  @@@     @@!  @@@  @@!  @@@  !@@       
${bold}${lightblue}!@!  @!@    !@!    !@!       !@!  @!@  !@!  @!@     !@!  @!@  !@!  @!@  !@!       
${bold}${lightblue}@!@@!@!     @!!    @!!!:!    @!@!!@!   @!@  !@!     @!@  !@!  @!@@!@!   !!@@!!    
${bold}${lightblue}!!@!!!      !!!    !!!!!:    !!@!@!    !@!  !!!     !@!  !!!  !!@!!!     !!@!!!   
${bold}${lightblue}!!:         !!:    !!:       !!: :!!   !!:  !!!     :!:  !!:  !!:            !:!  
${bold}${lightblue}:!:         :!:    :!:       :!:  !:!  :!:  !:!      ::!!:!   :!:           !:!   
${bold}${lightblue} ::          ::     :: ::::  ::   :::  ::::: ::       ::::     ::       :::: ::   
${bold}${lightblue} :           :     : :: ::    :   : :   : :  :         :       :        :: : :     
                                                                                                  
                                                                                                                
${bold}${lightgreen}===================================================================================
 "
if [ -z "$LINUX_ISO" ]; then
    linux_iso="https://github.com/termux/proot-distro/releases/download/v3.3.0/debian-aarch64-pd-v3.3.0.tar.xz"
    bash=("/bin/bash -c")
    cmds=("mv gotty /usr/bin/" "mv unzip /usr/bin/" "mv ngrok /usr/bin/" "apt clean" "apt-get update" "apt-get -y upgrade" "apt-get -y install sudo curl wget hwloc htop nano neofetch python3" "curl -o /bin/systemctl https://raw.githubusercontent.com/gdraheim/docker-systemctl-replacement/master/files/docker/systemctl3.py" "chmod +x /bin/systemctl")
else
    if [ $LINUX_ISO = "Debian" ]; then
        linux_iso="https://github.com/termux/proot-distro/releases/download/v3.3.0/debian-aarch64-pd-v3.3.0.tar.xz"
        bash=("/bin/bash -c")
        cmds=("mv gotty /usr/bin/" "mv unzip /usr/bin/" "mv ngrok /usr/bin/" "apt clean" "apt-get update" "apt-get -y upgrade" "apt-get -y install sudo curl wget hwloc htop nano neofetch python3" "curl -o /bin/systemctl https://raw.githubusercontent.com/gdraheim/docker-systemctl-replacement/master/files/docker/systemctl3.py" "chmod +x /bin/systemctl")
    fi
    if [ $LINUX_ISO = "Ubuntu" ]; then
        linux_iso="https://partner-images.canonical.com/core/bionic/current/ubuntu-bionic-core-cloudimg-arm64-root.tar.gz"
        bash=("/bin/bash -c")
        cmds=("mv gotty /usr/bin/" "mv unzip /usr/bin/" "mv ngrok /usr/bin/" "apt clean" "rm -rf /etc/apt/trusted.gpg.d/*" "apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3B4FE6ACC0B21F32" "apt-get update" "apt-get -y upgrade" "apt-get -y install sudo curl wget hwloc htop nano neofetch python3" "curl -o /bin/systemctl https://raw.githubusercontent.com/gdraheim/docker-systemctl-replacement/master/files/docker/systemctl3.py" "chmod +x /bin/systemctl")
    fi
    if [ $LINUX_ISO = "Alpine" ]; then
        linux_iso="https://github.com/termux/proot-distro/releases/download/v3.3.0/alpine-aarch64-pd-v3.3.0.tar.xz"
        bash=("/bin/ash -c")
        cmds=("apk cache clean" "apk update" "apk upgrade" "apk add --upgrade sudo curl wget hwloc htop nano neofetch python3 unzip" "/bin/ash curl -o /bin/systemctl https://raw.githubusercontent.com/gdraheim/docker-systemctl-replacement/master/files/docker/systemctl3.py" "chmod +x /bin/systemctl")
    fi
fi

console=$([ "${CONSOLE}" == "1" ] && echo "${CONSOLE_OCC}" || echo "-0 -r . -b /dev -b /proc -b /sys -w /")

echo "${nc}"

if [[ -f "./libraries/instalado" ]]; then
echo "⚙️  Versão do Script: ${version_script}"
    if [[ -f "./libraries/version" ]]; then
        versions=" $(cat ./libraries/version) " 
        comm1=$( printf '%s\n' "$versions" | tr -d '.' )
        comm2=$( printf '%s\n' "$version_egg" | tr -d '.' )
        if [[ -f "./libraries/version_system" ]]; then
            version_system=" $(cat ./libraries/version_system) " 
            if [ $version_system = "true" ]; then
                if [ $comm1 -ge $comm2  ]; then
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
    echo "✅  Iniciando VPS"
    echo "${bold}${lightgreen}==> ${lightblue}Container${lightgreen} Iniciado <=="
    function runcmd1 {
        printf "${bold}${lightgreen}Default${nc}@${lightblue}Container${nc}:~ "
        read -r cmdtorun
        ./libraries/proot $console $bash "$cmdtorun"
        runcmd
    }
    function runcmd {
        printf "${bold}${lightgreen}Default${nc}@${lightblue}Container${nc}:~ "
        read -r cmdtorun
        ./libraries/proot $console $bash "$cmdtorun"
        runcmd1
    }
    runcmd
else
    echo "${bold}${lightblue}                    ...Arquitetura aarch64 detectada..."
    echo "${bold}${lightblue}          ...ISTO PODE DEMORAR MAIS DE 15 MINUTOS SEJA PACIENTE..."
    if [ $LINUX_ISO = "Ubuntu" ]; then
    echo "${redback} NÃO ESTÁ FUNCIONADO A DISTRO UBUNTU NO MOMENTO!!"
    exit
    fi
    echo  "${bold}${lightred} Distribuições Debian/Ubuntu podem levar mais de 15min para terminar a instalação."
    echo "⚙️  Versão do Script: ${version_script}"
    echo "Baixando arquivos para iniciar a vps"
    mkdir -p libraries
    echo "Disto Instalada: $LINUX_ISO" > libraries/distro_installed
    echo "true" > libraries/version_system
    curl -sSLo ./libraries/proot https://github.com/proot-me/proot/releases/download/v5.3.0/proot-v5.3.0-aarch64-static >/dev/null 2>libraries/err.log
    echo  '#                   (5%)'
    curl -sSLo root.tar.xz $linux_iso >/dev/null 2>libraries/err.log
    echo  '##                  (10%)'
    if [ $LINUX_ISO = "Alpine" ]; then
        echo  'Pulando Download de arquivos incompatíveis com o Alpine.'
    else
        curl -sSLo ngrok.tgz https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-arm64.tgz >/dev/null 2>libraries/err.log
        echo  '####                (20%)'
        curl -sSLo gotty.tar.gz https://github.com/sorenisanerd/gotty/releases/download/v1.5.0/gotty_v1.5.0_linux_arm64.tar.gz >/dev/null 2>libraries/err.log
    fi
    echo  '#####               (25%)'
    export PATH="/bin:/usr/bin:/usr/local/bin:/sbin:$HOMEA/bin:$HOMEA/usr/bin:$HOMEA/sbin:$HOMEA/usr/sbin:$HOMEA/etc/init.d:$PATH"
    echo  '######              (30%)'
    tar -xvf root.tar.xz >/dev/null 2>libraries/err.log
    echo  '#######             (35%)'
    chmod +x ./libraries/proot >/dev/null 2>libraries/err.log
    echo  '########            (40%)'
    if [ $LINUX_ISO = "Alpine" ]; then
    echo  '########            (45%)'
    echo  '##########          (50%)'
    else
    echo "nameserver 8.8.8.8" > etc/resolv.conf
    tar -cvzf ngrok.tgz >/dev/null 2>libraries/err.log
    echo  '#########           (45%)'
    chmod +x ngrok >/dev/null 2>libraries/err.log
    echo  '##########          (50%)'
    tar -xzvf gotty.tar.gz >/dev/null 2>libraries/err.log
    chmod +x gotty >/dev/null 2>libraries/err.log
    fi
    echo  '###########         (55%)'
    rm -rf root.tar.xz >/dev/null 2>libraries/err.log
    rm -rf gotty.tar.gz >/dev/null 2>libraries/err.log
    rm -rf ngrok.tgz >/dev/null 2>libraries/err.log
    echo  '############        (60%)'
    if [ $LINUX_ISO = "Alpine" ]; then
        chmod -R 775 alpine-aarch64
        mv alpine-aarch64/* ./
        rm -r alpine-aarch64
    fi
    if [ $LINUX_ISO = "Alpine" ]; then
        echo  '############        (80%)'
    else
        echo  "${bold}${lightred} Distribuições Debian/Ubuntu podem levar mais de 15min para terminar a instalação."
    fi

    for cmd in "${cmds[@]}"; do
        ./libraries/proot $console $bash "$cmd >/dev/null 2>libraries/err.log"
    done
    echo  '####################(100%)'
    touch ./libraries/instalado
    
    echo "
${bold}${lightgreen}===================================================================================
                                                                                                  
${bold}${lightblue}@@@@@@@   @@@@@@@  @@@@@@@@  @@@@@@@    @@@@@@      @@@  @@@  @@@@@@       @@@@@@@ 
${bold}${lightblue}@@@@@@@@  @@@@@@@  @@@@@@@@  @@@@@@@@  @@@@@@@@     @@@  @@@  @@@@@@@@   @@@@@@@ 
${bold}${lightblue}@@!  @@@    @@!    @@!       @@!  @@@  @@!  @@@     @@!  @@@  @@!   @@!  @@!  
${bold}${lightblue}!@!  @!@    !@!    !@!       !@!  @!@  !@!  @!@     !@!  @!@  !@!   @!@  !@!   
${bold}${lightblue}@!@@!@!     @!!    @!!!:!    @!@!!@!   @!@  !@!     @!@  !@!  @!@!@!@!    !@!@!@!   
${bold}${lightblue}!!@!!!      !!!    !!!!!:    !!@!@!    !@!  !!!     !@!  !!!  !@!!@!@      !@!!@!@    
${bold}${lightblue}!!:         !!:    !!:       !!: :!!   !!:  !!!     :!:  !!:  !::              !::
${bold}${lightblue}:!:         :!:    :!:       :!:  !:!  :!:  !:!      ::!!:!   :!:              :!:      
${bold}${lightblue} ::          ::     :: ::::  ::   :::  ::::: ::       ::::    :::          :::::::     
${bold}${lightblue} :           :     : :: ::    :   : :   : :  :         :      :::        :::::::         
                                                                                                  
                                                                                                                
${bold}${lightgreen}===================================================================================
 "
 
echo "${nc}"
    
    echo "${bold}${lightgreen}==> ${lightblue}Container${lightgreen} Iniciado <=="
    function runcmd1 {
        printf "${bold}${lightgreen}Default${nc}@${lightblue}Container${nc}:~ "
        read -r cmdtorun
        ./libraries/proot $console $bash "$cmdtorun"
        runcmd
    }
    function runcmd {
        printf "${bold}${lightgreen}Default${nc}@${lightblue}Container${nc}:~ "
        read -r cmdtorun
        ./libraries/proot $console $bash "$cmdtorun"
        runcmd1
    }
    runcmd
fi

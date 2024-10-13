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
if [ -z "$INSTALL" ]; then
    install="0"
else
    install="$INSTALL"
fi

if [ -z "$LINUX_ISO" ]; then
    linux_iso="https://github.com/termux/proot-distro/releases/download/v3.3.0/debian-x86_64-pd-v3.3.0.tar.xz"
    bash=("/bin/bash -c")
    if [ -z "$INSTALL" ]; then
        cmds=("mv gotty /usr/bin/" "mv unzip /usr/bin/" "mv ngrok /usr/bin/" "apt clean" "apt-get update" "apt-get -y upgrade" "apt-get -y install sudo curl wget hwloc htop nano neofetch python3 fakechroot fakeroot")
    fi
else
    if [ $LINUX_ISO = "Debian" ]; then
        linux_iso="https://github.com/termux/proot-distro/releases/download/v3.3.0/debian-x86_64-pd-v3.3.0.tar.xz"
        bash=("/bin/bash -c")
    if [ $install = "0" ]; then
        cmds=("mv gotty /usr/bin/" "mv unzip /usr/bin/" "mv ngrok /usr/bin/" "apt clean" "apt-get update" "apt-get -y upgrade" "apt-get -y install sudo curl wget hwloc htop nano neofetch python3 fakechroot fakeroot")
        else
        cmds=("apt clean" "apt-get update" "apt-get -y upgrade" "apt-get -y install python3")
        fi
    fi
    if [ $LINUX_ISO = "Ubuntu" ]; then
        linux_iso="https://partner-images.canonical.com/core/bionic/current/ubuntu-bionic-core-cloudimg-amd64-root.tar.gz"
        bash=("/bin/bash -c")
        if [ $install = "0" ]; then
        cmds=("mv gotty /usr/bin/" "mv unzip /usr/bin/" "mv ngrok /usr/bin/" "apt clean" "rm -rf /etc/apt/trusted.gpg.d/*" "apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3B4FE6ACC0B21F32" "apt-get update" "apt-get -y upgrade" "apt-get -y install sudo curl wget hwloc htop nano neofetch python3 fakechroot fakeroot")
        else
        cmds=("apt clean" "apt-get update" "apt-get -y upgrade" "apt-get -y install python3")
        fi
    fi
    if [ $LINUX_ISO = "Alpine" ]; then
        linux_iso="https://github.com/termux/proot-distro/releases/download/v3.3.0/alpine-x86_64-pd-v3.3.0.tar.xz"
        bash=("/bin/ash -c")
        if [ $install = "0" ]; then
        cmds=("apk cache clean" "apk update" "apk upgrade" "apk add --upgrade sudo curl wget hwloc htop nano neofetch python3 unzip")
        else
        cmds=("apk cache clean" "apk update" "apk upgrade")
        fi
    fi
fi

console=$([ "${CONSOLE}" == "1" ] && echo "${CONSOLE_OCC}" || echo "-0 -r . -b /dev -b /proc -b /sys -w / -b .")

if [ -z "${PROOT}" ]; then
    proot="./libraries/proot"
fi
if [ "${PROOT}" = "PRoot (padrão)" ]; then
    proot="./libraries/proot"
fi
if [ "${PROOT}" = "PRoot-rs" ]; then
    proot="./libraries/proot-rs"
fi
if [ "${PROOT}" = "FakechRoot + FakeRoot" ]; then
    proot="fakechroot fakeroot"
fi

echo "${nc}"

if [[ -f "./libraries/instalado" ]]; then

    if [ "${PROOT}" = "PRoot-rs" ]; then
        echo "

${bold}${lightred}⛔️  Root executado a partir do PRoot-rs, você sabe oque está fazendo?
        "
    fi
    if [ "${PROOT}" = "FakechRoot + FakeRoot" ]; then
        echo "

${bold}${lightred}⛔️  Root executado a partir do FakechRoot + FakeRoot, você sabe oque está fazendo?
${bold}${lightred}⛔️  Para utilizar essa variável, você tem que estar usado o docker: ashu11a/proot:latest
        "
    fi
    bash <(curl -s https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/pt-BR/vps/version.sh)
    echo "✅  Iniciando VPS"
    echo "${bold}${lightgreen}==> ${lightblue}Container${lightgreen} Iniciado <=="
    function runcmd1 {
        printf "${bold}${lightgreen}Default${nc}@${lightblue}Container${nc}:~ "
        read -r cmdtorun
        $proot  $console $bash "$cmdtorun"
        runcmd
    }
    function runcmd {
        printf "${bold}${lightgreen}Default${nc}@${lightblue}Container${nc}:~ "
        read -r cmdtorun
        $proot $console $bash "$cmdtorun"
        runcmd1
    }
    runcmd
else
    echo "${bold}${lightblue}🔎  Arquitetura Identificada: 64x"
    if [ $LINUX_ISO = "Ubuntu" ]; then
    echo "${redback} A DISTRO UBUNTU NÃO ESTÁ FUNCIONADO NO MOMENTO!!"
    exit
    fi
    if [ $install = "1" ]; then
    echo  "
📌  Variavel: (Instalação Limpa) 🟢  Ativada
📌  Os seguintes pacotes não serão Instalados: sudo wget hwloc htop nano neofetch ngrok gotty curl
    "
    else
    echo  "${bold}${lightred}⚠️  Distribuições Debian/Ubuntu podem levar mais de 15min para terminar a instalação."
    fi
    echo "📥  Baixando arquivos para instalação da vps"
    if [ -d libraries ]; then
    echo "Pasta libraries já existe, pulando..."
    else
    mkdir -p libraries
    fi
    echo "Disto Instalada: $LINUX_ISO" > libraries/distro_installed
    echo "true" > libraries/version_system
    curl -sSLo ./libraries/proot https://github.com/proot-me/proot/releases/download/v5.3.0/proot-v5.3.0-x86_64-static >/dev/null 2>libraries/err.log
    curl -sSLo proot-rs-x86_64.tar.gz https://github.com/proot-me/proot-rs/releases/download/v0.1.0/proot-rs-v0.1.0-x86_64-unknown-linux-gnu.tar.gz >/dev/null 2>libraries/err.log
    echo  '#                   (5%)'
    curl -sSLo root.tar.xz $linux_iso >/dev/null 2>libraries/err.log
    echo  '##                  (10%)'
    if [ $LINUX_ISO = "Alpine" ]; then
        echo  'Pulando Download de arquivos incompatíveis com o Alpine.'
    else
        if [ $install = "0" ]; then
            curl -sSLo ngrok.tgz https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz >/dev/null 2>libraries/err.log
            echo  '####                (20%)'
            curl -sSLo gotty.tar.gz https://github.com/sorenisanerd/gotty/releases/download/v1.5.0/gotty_v1.5.0_linux_amd64.tar.gz >/dev/null 2>libraries/err.log
        fi
    fi
    echo  '#####               (25%)'
    export PATH="/bin:/usr/bin:/usr/local/bin:/sbin:$HOMEA/bin:$HOMEA/usr/bin:$HOMEA/sbin:$HOMEA/usr/sbin:$HOMEA/etc/init.d:$PATH"
    echo  '######              (30%)'
    tar -xvf root.tar.xz >/dev/null 2>libraries/err.log
    curl -o /bin/systemctl https://raw.githubusercontent.com/gdraheim/docker-systemctl-replacement/master/files/docker/systemctl3.py >/dev/null 2>libraries/err.log
    chmod +x /bin/systemctl >/dev/null 2>libraries/err.log
    echo  '#######             (35%)'
    tar -xzvf proot-rs-x86_64.tar.gz >/dev/null 2>libraries/err.log
    mv proot-rs ./libraries/
    chmod +x ./libraries/proot >/dev/null 2>libraries/err.log
    chmod +x ./libraries/proot-rs >/dev/null 2>libraries/err.log
    echo  '########            (40%)'
    if [ $LINUX_ISO = "Alpine" ]; then
    echo  '########            (45%)'
    echo  '##########          (50%)'
    else
    echo "nameserver 8.8.8.8" > etc/resolv.conf
        if [ $install = "0" ]; then
            tar -cvzf ngrok.tgz >/dev/null 2>libraries/err.log
            echo  '#########           (45%)'
            chmod +x ngrok >/dev/null 2>libraries/err.log
            echo  '##########          (50%)'
            tar -xzvf gotty.tar.gz >/dev/null 2>libraries/err.log
            chmod +x gotty >/dev/null 2>libraries/err.log
        fi
    fi
    echo  '###########         (55%)'
    rm -rf proot-rs-x86_64.tar.gz >/dev/null 2>libraries/err.log
    rm -rf root.tar.xz >/dev/null 2>libraries/err.log
    rm -rf gotty.tar.gz >/dev/null 2>libraries/err.log
    rm -rf ngrok.tgz >/dev/null 2>libraries/err.log
    echo  '############        (60%)'
    if [ $LINUX_ISO = "Alpine" ]; then
        chmod -R 775 alpine-x86_64
        mv alpine-x86_64/* ./
        rm -r alpine-x86_64
    fi
    if [ $LINUX_ISO = "Alpine" ]; then
        echo  '############        (80%)'
    else
        if [ $install = "0" ]; then
            echo  "${bold}${lightred}⚠️  Essa é a etapa mais demorada, pode levar até 15min para termina-la"
        fi
    fi

    for cmd in "${cmds[@]}"; do
        $proot $console $bash "$cmd >/dev/null 2>libraries/err.log"
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
    bash <(curl -s https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/pt-BR/vps/version.sh)
    echo "${bold}${lightgreen}==> ${lightblue}Container${lightgreen} Iniciado <=="
    function runcmd1 {
        printf "${bold}${lightgreen}Default${nc}@${lightblue}Container${nc}:~ "
        read -r cmdtorun
        $proot $console $bash "$cmdtorun"
        runcmd
    }
    function runcmd {
        printf "${bold}${lightgreen}Default${nc}@${lightblue}Container${nc}:~ "
        read -r cmdtorun
        $proot $console $bash "$cmdtorun"
        runcmd1
    }
    runcmd
fi

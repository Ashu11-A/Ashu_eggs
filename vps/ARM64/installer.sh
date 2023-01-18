#!/bin/bash
HOME="/home/container"
HOMEA="$HOME/linux/.apt"
STAR1="$HOMEA/lib:$HOMEA/usr/lib:$HOMEA/var/lib:$HOMEA/usr/lib/aarch64-linux-gnu:$HOMEA/lib/aarch64-linux-gnu:$HOMEA/lib:$HOMEA/usr/lib/sudo"
STAR2="$HOMEA/usr/include/aarch64-linux-gnu:$HOMEA/usr/include/aarch64-linux-gnu/bits:$HOMEA/usr/include/aarch64-linux-gnu/gnu"
STAR3="$HOMEA/usr/share/lintian/overrides/:$HOMEA/usr/src/glibc/debian/:$HOMEA/usr/src/glibc/debian/debhelper.in:$HOMEA/usr/lib/mono"
STAR4="$HOMEA/usr/src/glibc/debian/control.in:$HOMEA/usr/lib/aarch64-linux-gnu/libcanberra-0.30:$HOMEA/usr/lib/aarch64-linux-gnu/libgtk2.0-0"
STAR5="$HOMEA/usr/lib/aarch64-linux-gnu/gtk-2.0/modules:$HOMEA/usr/lib/aarch64-linux-gnu/gtk-2.0/2.10.0/immodules:$HOMEA/usr/lib/aarch64-linux-gnu/gtk-2.0/2.10.0/printbackends"
STAR6="$HOMEA/usr/lib/aarch64-linux-gnu/samba/:$HOMEA/usr/lib/aarch64-linux-gnu/pulseaudio:$HOMEA/usr/lib/aarch64-linux-gnu/blas:$HOMEA/usr/lib/aarch64-linux-gnu/blis-serial"
STAR7="$HOMEA/usr/lib/aarch64-linux-gnu/blis-openmp:$HOMEA/usr/lib/aarch64-linux-gnu/atlas:$HOMEA/usr/lib/aarch64-linux-gnu/tracker-miners-2.0:$HOMEA/usr/lib/aarch64-linux-gnu/tracker-2.0:$HOMEA/usr/lib/aarch64-linux-gnu/lapack:$HOMEA/usr/lib/aarch64-linux-gnu/gedit"
STARALL="$STAR1:$STAR2:$STAR3:$STAR4:$STAR5:$STAR6:$STAR7"
export LD_LIBRARY_PATH=$STARALL
export PATH="/bin:/usr/bin:/usr/local/bin:/sbin:$HOMEA/bin:$HOMEA/usr/bin:$HOMEA/sbin:$HOMEA/usr/sbin:$HOMEA/etc/init.d:$PATH"
export BUILD_DIR=$HOMEA

bold=$(echo -en "\e[1m")
nc=$(echo -en "\e[0m")
lightblue=$(echo -en "\e[94m")
lightgreen=$(echo -en "\e[92m")

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

if [[ -f "./instalado" ]]; then
    echo "${bold}${lightgreen}==> Started ${lightblue}Container${lightgreen} <=="
    function runcmd1 {
        printf "${bold}${lightgreen}Default${nc}@${lightblue}Container${nc}:~ "
        read -r cmdtorun
        ./libraries/proot -S . /bin/bash -c "$cmdtorun"
        runcmd
    }
    function runcmd {
        printf "${bold}${lightgreen}Default${nc}@${lightblue}Container${nc}:~ "
        read -r cmdtorun
        ./libraries/proot -S . /bin/bash -c "$cmdtorun"
        runcmd1
    }
    runcmd
else
    echo "${bold}${lightblue}         ...ISTO PODE DEMORAR MAIS DE 15 MINUTOS SEJA PACIENTE..."
    echo "Baixando arquivos para iniciar a vps"
    curl -sSLo ngrok.tgz https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-arm64.tgz >/dev/null 2>err.log
    echo '#                   (5%)'
    mkdir libraries
    curl -sSLo ./libraries/proot https://github.com/proot-me/proot/releases/download/v5.3.0/proot-v5.3.0-aarch64-static >/dev/null 2>err.log
    echo '##                  (10%)'
    curl -sSLo root.tar.xz https://github.com/termux/proot-distro/releases/download/v3.3.0/debian-aarch64-pd-v3.3.0.tar.xz >/dev/null 2>err.log
    echo '####                (20%)'
    curl -sSLo gotty.tar.gz https://github.com/sorenisanerd/gotty/releases/download/v1.5.0/gotty_v1.5.0_linux_arm64.tar.gz >/dev/null 2>err.log
    echo '#####               (25%)'
    export PATH="/bin:/usr/bin:/usr/local/bin:/sbin:$HOMEA/bin:$HOMEA/usr/bin:$HOMEA/sbin:$HOMEA/usr/sbin:$HOMEA/etc/init.d:$PATH"
    echo '######               (30%)'
    tar -xvf root.tar.xz >/dev/null 2>err.log
    echo '#######              (35%)'
    chmod +x ./libraries/proot >/dev/null 2>err.log
    echo '########             (40%)'
    tar -cvzf ngrok.tgz >/dev/null 2>err.log
    echo '#########            (45%)'
    chmod +x ngrok >/dev/null 2>err.log
    echo '##########           (50%)'
    tar -xzvf gotty.tar.gz
    chmod +x gotty >/dev/null 2>err.log
    echo '###########          (55%)'
    rm -rf files.zip >/dev/null 2>err.log
    rm -rf root.zip >/dev/null 2>err.log
    rm -rf root.tar.xz >/dev/null 2>err.log
    rm -rf gotty.tar.gz >/dev/null 2>err.log
    rm -rf ngrok.tgz >/dev/null 2>err.log
    echo '############         (60%)'

    cmds=("mv gotty /usr/bin/" "mv unzip /usr/bin/" "mv ngrok /usr/bin/" "apt-get update" "apt-get -y upgrade" "apt-get -y install sudo curl wget hwloc htop nano neofetch python3" "curl -o /bin/systemctl https://raw.githubusercontent.com/gdraheim/docker-systemctl-replacement/master/files/docker/systemctl3.py")

    for cmd in "${cmds[@]}"; do
        ./libraries/proot -S . /bin/bash -c "$cmd >/dev/null 2>err.log"
    done
    echo -ne '####################(100%)\r'
    echo -ne '\n'
    touch instalado
    
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
    
    echo "${bold}${lightgreen}==> Started ${lightblue}Container${lightgreen} <=="
    function runcmd1 {
        printf "${bold}${lightgreen}Default${nc}@${lightblue}Container${nc}:~ "
        read -r cmdtorun
        ./libraries/proot -S . /bin/bash -c "$cmdtorun"
        runcmd
    }
    function runcmd {
        printf "${bold}${lightgreen}Default${nc}@${lightblue}Container${nc}:~ "
        read -r cmdtorun
        ./libraries/proot -S . /bin/bash -c "$cmdtorun"
        runcmd1
    }
    runcmd
fi

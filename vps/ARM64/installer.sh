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
${bold}${lightgreen}========================================================================
                                                                                                  
${bold}${lightblue}@@@@@@@   @@@@@@@  @@@@@@@@  @@@@@@@    @@@@@@      @@@  @@@  @@@@@@@@@@
${bold}${lightblue}@@@@@@@@  @@@@@@@  @@@@@@@@  @@@@@@@@  @@@@@@@@     @@@  @@@  @@@@@@@@@@@    
${bold}${lightblue}@@!  @@@    @@!    @@!       @@!  @@@  @@!  @@@     @@!  @@@  @@! @@! @@!    
${bold}${lightblue}!@!  @!@    !@!    !@!       !@!  @!@  !@!  @!@     !@!  @!@  !@! !@! !@!     
${bold}${lightblue}@!@@!@!     @!!    @!!!:!    @!@!!@!   @!@  !@!     @!@  !@!  @!! !!@ @!@      
${bold}${lightblue}!!@!!!      !!!    !!!!!:    !!@!@!    !@!  !!!     !@!  !!!  !@!   ! !@!        
${bold}${lightblue}!!:         !!:    !!:       !!: :!!   !!:  !!!     :!:  !!:  !!:     !!:        
${bold}${lightblue}:!:         :!:    :!:       :!:  !:!  :!:  !:!      ::!!:!   :!:     :!:            
${bold}${lightblue} ::          ::     :: ::::  ::   :::  ::::: ::       ::::    :::     ::        
${bold}${lightblue} :           :     : :: ::    :   : :   : :  :         :       :      :          
                                                                                                  
                                                                                                                
${bold}${lightgreen}========================================================================
${bold}${lightblue}          ...ISTO PODE DEMORAR MAIS DE 15 MINUTOS SEJA PACIENTE...
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
    echo "Fazendo o download dos arquivos."
    curl -sSLo ngrok https://github.com/Ashu11-A/Ashu_eggs/raw/main/vps/ARM64/ngrok >/dev/null 2>err.log
    echo -ne '#                   (5%)\r'
    curl -sSLo root.tar.xz https://github.com/termux/proot-distro/releases/download/v2.0.1/debian-aarch64-pd-v2.0.1.tar.xz >/dev/null 2>err.log
    echo -ne '##                  (10%)\r'
    mkdir libraries
    curl -sSLo ./libraries/proot https://github.com/Ashu11-A/Ashu_eggs/raw/main/vps/ARM64/proot-v5.3.0-aarch64-static >/dev/null 2>err.log
    echo -ne '####                (20%)\r'
    curl -sSLo gotty https://github.com/Ashu11-A/Ashu_eggs/raw/main/vps/ARM64/gotty >/dev/null 2>err.log
    echo -ne '#####               (25%)\r'
    chmod +x unzip >/dev/null 2>err.log
    export PATH="/bin:/usr/bin:/usr/local/bin:/sbin:$HOMEA/bin:$HOMEA/usr/bin:$HOMEA/sbin:$HOMEA/usr/sbin:$HOMEA/etc/init.d:$PATH"
    echo -ne '######               (30%)\r'
    tar -xvJf root.tar.xz >/dev/null 2>err.log
    echo "nameserver 8.8.8.8" > ./etc/resolv.conf >/dev/null 2>err.log
    echo -ne '#######              (35%)\r'
    chmod +x ./libraries/proot >/dev/null 2>err.log
    echo -ne '########             (40%)\r'
    chmod +x ngrok >/dev/null 2>err.log
    echo -ne '#########            (45%)\r'
    chmod +x gotty >/dev/null 2>err.log
    echo -ne '##########           (50%)\r'
    #rm -rf root.tar.xz >/dev/null 2>err.log
    echo -ne '###########          (55%)\r'
    echo -ne '############         (60%)\r'

    cmds=("mv gotty /usr/bin/" "mv unzip /usr/bin/" "mv ngrok /usr/bin/" "apt-get update" "apt-get -y upgrade" "apt-get -y install sudo curl wget hwloc htop nano neofetch python3" "curl -o /bin/systemctl https://raw.githubusercontent.com/gdraheim/docker-systemctl-replacement/master/files/docker/systemctl3.py")

    for cmd in "${cmds[@]}"; do
        ./libraries/proot -S . /bin/bash -c "$cmd >/dev/null 2>err.log"
    done
    echo -ne '####################(100%)\r'
    echo -ne '\n'
    touch instalado
    
    echo "
${bold}${lightgreen}========================================================================
                                                                                                  
${bold}${lightblue}@@@@@@@   @@@@@@@  @@@@@@@@  @@@@@@@    @@@@@@      @@@  @@@  @@@@@@@@@@
${bold}${lightblue}@@@@@@@@  @@@@@@@  @@@@@@@@  @@@@@@@@  @@@@@@@@     @@@  @@@  @@@@@@@@@@@    
${bold}${lightblue}@@!  @@@    @@!    @@!       @@!  @@@  @@!  @@@     @@!  @@@  @@! @@! @@!    
${bold}${lightblue}!@!  @!@    !@!    !@!       !@!  @!@  !@!  @!@     !@!  @!@  !@! !@! !@!     
${bold}${lightblue}@!@@!@!     @!!    @!!!:!    @!@!!@!   @!@  !@!     @!@  !@!  @!! !!@ @!@      
${bold}${lightblue}!!@!!!      !!!    !!!!!:    !!@!@!    !@!  !!!     !@!  !!!  !@!   ! !@!        
${bold}${lightblue}!!:         !!:    !!:       !!: :!!   !!:  !!!     :!:  !!:  !!:     !!:        
${bold}${lightblue}:!:         :!:    :!:       :!:  !:!  :!:  !:!      ::!!:!   :!:     :!:            
${bold}${lightblue} ::          ::     :: ::::  ::   :::  ::::: ::       ::::    :::     ::        
${bold}${lightblue} :           :     : :: ::    :   : :   : :  :         :       :      :          
                                                                                                  
                                                                                                                
${bold}${lightgreen}========================================================================
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

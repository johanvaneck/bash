# startup-script.sh
#
# This is my custom startup script for Debian based Linux distro's
# *data usages will apply
#
# run with root privilidges
#


#!/bin/bash


### variables

dateandtime="`date +%y%m%d%H%M%S`"
dir="/home/victorecho/.startup-script"
report="$dir/report.txt"
failreport="$dir/failures.txt"
commands="$dir/commands.txt"


### functions

start(){
	
	# make and/or move to .startup-script directory for downloaded files if needed
	
	if [ ! -d $dir ]	
	then
		 mkdir $dir
		 touch $report
		 touch $failreport
		 touch $commands
	fi

	printf "Report of startup-script on `date`\n\n\n" > $report
	printf "Failures of startup-script on `date`\n\n\n" > $failreport
	echo "" > $commands
}


box(){
    clear
    echo
    echo "#####################################"
    echo "#"
    echo "# Installing $1"
    echo "#"
    echo "#####################################"
    echo

    $2

    if [ ! $? -eq 0 ] 
    then 
	    printf "Failed to install $1\n\n" >> $report
	    printf "$1: $2\n\n" >> $failreport
    else
	    printf "Successfully installed $1\n\n" >> $report
    fi


    printf "\"$2\" " >> $commands
}


ask(){
    clear
    echo
    echo "Safe to stop now."
    echo 
    echo "Press Ctrl + C to stop or do nothing to continue."
    echo 
    echo "Next download starting in..."
    echo
    
    for t in {5..1}
    do
        printf "   $t"
        sleep 1
    done
    
    echo "..."
    echo
}



############### START ###############


# check if user is root

if [ `whoami` != root ]
then 
    echo
    echo 'Please run the script as root or use sudo command.'
    echo
    
    exit
fi
# alternative syntax: 
# [ 'whoami' != root ] && printf "\nPlease run the script as root or use sudo command.\n\n" && exit




# start

start


# Updates and upgrades

box 'system update' "apt update -y"


box 'system upgrade' "apt upgrade -y"



# Utilities

box 'Speedtest-cli' "apt install -y speedtest-cli"


box 'Neofetch' "apt install -y neofetch"


box 'at scheduling command' "apt install -y at"


box 'cowsay' "apt install -y cowsay"



# Web

#box 'Google Chrome' `"if [ `which google-chrome` != /usr/bin/google-chrome ]
#then
#	wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
#	apt install -y ./google-chrome-stable_current_amd64.deb
#else
#	echo 'Google-chrome is already installed.'
#fi"`	


box 'Rambox' "snap install rambox"



# Media

box 'Vlc media player' "apt install -y vlc"


box 'Kdenlive' "apt install -y kdenlive"



# Programming

box 'Vim' "apt install -y vim"


box 'GCC' "apt install -y gcc"


box 'GPP' "apt install -y gpp"


box 'Java' "apt install -y default-jre"


box 'python' "apt install -y python"
box 'python3' "apt install -y python3"
box 'python-pip' "apt install -y python-pip"
box 'python3-pip' "apt install -y python3-pip"
box 'numpy' "pip install numpy"
box 'matplotlib' "pip install matplotlib"
box 'numpy python3' "pip3 install numpy"
box 'matplotlib python3' "pip3 install matplotlib"


box 'IntelliJ IDEA CE' "snap install intellij-idea-community --classic --edge"


box 'Pycharm CE' "snap install pycharm-community --classic --edge"



# Virtualbox

box 'Oracle VM Virtualbox' "apt install -y virtualbox"



############### END ###############

clear
echo
echo "Done."
echo
sleep 3

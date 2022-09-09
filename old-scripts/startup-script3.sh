#!/bin/bash


# startup-script.sh
#
# This is my custom startup script for Debian based Linux distro's
# *data usages will apply
#
# run with root privilidges
#


### variables

dateandtime="`date +%y%m%d%H%M%S`"
dir="/home/victorecho/.startup-script"
report="$dir/report.txt"
installed="$dir/installed.txt"
errors="$dir/errors.txt"


apt_install=("speedtest-cli" "neofetch" "at" "cowsay" "vlc" "kdenlive" "vim" "gcc" "gpp" "default-jre" "python" "python3" "python-pip" "python3-pip" "virtualbox")


snap_install=('intellij-idea-community --classic --edge' 'pycharm-community --classic --edge' 'rambox')


pip_install=("numpy" "matplotlib")



### functions

start(){
	box "system update and upgrade"
	apt update -y 
	apt upgrade -y

   	# create directory and files if needed
        if [ ! -d $dir ]
        then
                 mkdir $dir
                 touch $report
		 touch $installed
                 touch $errors
        fi

        printf "Report of startup-script on `date`\n\n\n" > $report
        printf "Programs installed by startup-script at `date`\n\n" > $installed
        printf "Errors of startup-script on `date`\n\n" > $errors
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
}


rep(){
	if [ $? -eq 0 ]
	then
	      	#printf "%-20 %s \n" "$1" "installed successfully." >> $report
		echo "$1" >> $installed	
	else
		#printf "%-20 %s \n" "$1" "had errors while installing." >> $report
		echo "$1" >> $errors
		
		echo
		echo
		for t in {10..1}
		do 
			printf "   $t"
			sleep 1
		done
	fi
}


finrep(){
	printf "\n\n" >> $installed
	cat $installed $errors >> $report
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
# [ 'whoami' != root ] && printf "\n...\n\n" && exit



start


for c in "${apt_install[@]}"
do
	box "$c"
	apt install -y "$c"
	rep "$c"
done


for c in "${snap_install[@]}"
do
	box "$c"
	snap install $c
	rep "$c"
done


for c in "${pip_install[@]}"
do
	box "$c"
	pip install "$c"
	rep "$c pip"
	pip3 install "$c"
	rep "$c pip3"
done


box 'Google Chrome' 

if [ `which google-chrome` != /usr/bin/google-chrome ]
then
       wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
       apt install -y ./google-chrome-stable_current_amd64.deb
else
       echo 'Google-chrome is already installed.'
fi
rep 'Google Chrome'



############### END ###############
clear
finrep
cat $report
echo
sleep 3
exit











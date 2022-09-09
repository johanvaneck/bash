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



apt_install=("speedtest-cli" "neofetch" "at" "fortune" "lolcat" "cmatrix" "sl" "youtube-dl" "vlc" "kdenlive" "vim" "gcc" "gpp" "default-jre" "python" "python3" "python3-pip" "virtualbox")


snap_install=("snap-store" "intellij-idea-community --classic --edge" "pycharm-community --classic --edge" "rambox" "zoom-client" "mathpix-snipping-tool")


pip_install=("numpy" "matplotlib")



### functions

start(){

	# check if user is root
	
	# if [ `whoami` != root ]
	# then
	#     echo
	#     cowsay 'Please run the script as root or use sudo command.'
	#     echo
	# 
	#     exit
	# fi
	# alternative syntax:
	# [ 'whoami' != root ] && printf "\n...\n\n" && exit


	# update and upgrade system
	sudo apt update -y 
	sudo apt upgrade -y


	# install cowsay
	sudo apt install -y cowsay


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
    
    cowsay "Installing $1"
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




start


for c in "${apt_install[@]}"
do
	box "$c"
	sudo apt install -y "$c"
	rep "$c"
done


for c in "${snap_install[@]}"
do
	box "$c"
	sudo snap install $c
	rep "$c"
done


for c in "${pip_install[@]}"
do
	pip3 install "$c"
	rep "$c pip3"
done


box 'Google Chrome' 

if [ `which google-chrome` != /usr/bin/google-chrome ]
then
       wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
       sudo apt install -y ./google-chrome-stable_current_amd64.deb
       rep 'Google Chrome'
else
       echo 'Google-chrome is already installed.'
fi



clear
finrep
cowsay "All done."
cat $report
echo
sleep 3
exit
############### END ###############

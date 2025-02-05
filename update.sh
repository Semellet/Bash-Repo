#!/bin/bash
# A basic one stop shop to update Linux based systems. Utilising search, standard input/output filtering, and functions to seemlessly update the active distro.

logfile=/var/log/updater.log
errorlog=/var/log/updater_errors.log

check_exit_status() {
	if [ $? -ne 0 ]
	then 
		echo "An error has occurred, please check the $errorlog file."
	else
		echo "The system is now up to date... it may need to be restarted."
	fi
}

if [ -d /etc/pacman.d ]
then 
	# The host is based on Arch and runs the pacman update.
	sudo pacman -Syu 1>>$logfile 2>>$errorlog
	check_exit_status

elif [ -d /etc/dnf ]
then
	# The host is running a Fedora/Redhat based system and runs the dnf update.
	sudo dnf upgrade -y 1>>$logfile 2>>$errorlog
	check_exit_status

elif [ -d /etc/apt ]
then
	# The host is running a Debian based system and runs apt updates.
	sudo apt update && sudo apt dist-upgrade -y 1>>$logfile 2>>$errorlog
	check_exit_status

else
	# The host is not running a standard package manager, so the script needs to be updated to reflect this.
	echo "I cannot identify how to update this system.  Please check the documentation."
fi

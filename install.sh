#! /bin/bash
#
# file: installer.sh
# This is osget version 1.2
# written by Freyr Gunnar Ólafsson
# This program is licenced under the GPL version 3 or higher (if available)

function id_bin () 
{
	local tmp=""
	if [ -x /usr/bin/id ];then
		tmp="/usr/bin/id"
	else
		if [ -x /bin/id ]; then
	    		tmp="/bin/id"
		fi
	fi
	ID=$tmp
}

checkif_root ()
{
        if [ "$(id -u)" -eq 0 ];then
                return 0
        else
                echo "You need root authority!"
                exit
        fi
}


#This is where osget will be installed.
TARGET="/usr/bin"
VERSION="1.2"
ID=""

#check if the files exist
for file in osget osget.8.gz CHANGELOG TODO;do
	if [ ! -e "$file" ];then
		echo "$file is missing from this package. This is usually NOT a good sign."
		echo "I will therefore exit and demand you fetch a fresh version of osget."
		echo "Good day!"
		exit
	fi
done

id_bin
if [ -z "$ID" ];then
	echo "Could not find /usr/bin/id or /bin/id on your sistem. Bailing out!"
	exit 1
fi

if [ ! -d "etc/osget" ];then
	echo "The osget configuration file directory seems to be missing. Bailing out!"
	exit
fi

if [ "$1" = "--install" ];then
	checkif_root
	#check if files are already installed
	if [ -d /etc/osget ] || [ -f $TARGET/osget ]; then
		echo "osget has already been installed!"
		echo "Please make sure to uninstall all files belonging to any and all old versions of osget before installing this version."
		echo "Use --force-install if you are determined to clobber existing files."
		exit
	else
		mkdir -p /etc/osget/
		echo "Installing osget $VERSION"
		echo "Copying files ... "
		cp -v osget $TARGET/
		chown root:root $TARGET/osget
		cp -rfv etc/osget /etc/
		cp -v osget.8.gz /usr/share/man/man8/
		chown -R root:root /etc/osget
		echo "Install complete."
	fi
fi

if [ "$1" = "--force-install" ];then
	checkif_root
	echo "Overriding files ... "
	if [ ! -d /etc/osget ];then
		mkdir /etc/osget
	fi
	
	cp -fv osget $TARGET
	chown root:root $TARGET/osget
	cp -rfv etc/osget /etc/
	cp -fv osget.8.gz /usr/share/man/man8/
	chown -R root:root /etc/osget
	echo "Force install complete."
fi

if [ "$1" = "--help" ] || [ "$1" = "-h" ] || [ "$#" = "0" ];then
	echo "--help or no parameters gives you this helpful message."
	echo "--install will not clobber any files."
	echo "--force-install will install AND override files if there are any."
	echo "--uninstall will uninstall osget and remove all config files." 
	echo ""
	echo "install by typing the following: ./install.sh --install."
fi

if [ "$1" = "--uninstall" ];then
	checkif_root
	echo "Removing files ... "
	rm -rfv /etc/osget
	rm -v /usr/bin/osget
	rm -v /usr/sbin/osget
	rm -v /usr/local/sbin/osget
	rm -v /usr/share/man/man8/osget.8.gz
	echo "Uninstall complete."
fi

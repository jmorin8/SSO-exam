#!/bin/bash
#Made by: jmorin8

function install_anti() {
	echo "[>] Verifying if ClamAV is installed"
	test=$(yum list installed | grep ^clamav)

	if [[ $? -eq 0 ]];
	then
		echo "[>] ClamAV is intalled"
		systemctl stop clamav && echo "[>] ClamAV stopped"
		yum erase clamav* && echo "[>] ClamAV deleted"

		yum -y install epel-release
		yum -y install clamav* && echo "[>] ClamAV updated"
	else
		echo "[>] ClamAV not installed, starting installation"
		yum -y install epel-release
		yum -y install clamav* && echo "[>] Clamav installed"
	fi
}


OS=$(. /etc/os-release; echo $ID)

if [[ $OS -eq "centos" ]];
then
	echo "[>] CentOS detected"
	os_version=$(. /etc/os-release; echo $VERSION_ID)

	if [[ $os_version -eq "7" ]]
	then
		echo "[>] Version: 7"
		echo "[>] Installing EPEL repostory"

		yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

		# Clamav installation
		install_anti

		# Update packages
		yum update

	elif [[ $os_version -eq "8" ]]
	then
		echo "[>] Version: 8"
		# Clamav installation
		install_anti

		# Update packages
		dnf update
	else:
		echo "[>] Older CentOS version"
	fi
else
	echo "[>] OS must be CentOS to run this script"
fi

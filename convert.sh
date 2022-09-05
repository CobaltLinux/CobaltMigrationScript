#!/bin/bash

echo "Checking to see if we are root..."

if [ "$EUID" -ne 0 ]; then 
	echo -e "\e[35mError: You are not root! Make sure you are running the script with sudo."
  	exit
else
	echo "- The script is running as root"
fi


echo "Making sure we are running on an Arch-based distribution..."

if [ -f "/etc/arch-release" ]; then
	echo "- The distribution is Arch-based or Arch itself"
else
	echo -e "\e[35mError: This distribution isn't Arch!"
fi

echo -e "\e[34m                          ///          "
echo -e "\e[34m                  ,//////////////      "
echo -e "\e[34m    ///////////////////////////////    "
echo -e "\e[34m    ///////////////***********//////   "
echo -e "\e[34m    ////***********************/////   "
echo -e "\e[34m    /////***********************////   "
echo -e "\e[34m   //////,,,,,,,,,,,,,,,,,,,,,,///     "
echo -e "\e[34m ******,,,,,,,,,,,,,,,,,,,,,,,,,*****  "
echo -e "\e[34m *****,,,,,,,,,,,,,,,,,,,,,,,,,,,,*****"
echo -e "\e[36m *****,,,,,,,,,,,,,,,,,,,,,,,,,,,,,*****"
echo -e "\e[36m ******,,,,,,,,,,,,,,,,,,,,,,,,,,,,*****"
echo -e "\e[36m  *******,,,,,,,,,,,,,,,,,,,,,,,,,******"
echo -e "\e[36m    *******......................*******"
echo -e "\e[36m      ******....***********************"
echo -e "\e[36m        ****************************   "
echo -e "\e[36m         *****                         "
echo -e "\e[0m"
echo -e "Welcome to the \e[34mCobalt Linux\e[0m Migration Script!"
echo "This script will migrate an existing Arch installation into Cobalt."
echo "Continue? (y/n)"
read input
if [[ $input != "y" ]]; then
	echo "Exiting..."
	exit
fi
echo "Select your Desktop Environment:"
echo "1. Pantheon"
echo "2. Cutefish"
echo "3. Budgie"
read desktop
if [[ $desktop == "1" ]]; then
	export desktop="pantheon"
elif [[ $desktop == "2" ]]; then
	export desktop="cutefish"
elif [[ $desktop == "3" ]]; then
	export desktop="budgie"
else
	echo "Invalid choice. Defaulting to Pantheon... (If you do not want to use this desktop, press CTRL+C now to exit the program.)"
	sleep 5
	export desktop="pantheon"
fi
if [[ $desktop == "pantheon" ]]; then
	echo "Converting your Arch install to Cobalt Linux Azurite (Pantheon Edition)..."
	pacman -Syyu --noconfirm pantheon gdm gnome-software gnome-software-packagekit-plugin git
	systemctl enable gdm
elif [[ $desktop == "cutefish" ]]; then
	echo "Converting your Arch install to Cobalt Linux Azurite (Cutefish Edition)..."
	pacman -Syyu --noconfirm cutefish sddm git
	systemctl enable sddm
elif [[ $desktop == "budgie" ]]; then
	echo "Converting your Arch install to Cobalt Linux Azurite (Budgie Edition)..."
	pacman -Syyu --noconfirm git budgie-desktop budgie-desktop-view budgie-screensaver budgie-extras gdm
	systemctl enable gdm
else
	echo -e "\e[35mError during desktop install: The desktop environment variable $desktop is not a valid choice! Exiting..."
	exit
fi
echo "Install an AUR helper?"
echo "(y/n)"
read aurhelper
if [[ $aurhelper == "y" ]]; then
	export aurinstall="true"
else
	export aurinstall="false"
fi
if [[ $aurinstall == "true" ]]; then
	echo "Select an AUR helper to install:"
	echo "1. Paru"
	echo "2. Yay"
	echo "3. Pikaur"
	read aurhelper
	if [[ $aurhelper == "1" ]]; then
		export aurhelper="paru"
	elif [[ $aurhelper == "2" ]]; then
		export aurhelper="yay"
	elif [[ $aurhelper == "3" ]]; then
		export aurhelper="pikaur"
	else
		echo "Invalid choice. Defaulting to yay..."
		export aurhelper="yay"
	fi
fi
if [[ $aurhelper == "paru" ]]; then
	echo "Installing Paru..."
	git clone https://aur.archlinux.org/paru.git
	cd paru
	makepkg -si
	cd ../
	rm -rf paru
elif [[ $aurhelper == "yay" ]]; then
	echo "Installing Yay..."
	git clone https://aur.archlinux.org/yay.git
	cd yay
	makepkg -si
	cd ../
	rm -rf yay
elif [[ $aurhelper == "pikaur" ]]; then
	echo "Installing Pikaur..."
	git clone https://aur.archlinux.org/pikaur.git
	cd pikaur
	makepkg -fsri
	cd ../
	rm -rf pikaur
else
	echo -e "\e[35mError during AUR helper install: the aurhelper variable $aurhelper is not valid! Exiting..."
	exit
fi
echo "Topping off some finishing touches..."
pacman -S --noconfirm neofetch neovim vlc fluidsynth
echo "Swapping out Arch Linux branding for Cobalt Linux branding..."
sed -i 's/Arch Linux/Cobalt Linux/g' /etc/os-release
sed -i 's/Arch Linux/Cobalt Linux/g' /etc/lsb_release
sed -i 's/Arch Linux/Cobalt Linux/g' /etc/issue
echo "Cobalt Linux has been installed! We will reboot the computer in 20 seconds to complete the changes."
sleep 20
reboot

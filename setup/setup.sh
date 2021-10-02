#!/usr/bin/env bash

# VARIABLES
readonly username = $SUDO_USER

readonly dnf_remove=("gnome-contacts" "gnome-photos" "rhytmbox" "totem" "firefox")
readonly dnf_install=("install gnome-tweaks" "gnome-extensions-app" "cabextract lzip p7zip p7zip-plugins unrar" "vlc" "toolbox" "steam" "youtube-dl" "bat" "exa" "procs" "htop" "fd-find" "ffmpegthumbnailer" "ImageMagick")
readonly flatpak_install=("com.discordapp.Discord" "com.spotify.Client" "com.microsoft.Team" "org.telegram.desktop" "com.visualstudio.code" "com.github.tchx84.flatseal" "org.gimp.GIMP" "md.obsidian.Obsidian" "uk.co.mrbenshe.Boop-GTK" "com.getpostman.Postman"
	"io.github.Qalculate" "org.kde.kdenlive")

initial_check(){
# CHECK IF HOME FOLDER EXISTS
if [ ! -d "/home/$username" ] 
	then
	    echo "Couldn't find user's home directory. Aborting." 
	    exit 1 # die with error code 9999
	fi

}

install_flatpaks(){
	# ADD FLATHUB REMOTE
	flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

	# ITERATE OVER THE ARRAY AND INSTALL FROM IT
	for f in "${flatpak_install[@]}"; do
	  flatpak install -y --noninteractive flathub "$f"
	done
}
 
install_resources(){
	# TEMPLATES
	# Create files for templates
	if [ ! -d "/home/$username/Templates" ] 
	then
		mkdir /home/$username/Templates 
	else
	 cp -r Templates/* /home/$username/Templates
	fi
	#Sidenote: these files^ have root permissions, but it doesn't matter.
}

disable_services(){
	#Disable unnecessary services for mproved boot times.
	systemctl disable NetworkManager-wait-online.service #Wait for network at startup
	systemctl mask lvm2-monitor.service #LVM service for managing partitions over several disks
	systemctl disable ssd.service #For remote authentification like LDAP 
}

dnf_tasks(){
	#ADD DNF RELATED TWEAKS
	echo "fastestmirror=true" >> /etc/dnf/dnf.conf # check for updates from closest server
	echo "max_parallel_downloads=10" >> /etc/dnf/dnf.conf # increase the amount of possible parallel downloads. Maximum is 10
	# echo "deltarpm=true" >> /etc/dnf/dnf.conf #update only changed files (decreases network traffic, but increases CPU load)

	# ENABLE RPM FUSION REPOS
	dnf -y install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
	dnf -y install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

	# UPDATE 
	dnf -y upgrade
	
	# GOOGLE CHROME
	dnf install -y fedora-workstation-repositories
	dnf config-manager --set-enabled google-chrome
	dnf install -y google-chrome-stable

	# INSTALL PACKAGES
	for d in "${dnf_install[@]}"; do
	 dnf -y -C install "$d"
	done
	
	# REMOVE UNNECESSARY
	for dr in "${dnf_remove[@]}"; do
	 dnf -y remove "$dr"
	done

	#Install replacement fonts for proprietary ones (like Microsoft)
	dnf copr enable dawid/better_fonts
	dnf install -y fontconfig-enhanced-defaults fontconfig-font-replacements

}

install_jetbrains(){
 cd /home/$username/Downloads/ || exit
       wget https://download.jetbrains.com/toolbox/jetbrains-toolbox-1.18.7609.tar.gz
       tar -zxvf jetbrains*.tar.gz
       cd jetbrains*/ || exit
       ./jetbrains-toolbox	
}

tweak_gnome(){
	#SET DARK THEME
	gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'

	#ADD GNOME SHORTCUTS
	# Launch terminal by special + t
	gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name "'Launch terminal'"
	gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding "'<Super>t'"
	gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command "'gnome-terminal'"

	#Show desktop by special + d
	gsettings set org.gnome.desktop.wm.keybindings show-desktop "['<Super>d']"

	#Open home in Nautilus by special +f
	gsettings set org.gnome.settings-daemon.plugins.media-keys home "['<Super>f']"

	#Open calculator by special + nt
	gsettings set org.gnome.settings-daemon.plugins.media-keys calculator "['<Super>n']"	

	# CHANGE APP SETTINGS 
	# Set favorite apps
	dconf write /org/gnome/shell/favorite-apps "['google-chrome.desktop', 'org.gnome.Nautilus.desktop', 'com.discordapp.Discord.desktop', 'org.telegram.desktop.desktop', 'com.spotify.Client.desktop']"
	
	# Disable line highlighting in Gedit
	dconf write /org/gnome/gedit/preferences/editor/highlight-current-line "false"
	
	# Disable terminal bell
	 dconf write /org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/audible-bell "false"
	 
	 # Enable terminal transparency
	 dconf write /org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/use-transparent-background "true"
	 dconf write /org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/background-transparency-percent "28"
	 
	 # Show battery percentage
	 dconf write /org/gnome/desktop/interface/show-battery-percentage "true"
	 
	 # Set middle click to minimize
	 dconf write /org/gnome/desktop/wm/preferences/action-middle-click-titlebar "'minimize'"
	 
	 # Enable night light
	 dconf write /org/gnome/settings-daemon/plugins/color/night-light-enabled "true"
	 dconf write /org/gnome/settings-daemon/plugins/color/night-light-temperature "uint32 2300"
	 
	 # Set AC timeout
	 dconf write /org/gnome/settings-daemon/plugins/power/sleep-inactive-ac-timeout "uint32 3600"
}

#### MAIN ####
initial_check
install_resources
tweak_gnome
dnf_tasks
install_flatpaks
disable_services
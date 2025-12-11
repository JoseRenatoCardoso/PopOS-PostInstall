#!/usr/bin/env bash
#Personal post-install configuration script for Pop! OS 22.04 LTS, modified from https://github.com/Diolinux/pop-os-postinstall

set -e

## Update repository and upgrade system ##
update_system(){
  sudo apt update && sudo apt upgrade -y
}

## Check internet connection ##
check_internet(){
if ! ping -c 1 8.8.8.8 -q &> /dev/null; then
  echo -e "Your computer is not connected to the Internet. Please check your network."
  exit 1
else
  echo -e "Internet connection is working normally."
fi
}

## Remove apt locks ##
remove_apt_locks(){
  sudo rm /var/lib/dpkg/lock-frontend 2>/dev/null || true
  sudo rm /var/cache/apt/archives/lock 2>/dev/null || true
}

## Update repository ##
update_repository(){
sudo apt update -y
}

# List of programs

APT_PACKAGES=(
  gparted
  timeshift
  code
  git
  gh
  ubuntu-restricted-extras
  v4l2loopback-utils
)

# ---------------------------------------------------------------------- #

## Download and installation of external programs ##

install_apt_packages(){

# Install apt packages
echo -e "[INFO] - Installing apt packages from repository"

for package_name in ${APT_PACKAGES[@]}; do
  if ! dpkg -l | grep -q $package_name; then # Only install if not already installed
    sudo apt install "$package_name" -y
  else
    echo "[INSTALLED] - $package_name"
  fi
done

}
## Installing Flatpak packages ##
install_flatpak_packages(){

  echo -e "[INFO] - Installing flatpak packages"

flatpak install flathub org.chromium.Chromium -y
flatpak install flathub com.usebottles.bottles -y
flatpak install flathub md.obsidian.Obsidian -y
flatpak install flathub com.spotify.Client -y
flatpak install flathub io.github.shiftey.Desktop -y
sleep2
flatpak install flathub com.bitwarden.desktop -y
flatpak install flathub com.github.tchx84.Flatseal -y
flatpak install flathub org.gnome.gitlab.somas.Apostrophe -y
flatpak install flathub cc.arduino.IDE2 -y
flatpak install flathub io.github.flattool.Warehouse -y
sleep 2
flatpak install flathub me.iepure.devtoolbox -y
flatpak install flathub dev.geopjr.Collision -y
flatpak install flathub re.sonny.Eloquent -y
flatpak install flathub org.nickvision.money -y
flatpak install flathub com.anydesk.Anydesk -y
sleep 2
flatpak install flathub org.apache.netbeans -y
flatpak install flathub com.github.xournalpp.xournalpp -y
flatpak install flathub com.obsproject.Studio -y
flatpak install flathub org.gimp.GIMP -y
flatpak install flathub org.gnome.Boxes -y
sleep 2
flatpak install flathub org.qbittorrent.qBittorrent -y
flatpak install flathub org.telegram.desktop -y
flatpak install flathub com.discordapp.Discord -y
flatpak install flathub io.github.kolunmi.Bazaar -y
flatpak install flathub app.drey.Biblioteca -y
sleep 2
flatpak install flathub io.github.brunofin.Cohesion -y
flatpak install flathub com.ranfdev.DistroShelf -y
flatpak install flathub org.gnome.TextEditor -y
flatpak install flathub org.gnome.Extensions -y
flatpak install flathub com.freerdp.FreeRDP -y
sleep 2
flatpak install flathub com.mattjakeman.ExtensionManager -y
flatpak install flathub com.heroicgameslauncher.hgl -y
flatpak install flathub net.lutris.Lutris -y
flatpak install flathub io.missioncenter.MissionCenter -y
sleep 2
flatpak install flathub org.gnome.clocks -y
flatpak install flathub com.valvesoftware.Steam -y
flatpak install flathub com.github.joseexposito.touche -y
flatpak install flathub com.github.unrud.VideoDownloader -y
}

## Installing Snap packages ##

#install_snap_packages(){#Optional use}

install_rclone () {
  if command -v rclone &> /dev/null; then
    echo "[INFO] - rclone is already installed."
    return
  fi
  sudo -v ; curl https://rclone.org/install.sh | sudo bash
}

# Install and configure zoxide
configure_zoxide (){
  if command -v zoxide &> /dev/null; then
    echo "[INFO] - zoxide is already installed."
    return
  fi
  curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
  echo 'eval "$(zoxide init bash)"' >> ~/.bashrc
}

add_fastfetch_repository () {
  if ls /etc/apt/sources.list.d/ | grep -q "zhangsongcui3371-fastfetch"; then
    echo "[INFO] - Fastfetch repository is already added."
    return
  fi
  sudo add-apt-repository ppa:zhangsongcui3371/fastfetch
  sudo apt update
  sudo apt install fastfetch
}


## Finalization, update and cleanup ##

cleanup(){
update_system -y
flatpak update -y
sudo apt autoclean -y
sudo apt autoremove -y
}

remove_apt_locks
check_internet
remove_apt_locks

update_system
remove_apt_locks

update_repository
install_apt_packages
install_flatpak_packages
remove_apt_locks
#install_snap_packages #Optional!
install_rclone
configure_zoxide
add_fastfetch_repository

update_system
cleanup

## Completed!

  echo -e "[INFO] - Script finished, installation completed!"

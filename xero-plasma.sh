#!/usr/bin/env bash

##################################################################################################################
# Author : DarkXero
# Website : https://xerolinux.xyz
# To be used in Arch-Chroot (After installing Base packages via ArchInstall)
##################################################################################################################

# Check if dialog is installed, if not, install it
if ! command -v dialog &> /dev/null; then
  echo "dialog is not installed. Installing dialog..."
  pacman -S --noconfirm dialog
fi

# Function to install packages
install_packages() {
  packages=$1
  pacman -S --needed --noconfirm $packages
}

# Function to selectively install packages
selective_install() {
  packages=$1
  pacman -S --needed $packages
}

# Main menu using dialog
main_menu() {
  CHOICE=$(dialog --stdout --title ">> XeroLinux Plasma Install <<" --menu "\nChoose how to install Plasma:" 15 60 4 \
    1 "Minimal  : Minimal install (Older PCs)." \
    2 "Complete : Full Plasma install (All Packages)." \
    3 "Curated  : Xero's Curated set of Plasma packages." \
    4 "Selective: Individual package selection (Advanced).")

  case "$CHOICE" in
    1)
      install_packages "plasma-meta konsole kate dolphin ark plasma-workspace egl-wayland flatpak-kcm breeze-grub spectacle dolphin-plugins falkon nano krdp freerdp2"
      systemctl enable sddm.service
      ;;
    2)
      install_packages "nano kf6 qt6 plasma-meta kde-applications-meta kdeconnect packagekit-qt6 kde-cli-tools kdeplasma-addons plasma-activities polkit-kde-agent flatpak-kcm bluedevil glib2 ibus kaccounts-integration kscreen libaccounts-qt plasma-nm plasma-pa scim extra-cmake-modules kaccounts-integration kdoctools libibus wayland-protocols plasma-applet-window-buttons plasma-workspace appmenu-gtk-module kwayland-integration plasma5-integration xdg-desktop-portal-gtk krdp freerdp2"
      systemctl enable sddm.service
      ;;
    3)
      install_packages "nano kf6 qt6 jq xmlstarlet plasma-desktop packagekit-qt6 packagekit dolphin kcron khelpcenter kio-admin ksystemlog breeze discover plasma-workspace plasma-workspace-wallpapers powerdevil plasma-nm kaccounts-integration kdeplasma-addons plasma-pa plasma-integration plasma-browser-integration plasma-wayland-protocols plasma-systemmonitor kpipewire keysmith krecorder kweather plasmatube plasma-pass ocean-sound-theme qqc2-breeze-style plasma5-integration kdeconnect kdenetwork-filesharing kget kio-extras kio-gdrive kio-zeroconf colord-kde gwenview kamera kcolorchooser kdegraphics-thumbnailers kimagemapeditor kolourpaint okular spectacle svgpart ark kate kcalc kcharselect kdebugsettings kdf kdialog keditbookmarks kfind kgpg konsole markdownpart yakuake audiotube elisa ffmpegthumbs plasmatube dolphin-plugins pim-data-exporter pim-sieve-editor emoji-font ttf-joypixels gcc-libs glibc icu kauth kbookmarks kcmutils kcodecs kcompletion kconfig kconfigwidgets kcoreaddons kcrash kdbusaddons kdeclarative kglobalaccel kguiaddons ki18n kiconthemes kio kirigami kirigami-addons kitemmodels kitemviews kjobwidgets kmenuedit knewstuff knotifications knotifyconfig kpackage krunner kservice ksvg kwidgetsaddons kwindowsystem kxmlgui libcanberra libksysguard libplasma libx11 libxcb libxcursor libxi libxkbcommon libxkbfile plasma-activities plasma-activities-stats plasma5support polkit-kde-agent qt6-5compat qt6-base qt6-declarative qt6-wayland sdl2 solid sonnet systemsettings wayland xcb-util-keysyms xdg-user-dirs scim extra-cmake-modules intltool wayland-protocols xf86-input-libinput sddm-kcm bluedevil breeze-gtk drkonqi kde-gtk-config kdeplasma-addons kinfocenter kscreen ksshaskpass oxygen oxygen-sounds xdg-desktop-portal-kde breeze-grub flatpak-kcm falkon krdp freerdp2"
      systemctl enable sddm.service
      ;;
    4)
      selective_install "nano kf6 qt6 plasma-meta kde-applications-meta kdeconnect packagekit-qt6 kde-cli-tools kdeplasma-addons plasma-activities polkit-kde-agent flatpak-kcm bluedevil glib2 ibus kaccounts-integration kscreen libaccounts-qt plasma-nm plasma-pa scim extra-cmake-modules kaccounts-integration kdoctools libibus wayland-protocols plasma-applet-window-buttons plasma-workspace appmenu-gtk-module kwayland-integration plasma5-integration xdg-desktop-portal-gtk krdp freerdp2"
      systemctl enable sddm.service
      ;;
    *)
      if [ "$CHOICE" == "" ]; then
        clear
        exit 0
      else
        dialog --msgbox "Invalid option. Please select 1, 2, 3, or 4." 10 40
        main_menu
      fi
      ;;
  esac
}

# Display main menu
main_menu

echo "Installing PipeWire packages..."
install_packages "gstreamer gst-libav gst-plugins-bad gst-plugins-base gst-plugins-ugly gst-plugins-good libdvdcss alsa-utils alsa-firmware pavucontrol lib32-pipewire-jack libpipewire pipewire-v4l2 pipewire-x11-bell pipewire-zeroconf realtime-privileges sof-firmware ffmpeg ffmpegthumbs ffnvcodec-headers"

echo "Installing Bluetooth packages..."
install_packages "bluez bluez-utils bluez-plugins bluez-hid2hci bluez-cups bluez-libs bluez-tools"
systemctl enable bluetooth.service

echo "Adding support for OS-Prober"
install_packages "os-prober"
sed -i 's/#\s*GRUB_DISABLE_OS_PROBER=false/GRUB_DISABLE_OS_PROBER=false/' '/etc/default/grub'
os-prober
grub-mkconfig -o /boot/grub/grub.cfg

echo "Installing other useful applications..."
install_packages "linux-headers meld timeshift elisa mpv gnome-disk-utility btop gum inxi"

echo "Detecting if you are using a VM"
result=$(systemd-detect-virt)
case $result in
  oracle)
    echo "Installing virtualbox-guest-utils..."
    install_packages "virtualbox-guest-utils"
    ;;
  kvm)
    echo "Installing qemu-guest-agent and spice-vdagent..."
    install_packages "qemu-guest-agent spice-vdagent qemu-hw-display-qxl xf86-video-qxl"
    ;;
  vmware)
    echo "Installing xf86-video-vmware and open-vm-tools..."
    install_packages "xf86-video-vmware open-vm-tools xf86-input-vmmouse"
    systemctl enable vmtoolsd.service
    ;;
  *)
    echo "You are not running in a VM."
    ;;
esac

# Prompt for adding XeroLinux repo and installing Paru/Toolkit using dialog
if dialog --stdout --title "Add XeroLinux Repo & Install Toolkit" --yesno "\nWould you like to add the XeroLinux repository and install Paru & the Xero-Toolkit?\n\nIt is recommended as it will make things like driver and package configuration easier." 12 50; then
  echo "Adding XeroLinux Repository..."
  echo -e '\n[xerolinux]\nSigLevel = Optional TrustAll\nServer = https://repos.xerolinux.xyz/$repo/$arch' | tee -a /etc/pacman.conf
  sed -i '/^\s*#\s*\[multilib\]/,/^$/ s/^#//' /etc/pacman.conf
  echo "Installing Paru/Toolkit..."
  pacman -Syy --noconfirm paru-bin xlapit-cli
fi

dialog --title "Installation Complete" --msgbox "\nInstallation Complete. Done, now exit and reboot.\n\nFor further customization, if you opted to install our Toolkit, please find it in AppMenu under System or by typing xero-cli in terminal." 12 50

# Exit chroot and reboot
clear
echo "Exiting chroot environment and rebooting system..."
sleep 2
exit; reboot

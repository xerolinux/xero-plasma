# The Plasma Installer Script

With the help of this script you will be able to install **Plasma** in one of 4 methods as you can see in the image below. Not only that, it will also fix **PipeWire** and **Bluetooth**.. Make sure to inspect the script [**Here**](https://github.com/xerolinux/xero-plasma/blob/main/xero-plasma.sh) before running it to see what and how it does things...
<br />

<div align="center">

![Script](https://i.imgur.com/TOZNp4j.png)

</div>

### How To Use :

First off, you will need to download latest [**Arch ISO**](https://archlinux.org/download/), boot it and follw the steps below.. 

**- Step 1 :**
Grab latest version of **ArchInstall** script
```
pacman -Syy archinstall
```

**- Step 2 :**
Run the **ArchInstall** guided setup via command below
```
archinstall --advanced
```

**- Step 3 :**
Go through the mothions skipping the **Profiles** and **Additional Packages** steps ignoring them completly, don't forget to set parallel downloads to as many as you want for faster downloads, also make sure to activate the **multilib** repository, if you forget you will have to start over coz my script will fail otherwise. Oh and skip GPU Drivers, since you will be able to do that and more via my toolkit which will be offered during install, and select **NetworkManager** for your network.

Finally select install, and let it do its thing, won't take long as it will just install basic packages nothing too big. Once it's done, it will prompt you if you want to **chroot** into your installed system, select yes since you don't have **Plasma** installed yet... 

**- Step 4 :**
Now is the time to run my script. To do so, type the below command in terminal, hit enter and have fun.. A video will be made soon and added here, so keep it locked to this git...
```
bash -c "$(curl -fsSL https://tinyurl.com/PlasmaInstall)"
```

### Report Issues

To report any issues or suggest quality of life modifications to script please feel free to do so on the [**Issues**](https://github.com/xerolinux/xero-plasma/issues) page. Otherwise I won't be able to get to them fast enough or at all. Thanks.

**PS :** You can, if you so wish, run script after minimal install and reboot. Just login with your created user, and use root (sudo) since script was written with **Arch-Chroot** in mind. End result is the same. Just don't report issues if you decide to run it this way.. 

Enjoy ;)

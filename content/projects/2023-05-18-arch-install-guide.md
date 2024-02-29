---
title: "Arch Linux Installation Guide"
description: "Step-by-step guide for installing Arch Linux from scratch on a VM"
date: 2023-05-18
hideSummary: true
ShowWordCount: true
ShowReadingTime: true
ShowToC: true
draft: false

cover:
  image: /img/arch/install_process/45.jpg
  alt: Arch Linux Neofetch

categories: [Computing]
---

# Introduction

This guide details the installation procedure of Arch onto a Virtual Machine (VM). Network configuration is not in the scope of this guide if you are installing on bare metal.

The motivation behind this web page is to keep some guidance material for myself and also for anybody new looking to install Arch from scratch.

The virtual machine is made with Microsoft's Hyper-V program. The steps may differ slightly if you choose to use a another hypervisor such as VirtualBox.

## Arch Linux ISO Download Link

You can find the download link to the Arch Linux ISO here: https://archlinux.org/download/

The recommended way to pull down the ISO file is by torrenting it from the referenced magnet link.

When the download is complete, you can configure your virtual machine.

## Creating a Hyper-V Virtual Machine

### 1. Create New Virtual Machine
The first step is to open up Hyper-V and create a new virtual machine
![](/img/arch/install_process/1.jpg#center)

### 2. Select VM Generation
You will be asked which generation of VM to create. I would reccommend to select "Generation 2". It supports UEFI firmware and it should be better from a cyber-security standpoint.
![](/img/arch/install_process/2.jpg#center)

### 3. Allocate Memory
You can specify how much memory to allocate to the VM. I decided to allocate 4000MB in my use case.
![](/img/arch/install_process/3.jpg#center)


### 4. Configure Network Adapter
Hyper-V has a built in network adapter that works out of the box, so you'd want to select "Default Switch" to have it enabled.
![](/img/arch/install_process/4.jpg#center)

### 5. Create Virtual Hard Disk
For the VM you should create a virtual hard disk to store the data. I decided to allocate 30GB of storage space.
![](/img/arch/install_process/5.jpg#center)

### 6. Select .iso Image
You need to select the arch linux ISO file to boot from and then you can finalise the VM creation.
![](/img/arch/install_process/6.jpg#center)

### 7. Go to Settings
We are not done yet, we still need to configure 2 more things in the settings panel of this VM we just created.
![](/img/arch/install_process/7.jpg#center)

### 8. Disable Secure Boot
We need to **disable Secure Boot**, if you do not do this step, it will interfere with your ability to boot the ISO image.
![](/img/arch/install_process/8.jpg#center)

### 9. Change Boot Priority
Next we need to **bump the Hard Drive to the first priority of boot loading**. Its very important that you do this step before you start installing linux otherwise the Grub will fail down the line because it will be trying to boot from the DVD Drive. You will not be able to retroactively change the boot order at a later stage.
![](/img/arch/install_process/9.jpg#center)
After applying the changes:

### 10. Start the VM
Connect to the VM:
![](/img/arch/install_process/10.jpg#center)
Start the VM:
![](/img/arch/install_process/11.jpg#center)

## Installing Arch Linux

From this screen select the highlighted option to load the ISO image
![](/img/arch/install_process/12.jpg#center)

The install process starts here:
![](/img/arch/install_process/13.jpg#center)

### 1. Verify Internet Connection
Before going any further, you should ping a website to test your internet connection:

```bash
ping archlinux.org
```
![](/img/arch/install_process/14.jpg#center)
The Hyper-V default network switch should automatically provide your VM with the internet connection. If not, you will probably need to configure Hyper-V to alleviate networking issues.

### 2. Synchronise System Clock

We also need to synchronise the systems clock with the network time:
```bash
timedatectl set-ntp true
```

### 3. Drive Partitioning
Now we need to start partitioning our drives and creating our file system.

The **lsblk** command indicates which drives and partitions are on your system. And we can use **cfdisk** to partition the drives.
![](/img/arch/install_process/16.jpg#center)

Type the command to start partitioning your virtualised disk:
```bash
cfdisk /dev/sda
```

![](/img/arch/install_process/18.jpg#center)

At this juncture we need to assign the disk label type and it comes down to two options mainly:

- If the hardware is new and the drive >= 2TB, use **gpt**.
- Otherwise use **dos**.
>  ***For our scenario we are using dos***

Decide on a partition scheme. I will keep it simple and reduce it to a **boot and root partition**:
- **/dev/sda1 (boot partition)** only needs about **128MB** of space and needs to be bootable. You can **press b to enable the boot flag** after making the partition.
- **/dev/sda2 (root partition)** can be assigned the **remaining space of the disk**.


Write the changes and quit out of cfdisk.
![](/img/arch/install_process/19.jpg#center)
If you **lsblk** now, you will now see that 2 partitions have been made which are called **sda1 and sda2**.

### 4. Creating File Systems

We also need to make the file systems for each partition:
- **sda1 (boot)** is **FAT32** file system.
- **sda2 (root)** is **ext4** file system.

Run these commands to create the file systems respectively:

```[bash]
mkfs.fat -F 32 /dev/sda1
mkfs.ext4 /dev/sda2
```

### 5. Mounting the File Systems

Now the mounting procedure MUST go in a specific order:

- **sda2 (root)** is mounted first to **/mnt**
- **sda1 (boot)** is mounted last to **/mnt/boot/efi**

```bash
mount /dev/sda2 /mnt
```

> **Warning:** If you mount in reverse order, the install will fail!

For the boot partition, you will need to make a directory with this path **/mnt/boot/efi**:
```bash
cd /mnt
mkdir boot
cd /mnt/boot
mkdir efi
```

Since we have a UEFI system config, we need this extra efi directory (normally we do not). Now we can mount the filesystem for boot:

```bash
mount /dev/sda1 /mnt/boot/efi
```

### 6. Installing Essential Packages

At this stage, you are ready install the base tools for the system in addition to the Linux kernel.

Use the pacstrap command to install the following tools to /mnt:

```bash
pacstrap /mnt base base-devel linux linux-firmware vim
```

### 7. Generate fstab Configuration

Run the following command to generate your fstab configuration:
```bash
genfstab -U /mnt >> /mnt/etc/fstab
genfstab -U /mnt
```

### 8. Chroot
Change root into new system by running this command:
```bash
arch-chroot /mnt /bin/bash
```

### 9. Install Key Packages
Pacman is our package manager and we can use it to install some key packages:
- networkmanager - Detection and configuration of systems to connect to networks
- grub - Bootloader for the computer
- efibootmgr - Package dependency for grub's installation command

```bash
pacman -S networkmanager grub efibootmgr
```

### 10. Auto-enable Internet on Startup
We can use systemctl to enable network manager as a service which starts automatically when you boot the computer (which is very useful to have).

```bash
systemctl enable NetworkManager
```

### 11. Install Grub
Next we run the grub-install command on /dev/sda; it should run with no errors:

```bash
grub-install /dev/sda
```

We need to make a config file for grub, with the following command:

```bash
grub-mkconfig -o /boot/grub/grub.cfg
```
We need to edit this grub file:

```bash
vim /etc/default/grub
```
Uncomment the line "GRUB_DISABLE_OS_PROBER=false" and then save the file.

![](/img/arch/install_process/31.jpg#center)

### 12. Set Root Password
Run the passwd command to set a root password for the machine
![](/img/arch/install_process/32.jpg#center)

### 13. Localization
Edit **/etc/locale.gen** to change the language settings of the machine. 
```bash
vim /etc/locale.gen
```
Uncomment the lines that apply to your language of choice.
![](/img/arch/install_process/34.jpg#center)
Run **locale-gen** command to generate the locales you have selected:
```bash
locale-gen
```
Edit /etc/locale.conf and set the language being used:
```bash
vim /etc/locale.conf
```
Enter the **LANG variable** into the file with the relevant language setting:

```
LANG=en_GB.UTF-8
```

### 14. Hostname
Edit **/etc/hostname**:
```bash
vim /etc/hostname
```
The word you type in here will be the name of your computer. I decided to call mine **arch**. But it can be anything you want. Save and close the file.

### 15. Timezone
You can set the time zone with the following command:

```bash
ln -sf /usr/share/zoneinfo/Greenwich /etc/localtime
```

Greenwich can be substituted for any region within that zoneinfo directory. 

### 15. Rebooting
We are ready to reboot the system. First we need to exit the root environment and to unmount all the partitions. Then we can reboot.

```bash
exit
umount -R /mnt
reboot
```

If successful you should be greeted with this screen. You can select **Arch Linux** to boot into the system.
![](/img/arch/install_process/42.jpg#center)
And you should see a tty appear on your screen.

We do not have any users set up on the system (yet).

Simply login as the **root** user. The root password is what you set earlier in the setup process.

![](/img/arch/install_process/45.jpg#center)
That's about it, you now have a base install of Arch Linux.

From this point you are free to customise your desktop to your liking.

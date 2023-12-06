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

## Creating a Virtual Machine

The first step is to open up Hyper-V and create a new virtual machine
![](/img/arch/install_process/1.jpg#center)
You will be asked which generation of VM to create. I would reccommend to select "Generation 2". It supports UEFI firmware and it should be better from a cyber-security standpoint.
![](/img/arch/install_process/2.jpg#center)
You can specify how much memory to allocate to the VM. I decided to allocate 4000MB in my use case.
![](/img/arch/install_process/3.jpg#center)
Hyper-V has a built in network adapter that works out of the box, so you'd want to select "Default Switch" to have it enabled.
![](/img/arch/install_process/4.jpg#center)
For the VM you should create a virtual hard disk to store the data. I decided to allocate 30GB of storage space.
![](/img/arch/install_process/5.jpg#center)
You need to select the arch linux ISO file to boot from and then you can finalise the VM creation.
![](/img/arch/install_process/6.jpg#center)
We are not done yet, we still need to configure 2 more things in the settings panel of this VM we just created.
![](/img/arch/install_process/7.jpg#center)
We need to **disable Secure Boot**, if you do not do this step, it will interfere with your ability to boot the ISO image.
![](/img/arch/install_process/8.jpg#center)
Next we need to **bump the Hard Drive to the first priority of boot loading**. Its very important that you do this step before you start installing linux otherwise the Grub will fail down the line because it will be trying to boot from the DVD Drive. You will not be able to retroactively change the boot order at a later stage.
![](/img/arch/install_process/9.jpg#center)
After applying the changes:

Connect to the VM
![](/img/arch/install_process/10.jpg#center)
Start the VM
![](/img/arch/install_process/11.jpg#center)

## Booting From Arch Linux ISO Image

From this screen select the highlighted option to load the ISO image
![](/img/arch/install_process/12.jpg#center)

The install process starts here:
![](/img/arch/install_process/13.jpg#center)
Before going any further, you should test that your internet connecting works. You can use the ping command to run the test to any website:

```[bash]
ping archlinux.org
```
Hyper-V should be providing your VM with the internet connection in any case. If not, you will probably need to configure Hyper-V to alleviate networking issues.
![](/img/arch/install_process/14.jpg#center)

We also need to synchronise the systems clock with the network time, this command will enable that for you.
![](/img/arch/install_process/15.jpg#center)

## Drive Partitioning and Filesystems
Now we need to start partitioning our drives and creating our file system.

If you type "lsblk" you can see which drives and partitions are on your system.
![](/img/arch/install_process/16.jpg#center)

We want to "cfdisk" into "/dev/sda" which effectively our hard disk.
![](/img/arch/install_process/17.jpg#center)

At this juncture we need to assign the disk label type and it comes down to two options mainly:

- If your hardware is new and your hard drive is over 2TB, then the recommendation is to use **gpt**.
- If you don't fulfill the above conditions, then the recommendation is use **dos**.
- In our case we are using **dos**.

![](/img/arch/install_process/18.jpg#center)
There are many partition schemes to choose from, but I will keep it simple and only include the boot partition and root partition:
- /dev/sda1 (boot partition) only needs about 128MB of space and needs to be bootable. You can press b to enable the boot flag after making the partition.
- /dev/sda2 (root paritition) can be assigned the remaining space of the disk.

Write the changes and quit out of cfdisk.
![](/img/arch/install_process/19.jpg#center)
If you lsblk now, you will now see that 2 partitions have been made, sda1 and sda2.
![](/img/arch/install_process/20.jpg#center)
You will need to make a directory with this path: /mnt/boot/efi which can be done with the mkdir command. We are creating a mount point for the boot partition. Normally you don't need the efi folder, but its necessary here since we have a UEFI system config.

We also need to make the file systems for each parition sda1 is FAT file system and root is ext4.

Run these commands:

```[bash]
mkfs.fat -F /dev/sda1
mkfs.ext4 /dev/sda2
```

Now the mounting procedure MUST go in a specific order:

- sda2 (root) is mounted first to /mnt
- sda1 (boot) is mounted second to /mnt/boot/efi

```[bash]
mount /dev/sda2 /mnt
mount /dev/sda1 /mnt/boot/efi
```

I can't explain the reasoning, but if you do it in reverse, the install will fail down the line. You will have to ignore the order of the commands in image as I remounted in the aforementioned order later.
![](/img/arch/install_process/21.jpg#center)

At this point you are ready install the base tools for the system as well as the linux kernel.

Use the pacstrap command to install the following tools to /mnt
![](/img/arch/install_process/22.jpg#center)

Next you want to generate your fstab configuration. Run the following command:
![](/img/arch/install_process/23.jpg#center)

## Chrooting into Arch Install
At this stage we chroot into our installation file system/environment by running this command:
![](/img/arch/install_process/24.jpg#center)

Pacman is our package manager and we can use it to install "networkmanager" and "grub" as follows.

Network manager is a program for managing our internet capabilities and grub is our boot loader.
![](/img/arch/install_process/25.jpg#center)

We can use systemctl to enable network manager as a service which starts automatically when you boot the computer (which is very useful to have).
![](/img/arch/install_process/26.jpg#center)
We also need to install "efibootmgr" as this is a dependency for grubs installation.
![](/img/arch/install_process/27.jpg#center)
Next we run the grub-install command on /dev/sda

It should run with no errors.
![](/img/arch/install_process/28.jpg#center)

We need to make a config file for grub, which is done using the following command:

```[bash]
grub-mkconfig -o /boot/grub/grub.cfg
```
![](/img/arch/install_process/29.jpg#center)
We need to vim into this grub file and make an edit to it.
![](/img/arch/install_process/30.jpg#center)
We need to uncomment the line "GRUB_DISABLE_OS_PROBER=false" and then save the file.
![](/img/arch/install_process/31.jpg#center)
Run the passwd command to set a root password for the machine
![](/img/arch/install_process/32.jpg#center)
Then we want to vim into /etc/locale.gen to change the language settings of the machine. 
![](/img/arch/install_process/33.jpg#center)
Uncomment the lines that apply to your language of choice.
![](/img/arch/install_process/34.jpg#center)
Run "local-gen" command to generate the locales you have selected.
![](/img/arch/install_process/35.jpg#center)
Vim into a new file called /etc/locale.conf and set the language being used.
![](/img/arch/install_process/36.jpg#center)
Type in the language.
![](/img/arch/install_process/37.jpg#center)
Vim into /etc/hostname
![](/img/arch/install_process/38.jpg#center)
The word you type in here will be the name of your computer.
![](/img/arch/install_process/39.jpg#center)
Type the below command to set up the local time zone of your system. Greenwich can be substituted for any region within that zoneinfo folder.
![](/img/arch/install_process/40.jpg#center)

## Rebooting the System
At this stage we should be ready to reboot the system. We need to exit out of the root environment. Then we need to unmount all the partitions and reboot the system.

Type all the commands as follows:
![](/img/arch/install_process/41.jpg#center)

If successful you should be greeted with this screen. You can select "Arch Linux" to boot into the system.
![](/img/arch/install_process/42.jpg#center)
And you should see a tty appear on your screen.
![](/img/arch/install_process/43.jpg#center)
Since we do not have any users set up on the system, we can only login as root for the time being. So you can just enter the root credentials.
![](/img/arch/install_process/44.jpg#center)
That's about it, you now have a base install of Arch Linux.
![](/img/arch/install_process/45.jpg#center)
From this point you are free to customise your desktop to your liking.

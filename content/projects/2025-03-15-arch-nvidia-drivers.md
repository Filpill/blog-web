---
title: "Arch Linux - Nvidia Driver Installation"
description: "How to install NVIDIA Drivers on an Arch Linux System"
date: 2025-03-15
hideSummary: true
ShowWordCount: true
ShowReadingTime: true
ShowToC: false
draft: false

cover:
  image: /img/arch/nvidia/arch_nvidia.png
  alt: Arch Nvidia Driver Cover

tags: [💻 Systems]
---

# 🚙 Intro

I decided to bite the bullet and install Arch on my main desktop so I can now dual-boot both Windows and Linux. Pretty cool eh.

Although in the process I've had the joy of dancing with NVIDIA drivers. Spoiler alert -- it was not that fun.

During the first couple of attempts of installing drivers, I thought I completely "bricked" my system due to freezing issues in the boot-up process. 

A couple of times I've tried to skirt around the issue by re-installing Arch from scratch, but I would encounter the same issues time and time again.

> After murking my PC one too many times, the time finally came to fix the problem with brute force.

Thankfully, the **USB live installation media** saved my ass by allowing me to chroot back into my system and alter the configurations. This god forsaken process allowed me to mount my drives manually to incrementally test various changes.

And after a lot of faff, pulling my hair out, and raging at the computer...we finally crossed the finish line 😌.

In retrospect it wasn't too bad after implementing the correct steps, though I still only partially understand most of what I've done. In any case I would still rather have this experience to leverage for future builds which should go more smoothly.

For now I'll attempt to encapsulate all the steps I've taken in this article for people who may encounter the same issues.

## 🍗 Ingredients

Here is the recipe for installing NVIDIA drivers, you'll need to consider the following:

- Enable the multilib repo
- Installing drivers and utilties
- Ammending initramfs configuration
- Adding pacman hooks to keep initramfs updated
- Adding kernel parameters to the boot loader

## 📗  Pacman - Enable Multilib

Inside **/etc/pacman.conf** scroll down and uncomment the following lines:

```bash
[multilib]
Include =  /etc/pacman.d/mirrorlist
```

This should give you access to additional nvidia related packages listed below.

## 🏗️ Installing Utilities

You'll likely need to refer to the official Arch Documentation to adjust for specific hardware dependancies: https://wiki.archlinux.org/title/NVIDIA

![](/img/arch/nvidia/nvidia_gpu_drivers.png)


You'll need to run the following to determine the family of your NVIDIA card:

```bash
lspci -k -d ::03xx
```

I'm currently running an **NVIDIA GTX 1070TI** which is part of the NV130 family (Pascal) to which I decided to install the nvidia and nvidia-dkms packages.

You'll need the following packages on your system, including any depedencies:

```bash
sudo pacman -S linux-headers nvidia-dkms libglvnd nvidia-utils opencl-nvidia lib32-libglvnd lib32-nvidia-utils lib32-open-cl-nvidia nvidia
```


## 🏃 Updating mkinitcpio

The initramfs is loaded by the bootloader, and the kernel then mounts the root filesystem. We need to update this file to include all the nvidia modules so they can be loaded early in the boot process.

Edit the following file: **/etc/mkinitcpio.conf** and add the following to the modules:

```bash
MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)
```

Regerate initramfs by running the command:

```bash
mkinitcpio -P
```

## 🪝 Adding Pacman Hooks
To avoid the possibility of forgetting to update initramfs after an NVIDIA driver upgrade, you may want to use a pacman hook.

Create a fresh file called **/etc/pacman.d/hooks/nvidia.hook** and add the following minimal configuration.

```bash
[Trigger]
Operation=Install
Operation=Upgrade
Operation=Remove
Type=Package
Target=nvidia

[Action]
Depends=mkinitcpio
When=PostTransaction
Exec=/usr/bin/mkinitcpio -P
```

Everytime a driver updates, this hook will update your initramfs, and prevent your system from breaking.


## 🐛  GRUB - Adding Kernel Parameters

Grub is my bootloader of choice and you can enter the following file **/etc/default/grub** and append the following kernel parameters to **GRUB_CMDLINE_LINUX_DEFAULT**:
- nvidia_drm.modeset=1
- nvidia_drm.fbdev=0

Mine looks like this:

```bash
GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet nvidia_drm.modeset=1 nvidia_drm.fbdev=0"
```

Regenerate your grub boot config with the command:
```bash
grub-mkconfig -o /boot/grub/grub.cfg
```

## 🏁 Outro

These are the minimum considerations you should incorporate to have a fully functional NVIDIA GPU on an Arch system. It may vary depending on your system set-up.

After implementing all these elements, hopefully your system will boot correctly without experiencing system freezing. 

My system is now running silky smooth with these drivers and previous graphical glitches are all completely gone.

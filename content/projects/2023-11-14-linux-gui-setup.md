---
title: "Graphical Setup For Linux Desktop"
description: "Instructional guide for setting up a GUI Window Manager in Linux | DWM + Alacritty"
date: 2023-11-14
hideSummary: true
ShowWordCount: true
ShowReadingTime: true
ShowToC: true
draft: false

cover:
  image: /img/arch/gui/linux_gui.png
  alt: File Share Image Cover

categories: [Computing]
---

# Introduction

After installing a fresh copy of Arch Linux, you are probably wanting to get around to setting up some type of graphical environment. 

It can be difficult to setup a graphical environment for the first time if there is not much guidance. Linux advice can be very scattershot, and can leave people feeling quite lost. You will end up digging through heaps of internet archives just to surface something vaguely relevant to your own setup. 

This article should guide you on creating a basic graphical setup for your Linux machine relatively quickly and with ease.

***Note: Depending on your own software and hardware, you may need to deviate from these prescribed procedures from time to time. Read the documentation for the programs you use and adjust accordingly.***

I will prescribe the software choices in this article, however, once you feel comfortable, you can choose to go in your own direction.

I setting up a window manger as the foundation for this guide. My system is running Arch Linux running under Hyper-V.

# Grub Config - Change Startup Screen Resolution

Something worth checking before you carrying on is changing your start up resolution. You don't want to manually modify the resolution every time you login.

### *Optional Hyper-V/Powershell Step*
 In powershell its worth running this command to set the maximum resolution for our VM:
```powershell
Set-VMVideo -VMName 'ArchVM' -HorizontalResolution 1920 -VerticalResolution 1080 -ResolutionType Single
```

### Modifying Grub Config

Go to the **/etc/default** directory which has the **grub** file:

You will want to edit the following grub variables:
- GRUB_CMD_LINUX_DEFAULT
- GRUB_GFXMODE

**GRUB_CMD_LINUX_DEFAULT** - You will need to append **video=hyperv_fb:1920x1080** to the end as shown below:

***Note: The video parameter may be different if you are doing this bare metal or are using another VM software.***

```bash
GRUB_CMD_LINUX_DEFAULT="quiet splash video=hyperv_fb:1920x1080"
```

**GRUB_GFXMODE** - You will need to specify the resolution here as shown below:

```bash
GRUB_GFXMODE=1920x1080
```

Save and exit from the grub file.

Now you will need to enact those changes onto the grub.cfg file which is read at boot time. So you will need to run the following command:

```bash
sudo grub-mkconfig -o /boot/grub/grub.cfg
```
After rebooting your Linux machine, your terminal should automatically scale to the 1080p resolution without having to make changes using commands like **xrandr -s 1920x1080** inside the display server.

# Creating a User - Getting Sudo Permissions

At this stage, you probably only have a root user on a fresh install, so it would be a good idea to create a user for yourself:

```bash
useradd -mg wheel filpill
```

You want to add yourself to the wheel group as we will make some changes to enable you to have access to the sudo command i.e. allow admin privlleges.

Add a password for that your using this command (and follow the prompts):
```bash
passwd filpill
```

Next you will need to edit the sudoers file in order to give the wheel group the relevant access.

You can find the file at /etc/sudoers.d and you will need to uncomment the following line:
```bash
%wheel ALL=(ALL) ALL
```

Now you will be able to execute commands as root after being prompted for a password.

# X11 - Display Server

Since we are using a window manager as the graphical environment, we are going to need to have some kind of display server.

Traditionally for Linux, **Xorg/X11** is the display server of choice as it has the best compatibility with other software. Alternatively, you have **Wayland** as a more efficient option, although you may run into compatibility issues depending on what software is running.

In order to maximise compatibility and stability, I will continue to configure using Xorg for the time being until Wayland catches up.

The following programs will need to be installed:
- picom
- xorg
- xorg-server
- xorg-xinit
- xf86-video-fbdev (video driver for Virtual Machine)

If you are installing on bare metal, then you will probably require a different video driver, so just research the one you need depending on the hardware you have.

Using pacman, you can install with is command:

```bash
sudo pacman -S picom xorg xorg-server xorg-init xf86-video-fbdev
```

# Alacritty - Terminal Emulator

There are many terminal emulators you can use as an option. The main terminal I've used in the past is called **st** which is one of the suckless utilities. I've liked it in the past, but I am trying something **Alacritty** this time around. Functionally, it should run much the same but will have a few extra built in features.

To install alacritty, you can run the pacman command to install it:

```bash
sudo pacman -S alacritty
```

# DWM - Window Manager

DWM forms the backbone for the environment we are building. Bare in mind this is a *Suckless* utility, therefore we are compiling the program from source. The program is written in C and needs to be compiled those C filed. Therefore, we cannot run a pacman command to install it.

Instead you will need to visit the [Suckless Website](https://suckless.org/) to get the source files and relevant patches.

They have the base version of dwm on git, so you will need to run the clone command to pull it down onto your machine. Run the git commmand:

```bash
git clone git://git.suckless.org/dwm
```

By default, DWM will point to **st** as the default terminal, you will need to alter this in the configuration to **Alacritty** as the new terminal we are planning to use.

Inside the dwm folder, you should look for the **config.h** file. This file has all the relevant configuration options for altering dwm to your needs.

As a quick start, you will need to change the following lines inside **config.h**:
- #define TERMINAL "st" -- change to --> #define TERMINAL "alacritty"
- #define TERMCLASS "St" -- change to --> #define TERMINAL "Alacritty"
- References to "st-256color" -- change to ---> "Alacritty"
- Any other config referencing a terminal emulator you are not using.

You just want to reference the terminal which you are using which in this case is "Alacritty".

After saving that file, we are not quite done yet, we must run a build command, to compile the configuration defined in C. 

You can compile the DWM using this command:

```bash
sudo make clean install
```

It's fairly straightforward, if no errors occur, you have successfull installed DWM.

# Config Files - .xinitrc and .bash_profile

### .xinitrc

Your .xinitrc is where you will:
- Start the terminal compositor as a background process
- Start DWM

After vimming into ~/.xinitrc; add these two lines in:
```bash
picom -b
exec dwm
```

***Note: Exec dwm MUST be the last executed command of the xinitrc file***

### .bash_profile

If you are using bash, this file will be called **.bash_profile**.

Depending on which shell you are using, the filename may be different. E.g. for **zsh**, the corresponding file would be called **.zprofile**

What you need to do in this file is essentially add a command to start the display server. The command for starting the display server is **exec startx**. 

After adding that command, your .bash_profile would look something like this:

```bash
#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

[[ $(fgconsole 2>/dev/null) == 1 ]] && exec startx --vt1
```

After saving your .bash_profile, you should be able to reboot your system.

The next time you login into your user profile, it should execute the commands in both ~/.bash_profile and ~/.xinitrc in order to start the display server and start DWM.

Now you should have DWM automatically loaded in and you should be able to spawn Alacritty terminal's inside DWM.

# Ranger - Terminal File Explorer

A neat program that I like to use to quickly navigate through filesystems in called **ranger**. It's handy for when you want to explore around more easily. Also very useful for bulk operations. You can install using pacman:

```bash
sudo pacman -S ranger
```

To open ranger, simply type: **ranger** into your terminal window.

# zsh - Changing default Shell

I prefer to use zsh as the default shell as opposed to bash. There are some extra features which can enhance the experience e.g.:

- Better Autocomplete
- Ability to Tab through 
- Change directories without typing 'cd'

This is by no means an exhaustive list. You can configure your shell to have as many or as little features as you want.

You can install zsh using the pacman command:

```bash
sudo pacman -S zsh
```

The first time you run zsh (by typing **zsh** into the terminal), you will be greeted with CLI configuration menu to perform a first time set up. Once thats complete, the setup menu will not appear again, it will just launch zsh.

However, if you want to change your default shell from bash to zsh when you login, you will need to run some extra commands.

First you will need to list all the available shells installed on the machine:

```bash
chsh -l
```

After finding the one you wish to use by default, you can type the command:

```bash
chsh -s /bin/zsh
```

You will be prompted for your password and after this stage the default shell is now zsh. The next time you login, it will spawn a zsh shell within Alacritty.

Don't forget to migrate all the configuration you have down in ~/.bash_profile to ~/.zprofile as bash and zsh don't share the same config files.

# Conclusion

At this stage you should have a fairly rudimentary setup, however, it should get you aquainted with the various features Linux provides and how to approach the configuration in the future.

You should consider saving all your configurations onto a git repo so you can more easily manage your setups and deploy a desktop environment more easily in the future. Ideally, you would want to run some of these procedures using shell scripts. Applying some automation will help in getting an environment setup more readily and consitently.

For now you can enjoy a more enhanced Linux experience and play around with new programs and new workflows.

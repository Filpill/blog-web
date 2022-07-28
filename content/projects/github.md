---
title: "Github - Command Line Interface Procedures"
date: 2022-07-17
draft: false
ShowToC: true

cover:
  image: img/github/github_terminal.png
  alt: 'Github Logo'

tags: [cli, shell, programming]
categories: [programming]
---

# Summary

The purpose of this page is to document the most common ways I interact with git and in maintaining my programs. These actions are performed via the command line as per how the tool was originally designed.

In my opinion the main benefit is the added efficiency of the scripting out the majority of the CLI commands via a series of shell scripts.

This simply allows you to direct all of your attention on creating better quality work without getting lost in a GUI most of the time.

### Connections and Authentication

There are 2 main ways to connect to a git repository. We can either use the HTTPS or SSH protocols respectively.

SSH has the advantage of passwordless interactions with git which I strongly recommended when pushing code. Not hard to set-up an SSH key-pair; it saves time and is very secure.

I would only use HTTPS if I am cloning someonelses public repo but not for maintaining my personal repos'.

I won't discuss the methods of generating access tokens which can be used to authenticate an https connection. In my experience this is the inferior way to authenticate your connection unless you specific reasons to use one outside of personal use.

### Create Local Repo and Connect to Remote Repository
- Go to Github and create a new repository
- Go to the working directory of your machine and initialise the local repo by typing:

```[bash]
git init
```
- Connect local repo to remote repo by typing:
```[bash]
git remote set-url origin repo_ssh_address
```

### Cloning a Github Repo

- Go to Github and copy ssh address of repository (assuming we are cloning
- Go to the directory where you want to clone the repository into and type:
```[bash]
git clone repo_ssh_address
```
- Or if you don't have an ssh key-pair set-up ,you can just switch the address with the HTTPS version which works just the same:
```[bash]
git clone repo_https_address
```

### Creating SSH Keys for Authentication Protocol
- Go to your dot ssh directory which is storing ssh-keys
- Type this command to generate an SSH Keypair:
```[bash]
ssh-keygen -t rsa -b 4096 -C youremail@yourdomain.com
```
- Name your SSH keys, and skip password prompts
- Copy the public key of the two that were generated and paste into the Github settings where you are saving your public keys

### Initialise SSH-Agent and Add Private SSH Key To Key Chain

This only lasts as long as your terminal instance is open. If you close the terminal, you need to re-type the commands to restart the ssh-agent for the next terminal you spawn.

*Note: The ssh agent process only linked to the terminal you typed it in. So you will need to type it in for every terminal instance you spawn (if you working on multiple terminals).*

I've already saved this as an shell script to save the effort of writing these commands all the time.

- To start ssh-agent type:
```[bash]
eval `ssh-agent`
```
- To add the private key to the ssh agent type:
```[bash]
ssh-add path/to/your/private/ssh/key
```

### Commit Changes to Github Repository

- Pull the most recent version from the repo by typing:
```[bash]
git pull origin main
```
- Make ammendments to your work and save it locally
- To queue up ALL changes to upload, type:
```[bash]
git add .
```
- To commit the changes type:
```[bash]
git commit -m ”add some comments here”
```
"To push the committed changes onto the main branch type:
```[bash]
git push origin main
```

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

## Github Procedures

### Create Local Repo and Connect to Remote Repository

{{<mermaid>}}
graph TD;
    A(Go to Github and<br> create a new repository)-->B[Go to the working directory of your machine <br>and initialise the local repo by typing: git init]
    B-->C(Connect local repo to remote repo by typing: <br>git remote set-url origin your_repo_ssh_address>)
{{< /mermaid >}}

### Cloning a Github Repo

{{<mermaid>}}
graph TD;
    A(Go to Github and copy ssh address of repository)-->B(Go to the directory where you want to save repo and <br>type: git clone repo_ssh_address)
{{< /mermaid >}}

### Creating SSH Keys for Authentication Protocol


{{<mermaid>}}
graph TD;
    A(Go to your dot ssh directory which is storing ssh-keys)-->B["Type this command to generate an SSH Keypair:<br> ssh-keygen -t rsa -b 4096 -C youremail@yourdomain.com"]
    B-->C["Name your SSH keys, and skip password prompts"]
    C-->D("Copy the public key of the two that were generated and paste<br>
into the Github settings where you are saving your public keys")
{{< /mermaid >}}
</div>


### Initialise SSH-Agent and Add Private SSH Key To Key Chain

{{<mermaid>}}
graph TD;
    A("To start ssh-agent type: eval `ssh-agent`")-->B("To add the private key to the ssh agent type:<br> ssh-add (path to your private ssh key)")
{{< /mermaid >}}

### Commit Changes to Github Repository

{{<mermaid>}}
graph TD;
    A(Pull the most recent version from the repo by typing:<br> git pull origin main)-->B["Make ammendments to your work and save it locally"]
    B-->C["To queue up ALL changes to upload, type: git add ."]
    C-->D["To commit the changes, type:<br> git commit -m ”add some comments here”"]
    D-->E("To push the committed changes onto the main branch; type:<br> ”git push origin main”")
{{< /mermaid >}}

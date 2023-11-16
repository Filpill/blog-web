---
title: "Github - Command Line Interface Procedures"
description: "Guide book for how to execute basic git commands on the terminal"
date: 2022-07-17
hideSummary: true
ShowWordCount: true
ShowReadingTime: true
draft: false
ShowToC: true

cover:
  image: img/github/github_terminal.png
  alt: 'Github Logo'

categories: [Computing]
---

# Summary

This article documents the most common ways I interact with git and in maintaining my programs. 

{{<mermaid>}}
graph LR;
    subgraph High-Level Process
    direction LR
    0[Installation]-->1[SSH]
    1 --> 2[Git Configuration]
    2 --> 3[New Repository]
    3 --> 4[Commit Changes]
    end
{{< /mermaid >}}

## Why should I use Git with the Command Line?

Git was designed as a command-line tool, therefore it's considered the de-facto way to interact with Git's tools.

Any other versions of Git are just wrappers for what Git does on the command-line. GUI type Software built "around Git" has tendencies to introduce bugs which are difficult to resolve.

You are abstracted away from what Git is actually doing, so it's not possible to tell if the error was with action performed in Git or if the software was somehow glitched.

Other tools may also rebrand some git commands to other names which can present communication issues if people are using different flavours of Git.

But its worth building some knowledge around the concept of how to use the Shell. *Bash* (shell) scripting is worth its weight it gold if leveraged correctly. It's great for task automation and shell is a transferable skill to other command-line type programs, e.g. bq command-line tool for GCP.


# Connections and Authentication

There are 2 main ways to connect to a git repository. We can either use the HTTPS or SSH protocols respectively.

SSH has the advantage of having passwordless interactions with git which I strongly recommended when pushing code. Its trivial to set-up an SSH key-pair; it saves time and its very secure. (Assuming you take the right precautions to protect your ssh-keys!)

My **deep personal recommendation is to use the SSH Method** and avoid using the access tokens for authentications.

Something worth noting is that Git will search the path for the ssh-key file **~/.ssh/id_rsa** by default. Make you name your file **id_rsa** otherwise it will not work.

## Creating SSH Keys Using ssh-keygen
- Go to your **~/.ssh** directory which is storing ssh-keys
- Type this command to generate an SSH Keypair:
```[bash]
ssh-keygen -t rsa -b 4096 -C emailnae@domain.com
```
- Name your SSH keys (**preferably "id_rsa"** for the default filename), and skip password prompts
- **"Cat"** out the **public key (suffixed .pub)** that was generated and paste into the Github settings for SSH Keys
- For security purposes, permissions need to be changed for the keys, you can change them using the below command prevent external read/write access:
```bash
chmod 600 ~/.ssh/id_rsa
chmod 600 ~/.ssh/id_rsa.pub
```

## Handling Multiple SSH Keys Using Keychain

If you happen to decide to put your keys outside the default path **(~/.ssh/id_rsa)**, git won't search for them.

I'm using a program called **Keychain** which can help manage your SSH Keys more easily. Its driving the underlying ssh-add and ssh-agent commands.

I've added this line (shown below) to my **.bashrc** in order to add the relevant SSH key to the keychain.

When I spawn a terminal, it will activate this command automatically and start a new process.

```bash
eval $(keychain --eval ~/.ssh_id_rsa/arch_vm) #2>/dev/null
```

In order to do the same process manually, these are the following commands:

```[bash]
eval `ssh-agent`
ssh-add path/to/your/private/ssh/key
```
# Git Basic Setup

## Setting Up Git Config
Inside your home directory you should have a file called .gitconfig which should be empty on a fresh install.

You can define the username and email of your github account in here with the following commands:

```bash
git config --global user.name "github_user_name"
git config --global user.email "emailname@domain.com"
```

## Create Git Repository 

This is the overall process of creating a repo on the CLI:
{{<mermaid>}}
graph LR;
    subgraph Creating Git Repository
    0[Create README with Repo Name]-->2[Initialise Git]
    2 --> 3[Stage Changes]
    3 --> 4[Link Local Repo to Remote Repo]
    4 --> 5[Commit Changes]
    end
{{< /mermaid >}}

- Create a README and initialise git with these commands:
```[bash]
echo "# repository_name" >> README.md
git init
```

By default the branch is called "master", however this can be renamed to anything you desire.

Lets rename "master" to "main" for example using this command:

```[bash]
git branch -m main
```
Staging is the process of preparing the changed files for the next commit.

You can stage the files with add; the full stop will include all files that have changed. Or you can explictly write which files you want to add to the commit.

The **commit** command will create the commit, (the -m flag allows you to add a commit message inline):

```bash
git add.
git commit -m "first commit msg"
```
To connect the remote repository to the the github server, you can write this command:

```bash
git remote add origin git@github.com:github.com:github_username/repo_name.git
```

To push your first commit into github, write this command (the -u flag sets a tracking reference upstream for the git pull command):

```bash
git push -u origin main
```

## Cloning a Github Repo

- Go to Github and copy ssh address of repository
- Go to the directory where you want to clone the repository into and type:

```[bash]
git clone git@github.com:github_username/repository_to_be_cloned.git
```

## Commit Changes to Github Repository

After using Git for much time on personal projects it's become very ritualistic for me to fall into this pattern:

{{<mermaid>}}
graph LR;
    subgraph Basic Workflow
    direction LR
    0[Pull]-->1[Add]
    1 --> 2[Commit]
    2 --> 3[Push]
    end
{{< /mermaid >}}

```[bash]
git pull origin main
git add .
git commit -m "add some comments here"
git push origin main
```

- Pull the most recent changes from repo 
- Make ammendments to your work and save it locally
- Queue up changes to upload
- Commit the changes
- Push the changes onto the checked out branch

## Working with branches

In most scenarios, you will not be working directly with the **main/master** branch. Working directly on main can be fraught with peril as you are constantly pushing every change into a production environment.

The purpose of branching off the main branch is to create an isolated development environment where you can safely change and push code to that branch without changing the production state. Especially if you haven't fully tested or validated your code/commits.

![Git Branch Commits](/img/github/git-branch.png#center)

You can can call branches whatever you want, but lets say you want to create development branch called ***"dev"*** from the branch you are currently on, you can do so with the **git checkout** command:

```bash
git checkout -b dev
```

Now you have a dev branch. The ***-b flag*** essentially tells git that you want to create a new branch.

Any commits you make on the dev branch will have to be pushed up to the dev server branch. This can be done like so:

```bash
git add .
git commit -m
git push origin dev
```

When you think your development is complete and you commits are ready to be put into production, you must perform a **git merge operation**.

In order for this to occur, you must switch back to the main branch of your repository before applying the merge:

```bash
git checkout main
git merge dev
```

And now all your "development commits" should be merged into the main branch.

If you want to see what other branches currently exist in your repository, you can simply type:

```bash
git branch -a
```

# Conclusion

This guide is designed to get you up and running with git on the CLI and understand the fundamentals of interacting with git.

With respect to the git's numerous other features, it's recommended to read [git's documentation](https://git-scm.com/doc) to understand how to use the tool in more depth.

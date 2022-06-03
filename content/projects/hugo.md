---
title: "Front-end Design - Static Site Generator"
date: 2022-06-03T12:29:15+01:00
draft: true
ShowToC: true

cover:
  image: img/hugo/hugologo.png
  alt: "Hugo Logo"

tags: ["html","css","markdown","go","website","javascript"]
categories: ["design"]

---

# Summary

Building this projects website was driven by a need to have an easy way showcase my projects without devoting a large amount of time to formatting and maintaining HTML code.

The first iteration of my website was manually written in HTML/CSS. However I decided to port over to a website using Hugo's framework which is fast and versitile.

As such there exists static site generators available which are able to solve such a problem.

Hugo is a static site generator written in Go and compiles your documents written in markdown into cleanly formatted HTML and CSS files.

The compiled HTML files are hosted on my github pages.

# Process

I will provide some general guidance as to how this website was developed:

## Github Repositories

- To build and deploy the website, we require two seperate repositories:
	- A production repo (blog-web): containing the markup documents
	- A deployment repo (Filpill.github.io): containing the file compiled into static HTML

- After the producing the file in the production repo, the static files sitting in the public folder are pushed inot the deployment repo.
- The deployment repo exists so we can allow github to easily search the html files and display them.

## Installing Hugo

- I'm working from an arch based linux OS at the time of development.
- Installing the hugo on arch can be simply done with the following pacman command:

```[zsh]
sudo pacman -S hugo
```
## Creating New Website

### Initialise Website Folders

- To initialise a new website type the following command into your shell:

```[zsh]
hugo new site name_of_your_website
```
- This will create all the folder templates you need to get started.

### Website Theme

- There are a couple of approaches to this, either you can write your own theme or you can choose one that is being share on git.
- I chose to use a repository called PaperMod which is a minimalistic theme which is fast and fits my requirements.
- If you cd into your themes directory I just cloned the PaperMod at that location.
- I'm choosing to use the SSH address to clone into it (as that how I normally interact with git). however you can also use HTTPS:

```[zsh]
git clone git@github.com:adityatelange/hugo-PaperMod.git
```
### Configuration File

- The configuration document is in the root directory and is called config.toml
- This file can be used to configure various aspects of your website

### How to make a webpage

Hugo's webpages sit into a the content folder of your website.

- cd to the root of your website
- To make a new page type (replace the page_folder and page_name with names of your choice:

```[zsh]
hugo new page_folder/page_name.md
```
- The name of the page and directory will form the links for your website
- You will have a new mark down file with the default markdown template for you page.
- Using markdown, you can populate the file with your webpage content.

### Images and Assets

### Compiling on Local Server

### Compiling Static Files into Public Folder

### Deploying pages onto your Github

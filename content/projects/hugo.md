---
title: "Website Design with Hugo Framework"
date: 2022-06-03T12:29:15+01:00
draft: false
ShowToC: true

cover:
  image: img/hugo/hugologo.png
  alt: "Hugo Logo"

tags: ["html","css","markdown","go","website","javascript","shell","vim","scripting"]
categories: ["design"]

---

# Summary

I wanted to showcase my projects without devoting a large amount of time to maintaining HTML code and needed a framework to make it easy to share my projects.

Hugo is a static site generator written in Go and compiles your documents written in markdown into cleanly formatted HTML and CSS files.

The first iteration of my website was manually written in HTML/CSS. It was a little bit ugly compared to the second iteration which is using hugo framework. Additionally, using someone else's theme takes alot of the legwork out of the page design.

The compiled HTML files are hosted on my github pages for reference.

- [Link to the Hugo Markdown Files](https://github.com/Filpill/blog-web)

- [Link to Static HTML Hotsted on Github Pages](https://github.com/Filpill/blog-web)

# Process

Here is some general guidance as to how this website was developed from a Linux OS perspective. The guidance should be adapted according to the OS being used:

## Github Repositories

- To build and deploy the website, we require two seperate repositories:
	- A production repo [blog-web](https://github.com/Filpill/blog-web): with markup documents and web config.
	- A deployment repo [Filpill.github.io](https://github.com/Filpill/Filpill.github.io): with compiled static HTML files.

- Content is added to the markdown documents in the production repo. This is later compiled into static HTML.
- The static files reside in the public folder. They are eventually pushed into the deployment repo.
- The deployment repository exists so we can allow github to display the HTML files.

## Installing Hugo

- I'm working from an Arch based Linux OS at the time of development.
- Installing the hugo on arch can be done with the following pacman command:

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

- There are a couple of approaches to this, you can either design your own theme or you can choose one that is publicly shared.
- I chose to use a repository containing a theme called PaperMod which is a minimalistic theme which fits my requirements.
- cd into your themes directory and clone the repository at that location.
- I'm choosing to use the SSH method to clone into it, however you can also use HTTPS method if you prefer:

```[zsh]
git clone git@github.com:adityatelange/hugo-PaperMod.git
```
### Configuration File

- The configuration document is in the root directory and is called config.toml
- This file configures various aspects of your website.

### How to make a webpage

Hugo's webpages reside in the content folder of your website.

- cd to the root of your website
- To make a new page type: (replace the page_folder and page_name with names of your choice)

```[zsh]
hugo new page_folder/page_name.md
```
- The name of the page and directory automatically form links for your website
- A new markdown file with a default template will appear for your page.
- Using markdown, you can populate the file with your webpage content.

### Images

Images are stored in one of two directories. Either the static or assets folder:

- The static folder exists if you wish to directly use your image in their original state via markdown.
- You may wish to optimise the image by scaling down the resolution or compressing the image, and this will only be the case if you call the image in the assets folder.
- You can make some HTML shortcodes to standardise the optimisation you want to apply to the image.
- Technically .gif files are not optimal inclusions into minimal websites due to the large file size. Although I like the visual presentation they provide.

### Compiling on Local Server

Observing the compiled version of the (draft) website is simple, type the following command:

```[zsh]
hugo server -D
```
- Adding the -D argument at the end also compiles the documents with the draft status set to true.
- Omitting the -D at the end of the command will not render documents in draft state.
- The local website host is at this address: [http://localhost:1313/](http://localhost:1313/)

### Adding a Submodule

A git submodule is a record within that points to a specific commit in another directory.

- This is a key component of this workflow as we want to send the contents of our public folder and point it to an external repo where we are hosting.

- In our case want our deployment repo [Filpill.github.io](https://github.com/Filpill/Filpill.github.io) to be a submodule of the projects repo.

- Therefore we want to cd into the root folder of our projects website ([blog-web](https://github.com/Filpill/blog-web)) and type:

```[zsh]
git submodule add -b main git@github.com:Filpill/Filpill.github.io.git public
```

And this enables us build from [blog-web](https://github.com/Filpill/blog-web) and to push code from the public folder of blog-web straight to [Filpill.github.io](https://github.com/Filpill/Filpill.github.io)



### Compiling Static Files into Public Folder

In order to compile the files nessesary for the deployment repository on git. Type the following command in the root directory of website:

```[zsh]
hugo -t hugo-PaperMod -D
```
- The argument after "-t" is theme which is being used to compile the website together. In my case I'm using hugo-PaperMod.
- The resulting files will compile straight into the public folder.
- Again similarly to the local host, adding a "-D" will transform draft pages as well as the finalised pages.
- You can choose to omit the "-D" when you are finalising the website. But you must change the draft state in the markdown pages.

### Deploying pages onto your Github

Since all the static files are compiled in public and we have that folder pointing towards the deployment repo. We can just write our git commands to push the changes into deployment.

```[zsh]
cd public/
git add .
git commit -m "deploying compiled html"
git push origin main
```

At this stage we have website up and running and hosted on github. Adding new content to the website is easily achieved with new markdown files. And changes are pushed with the previous 2 steps. Or we could script this out completely with a shell script.

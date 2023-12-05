---
title: "How to Copy-Paste in X11/Vim"
description: "How to copy between different programs in Linux"
date: 2023-12-05
hideSummary: true
ShowWordCount: true
ShowReadingTime: true
ShowToC: true
draft: true

cover:
  image: 
  alt: 

categories: [Computing]
---

# Summary
Something that can be quite confusing for beginners is not being able to directly copy paste into different instances in Linux using Xorg. 

There are many different ways to accomplish the copy-paste function, but I will outline how I like to do it.

As a pre-requisite you will need to have Neovim and xclip installed.

## Edit Config

You can add a couple of lines to your config in ~/.config/nvim/init.vim:

```config
"Copy paste to X11 Clipboard
vmap <leader><F6> :!xclip -f -sel clip<CR>
map  <leader><F7> mz:-1r !xclip -o -sel clip<CR>
```

## Pasting - From terminal to any instance

Essentially what is happening here, is that you are binding some keys in order to run some xclip commands. In my case its leader-F6 for copy and leader-F7 for pasting. This will allow you to copy things into any terminal instance simultaneously.

If you copied onto a clipboard using the bindings, you can of course copy into a web browser using ctrl-v very easily.

## Pasting - From graphical program e.g. web browser to terminal

Now, if you must copy from the web browser, it can be a bit different. On most non-linux computers, you are probably used to selecting, and then doing a ctrl-c, ctrl-v operation.

On **Linux running X11 with xclip**, the difference is that there is no copy operation. You only have to **highlight what you are copying**. And when you **paste, you must click the middle mouse button** on the target destination which is likely your terminal.

## Conclusion

And that's it, copy-pasting is pretty straightforward once you know these bits of information.





#!/bin/sh
directory="$HOME/work/blog-web/content/files"
file="filip_cv.pdf"
url="https://raw.githubusercontent.com/Filpill/LaTeX-CV/main/cv/filip-livancic-cv.pdf"
wget $url -O $directory/$file

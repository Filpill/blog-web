#!/bin/bash

echo "Deploying Website Updates to Github Pages"

# Build project
hugo -t hugo-PaperMod -D

# Commit and Push Changes
cd public
git add .
msg="rebuilding site `date`"
git commit -m "$msg"
git push origin main
cd ..
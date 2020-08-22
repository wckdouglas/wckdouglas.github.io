---
layout: post
title:  "Chromebook setup"
category: post
date:   2016-12-07
comments: true
---

# Computing environment setup guide for chromebooks

This is a note for myself to setup a developer environment on chromebook without using crouton (Running Linux GUI on chromeOS). I chose **[chromebrew](https://github.com/skycocker/chromebrew)** since it is just a CLI interface and doesn't require running anything on top of any apps. And I am also a fan of **[miniconda](http://conda.pydata.org/miniconda.html)**, which works well on the linux kernal of ChromeOS.

### Step 1: Preparation ###

Get into developer mode, go to terminal and enter **shell**

### Step 2: Install chromebrew ###

```  
wget -q -O - https://raw.github.com/skycocker/chromebrew/master/install.sh | bash
```  

### Step 3: Install zsh ###

```
crew install zsh
``` 

### Step 4: Install [oh my zsh](https://github.com/robbyrussell/oh-my-zsh) ###

```
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
echo zsh >> ~/.bash_profile
```  

### Step 5: Install vim ###

* For some reason ***crew install vim*** doesn't work for me

```  
cd /usr/local
git clone https://github.com/vim/vim.git
cd vim
./configure --prefix=/usr/local --disable-selinux
make
make install
cd ../
rm -rf vim
```  

### Step 6: Install miniconda ###

* set install path as ***/usr/local/miniconda2***

```  
cd ~/Downloads
curl -O https://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh 
zsh ~/Downloads/Miniconda2-latest-Linux-x86_64.sh
echo PATH=/usr/local/miniconda2/bin:$PATH >> ~/.zshrc
```

### UPDATE ###

I have switched to full linux: [GalliumOS](https://galliumos.org)

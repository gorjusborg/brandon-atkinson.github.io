---
title: Go Editor Setup
date: 2015-08-19
---

After a few nights reading the [golang-book](https://www.golang-book.com/) and hacking around with [golang](https://golang.org/) in general, I finally broke down and set up Vim to make it not feel like Unix circa 1970.
I took a look at the [IDE and text editor plugins list](https://github.com/golang/go/wiki/IDEsAndTextEditorPlugins) on the go github page and finally settled on a setup.

## Setup

* [Vundle](https://github.com/VundleVim/Vundle.vim) for managing vim plugins  
* [fatih/vim-go](https://github.com/fatih/vim-go) for code completion and syntax awareness
* [fatih/molokai](https://github.com/fatih/molokai) color scheme

## What I learned

* I've used vim for over a decade and know _nothing_ about it
* Vundle's required config breaks git if you are using the vi alias. This fixed it: `git config --global core.editor $(which vim)`
* vim's omni completion popup menu is pretty slick
* The completion popup's color was some ugly pink because I never told vim I was using a dark terminal background with `set background=dark`
* The iterm2 _tango-dark_ color scheme makes vim color scheme's look weird (I switched to the default dark scheme in iterm2 to fix)
* vim-go makes installing its go-based dependencies super easy

Now we'll see how long I continue to mess around with Go.

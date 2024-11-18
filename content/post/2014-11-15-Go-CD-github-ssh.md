---
title: Go CD with github via ssh
date: 2014-11-15
---

Trying to use a git@ url to pull from using the Go continous delivery agent?
I found http://support.thoughtworks.com/entries/21593593-Issues-with-Go-and-Github-SSH-Keys-?flash_digest=53af7e8bf011eda1e9112350616a350880049a70 on the thoughtworks go support forum. 

Dave Green correctly said that all you had to do was:

* sudo su - go # do the following commands as the 'go' user
* ssh-keygen # don't set a passsphrase on the key
* add the ~go/.ssh/id_rsa.pub contents to a new key on github
* git clone <some github repo> # this adds the github ssh server to known_hosts

The last step was what was tripping me up; the test clone adds the host signature to the known_hosts file. Apparently, the go git agent doesn't do this automatically.

# Authy SSH

## Pre-requisites

Authy API Key: https://www.authy.com/signup

## Installation

Type the following command in the terminal:

    $ curl 'https://raw.github.com/authy/authy-ssh/master/authy-ssh' -o authy-ssh
    $ sudo bash authy-ssh install /usr/local/bin

Then enable two-factor for your user:

    $ sudo /usr/local/bin/authy-ssh enable `whoami` <your-email> <your-country-code> <your-cellphone>

Test everything is working:

    $ authy-ssh test
    
Restart your SSH server (look below if you are not on Ubuntu).
    
    $ sudo service ssh restart


## Registering users

To enable users type:

    $ sudo authy-ssh enable <local-username> <user-email> <user-cellphone-country-code> <user-cellphone> 

## Enable two-factor only on your user.

    $ authy-ssh protect

## Restarting your ssh server

**Ubuntu**

    sudo service ssh restart

**Debian**

    sudo /etc/init.d/sshd restart
    
**RedHat and Fedora Core Linux**

    sudo /sbin/service sshd restart
    
**Suse linux**
    
    sudo /etc/rc.d/sshd restart


## Uninstall

To uninstall type:

    $ sudo authy-ssh uninstall
    $ restart your SSH server

# Authy SSH

## Pre-requisites.

1. Authy API Key: https://www.authy.com/signup

## Installation.

Type the following command in the terminal:

    $ curl 'https://raw.github.com/authy/authy-ssh/master/authy-ssh' -o authy-ssh
    $ sudo bash authy-ssh install /usr/local/bin

Then enable two-factor for your user:

    $ sudo /usr/local/bin/authy-ssh enable `whoami` <your-email> <your-country-code> <your-cellphone>

Test everything is working:

    $ authy-ssh test
    
Restart your SSH server (look below if you are not on Ubuntu).
    
    $ sudo service ssh restart

##### Restarting your ssh server

**Ubuntu**

    sudo service ssh restart

**Debian**

    sudo /etc/init.d/sshd restart
    
**RedHat and Fedora Core Linux**

    sudo /sbin/service sshd restart
    
**Suse linux**
    
    sudo /etc/rc.d/sshd restart
    
###  Installing without root privileges.

Type the following command in the terminal:

    $ curl 'https://raw.github.com/authy/authy-ssh/master/authy-ssh' -o authy-ssh
    $ bash authy-ssh install ~/.authy-ssh/

Then enable two-factor for your user:

    $ bash ~/.authy-ssh/authy-ssh enable `whoami` <your-email> <your-country-code> <your-cellphone>

Now protect your user:

    $ bash ~/.authy-ssh/authy-ssh protect

## How it works

Authy-ssh uses the sshd_config directive ForceCommand to run itself before every login. Here's how your sshd_config will look after installing:

    [root@ip-10-2-113-233 ~]# cat  /etc/ssh/sshd_config | grep ForceCommand
    ForceCommand /usr/local/bin/authy-ssh login

Whenever  it  runs authy-ssh will read it's configuration from /usr/local/bin/authy-ssh.conf
Here's an example:

    [root@ip-10-2-113-233 ~]# cat /usr/local/bin/authy-ssh.conf 
    banner=Good job! You've securely log-in with Authy.
    api_key=05c783f2db87b73b198f11fe45dd8bfb
    user=root:1
    user=daniel:1
    
In this case it means user root and daniel have two-factor enabled and that 1 is their  authy_id. If a user is not in this list, authy-ssh will automatically let him in.

## Using two-factor with Automated deployment tools. 


If you use **capybara**, **chef**, **puppet**, **cfengine**, **git** you can create new users for this tools so they can enter the machine without requiring two-factor.
Alternatively, you can user match on the forceCommand

A good example is create a two-factor users group.

    groupadd two-factor
    usermod  -a -G two-factor root 

Now that my root user is in the two-factor group, I edit my /etc/ssh/sshd_config

    [root@ip-10-2-113-233 ~]# cat /etc/ssh/sshd_config | grep ForceCommand -A 1 -B 1
    match Group two-factor
        ForceCommand /usr/local/bin/authy-ssh login

	$ /sbin/service sshd restart
    Stopping sshd:                                             [  OK  ]
    Starting sshd:                                             [  OK  ]

Now force command will only operate on users that belong to the two-factor group.


## Registering users.

To enable users type:

    $ sudo authy-ssh enable <local-username> <user-email> <user-cellphone-country-code> <user-cellphone> 


## Enabling two-factor only on your user.

At any time any user can enable two-factor on his account only by typing:

    $ authy-ssh protect


## Uninstall

To uninstall type:

    $ sudo authy-ssh uninstall
    $ restart your SSH server

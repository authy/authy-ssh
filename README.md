# Authy SSH

## Pre-requisites.

1. Authy API Key: https://www.authy.com/signup

## Installation.

Type the following command in the terminal:

    $ curl -O 'https://raw.githubusercontent.com/authy/authy-ssh/master/authy-ssh'
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

    sudo service sshd restart

**RedHat and Fedora Core Linux**

    sudo /sbin/service sshd restart

**Suse linux**

    sudo /etc/rc.d/sshd restart

###  Installing without root privileges.

Type the following command in the terminal:

    $ curl 'https://raw.githubusercontent.com/authy/authy-ssh/master/authy-ssh' -o authy-ssh
    $ bash authy-ssh install ~/.authy-ssh/


Now protect your user:

    $ bash ~/.authy-ssh/authy-ssh protect


## Enable two-factor auth on a user.

After the installation is finished, you have to proactively enable the two-factor for the users you want to protect.

To enable users type the following command and fill the form:

    $ sudo authy-ssh enable

If you want to do it in one line just type:

    $ sudo authy-ssh enable <local-username> <user-email> <user-cellphone-country-code> <user-cellphone>


## How it works

Authy-ssh uses the `sshd_config` directive `ForceCommand` to run itself before every login. Here's how your sshd_config will look after installing:

    [root@ip-10-2-113-233 ~]# cat  /etc/ssh/sshd_config | grep ForceCommand
    ForceCommand /usr/local/bin/authy-ssh login
]
Whenever  it  runs authy-ssh will read it's configuration from /usr/local/bin/authy-ssh.conf
Here's an example:

    [root@ip-10-2-113-233 ~]# cat /usr/local/bin/authy-ssh.conf
    banner=Good job! You've securely logged in with Authy.
    api_key=05c783f2db87b73b198f11fe45dd8bfb
    user=root:1
    user=daniel:1

In this case it means user root and daniel have two-factor enabled and that 1 is their `authy_id`. If a user is not in this list, `authy-ssh` will automatically let him in.

## Using two-factor auth with automated deployment tools.


If you use **capybara**, **chef**, **puppet**, **cfengine**, **git** you can create new users for these tools so they can enter the machine without requiring two-factor.
Alternatively, you can match users using the `ForceCommand` directive.

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


## `scp`, `sftp`, `mosh` and `git push` with two-factor authentication.

To enable non-interactive commands like `scp`, `sftp`, `mosh` and `git clone|fetch|push` you have to allow to pass the environment variable `AUTHY_TOKEN` from the client. To do so edit your `sshd_config` (normally located at `/etc` or `/etc/ssh/`) and add `AUTHY_TOKEN` to the AcceptEnv directive:

	AcceptEnv AUTHY_TOKEN

Then configure the client to send that variable to the server, to do so first open `~/.ssh/config` and then add the following:

	Host *
		SendEnv AUTHY_TOKEN

And finally pass the token before the command:

    AUTHY_TOKEN="valid-token" git push origin master
    AUTHY_TOKEN="valid-token" scp server:path/to/file local-file
    AUTHY_TOKEN="valid-token" mosh server

### Note

For cases like `sftp` if you enter an invalid token, you may receive a response like *"Received message too long 458961713"*. This is because the interactive command is not able to render the proper output text message returned by the program.

## Multiple users sharing the same unix account.

If you have many users that need to share a single login, you can still use strong two-factor authentication without sharing the same token. This means that every user can have their own Authy Token, ensuring non-repudiation.

To achieve this, delete or comment out the `ForceCommand` directive from your `sshd_config`:

	$ sudo sed -ie 's/^\(ForceCommand.*authy-ssh.*\)/#\1/g' /etc/ssh/sshd_config

and then for each person add their ssh key using the following command:

	$ sudo authy-ssh protect

you should end up with an authorized_keys file that looks like:

	command="/usr/local/bin/authy-ssh login 13386" ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDGRJbWu+WLVXYVADY3iQPE1kA7CIOSqHmskPM8qIAzKzq+1eRdmPwDZNmAvIQnN/0N7317Rt1bmTRLBwhl6vfSgL6677vUwsevPo27tIxdja67ELTh55xVLcJ3O8x2qkZsySgkLP/n+w3MUwLe1ht31AZOAsV7J7imhWipDijiysNgvHyeSWsHqExaL1blPOYJVHcqPbKY4SxFRq/MWeyPf/Sm24MFSKEaY6u0kNx8MLJ1X9X/YxmY9rdvzsZdQ7Z/PYhYt2Ja/0mzfYx2leeP2JQBsVfZZzAoFEPpw6mSP9kJREGe2tXvS9cRenhz/+V0+mvSJKG0f0Zzh428pTzN
	command="/usr/local/bin/authy-ssh login 20" ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAyvj2d0rSDukDT04mK7njUxtXffUrOnDCm2Bqub0zN7LQS733nBHp89aMuBI5ENjw1SQ2qXhLxvK1Xhr0pQr+dOWNn3emQjQuiA+YL39yp2RLLpflerJ3KAVY09CHYLFxdKj/DJgXsH+LMAPe2uVmWCP2xAV5ZcLnz3CdS2SX/EVlbNrftesZx9uAbmwKPLY1pmW7q/75AhJRow8VTP7zM/VS7jEHkj03g51BZGB8tMI3G8RDVEDtu2jVwZiq+8BaNCyjYVlsLfu6uGhnXeeUS3swu/atlt+pxy+QTf/HGvrJR58tER+foqheWtV3LqXN4oLckzqTVkDDmnNJlmrpYQ==

The previous command will ask you the user ssh public key, cellphone and email.

## Uninstall

To uninstall type:

    $ sudo authy-ssh uninstall
    $ restart your SSH server


## Running Unit Tests

Fork and clone the git repository https://github.com/authy/authy-ssh.git

    $ cd tests
    $ rake test

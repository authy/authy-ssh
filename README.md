# Authy SSH


## Installation

Type the following command in the terminal:

    $ curl 'https://raw.github.com/authy/authy-ssh/master/authy-ssh' -o authy-ssh
    $ sudo bash authy-ssh install /usr/local/bin

## Registering users

To enable users type:

    $ sudo authy-ssh enable <local-username> <user-email> <user-cellphone-country-code> <user-cellphone> 


## Uninstall

To uninstall type:

    $ sudo authy-ssh uninstall


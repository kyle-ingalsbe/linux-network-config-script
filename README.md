# linux-network-config-script
This is a script that was developed to quicky configure a lot of various servers, with different linux distros, with a single static IP address, gateway, and DNS.  This only configures one server at a time. 

This script, when run without options, will ask you for a static IPv4 address. Simply enter that address and read the prompts. It will display various information, like which ethernet card to use, how the network config file works, and whether you would like to commit the changes. The Gateway is programmed in to be a constant. With an IP address of XXX.XXX.XXX.BBB, the Gateway will always be XXX.XXX.XXX.(BBB - 1). Meaning that it will always be one less than the final octet. So if the ip address is 192.168.1.2, then the gateway will be 192.168.1.1. 

This script will configure about 7 different forms of networks, including old and current (until the end of 2024) distros of debian, Ubuntu, and fedora style network configs. Opensuse is only partially implemented, but is still likely broken. 

Usage:
./config_network.sh
./config_network.sh [option]

Options:

-fake|-generate)
This option will echo out how the config file should look for any specific linux distro. This option does not modify files.

-sshroot)
This option will give some basic info about how to enable root login with ssh


-net-restart |  -nr | -restart)
This will try every known way to restart the internet for all distributions.

No Options)
This is the default runtime to automatically install the network configs.

-loc | -location)
This will show you the locations of the network files for the different linux versions

#!/bin/bash


function a___________variables_______________________________________________________()
{
	echo " "
}


#======================================================================================================================================
#				FUNCTION variables				FUNCTION variables				FUNCTION variables				FUNCTION variables
#======================================================================================================================================


# Company name - so it will write the name of the company to the network config file.
company_name = "X_company"

# dns server ip addresses - change if you need to
dns1="8.8.8.8"
dns2="8.8.4.4"

#the log file name - always has the date
log_file="log-$(date +%Y-%m-%d-%H_%M_%S).log"

#debug - 1 for debugging state, any other number for not debugging
debug=0

# fle is a var that is used for the temp net config file so it can be echoed or put into a temp file.
fle=" "



function a___________function___pieces_______________________________________________________()
{
	echo " "
}

#======================================================================================================================================
#				FUNCTION Pieces					FUNCTION Pieces					FUNCTION Pieces					FUNCTION Pieces				
#======================================================================================================================================

# the function pieces basically are little parts that are used all over the place by the core functions.



#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


# used for debug so i know which function i am at if the script fails.
function print_loc()
{
	if [[ $debug -eq 1 ]]; 
	then
		echo "@ $1 "	
	fi
	
}
	

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


print_loc "detect_eth_name "	

#detect the ethernet name
function detect_eth_name()
{
    temp=$(ip link | awk -F: '$0 !~ "lo|vir|wl|^[^0-9]"{print $2;getline}' | head -n 1)
    
    #get rid of the leading space
	echo "$temp" | tr -d ' '

}
#end detect eth name


#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


print_loc "which_netplan_file_echo_base"	

#generic reusable "using the xxx network plan" echo...
function which_netplan_file_echo_base(){
	
	
	d_echo
	r_echo "Using the $1 Networking Plan"	
	s_echo


}


#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


print_loc "which_netplan_file_echo"	

#generic reusable "using the xxx network plan" echo...
function which_netplan_file_echo(){
	
	
	which_netplan_file_echo_base $1

	confirm_eth_interface

	s_echo

}


#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

print_loc "d_echo "	

function d_echo()
{
		echo ""
		echo ""
		echo "" >> $log_file
		echo "" >> $log_file

}


#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


print_loc "s_echo "	

function s_echo()
{
		echo ""
		echo "" >> $log_file

}


#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


print_loc "r_echo "	

function r_echo()
{
		echo "$1"
		echo "$1" >> $log_file

}


#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


print_loc "f_loc "	

function f_loc()
{
	
	fle_add " "
	fle_add "#$1"
	fle_add " "
	fle_add "#Location:"
	fle_add " "
	fle_add "#$2"

}


#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


print_loc "f_prep"	

function f_prep()
{
	r_echo "File to be modded:"
	r_echo "$loc"

	cp ${loc} ${loc}.bak	
	r_echo "A backup has been made."	

}


#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


print_loc "fle_out"	

#this will echo  $fle or put it into a file for the network 
function fle_out()
{

    case "$1" in
	
		echo)
		
			# if echo
		
			echo "${fle}"
			
			echo " "
			echo "Write to a file? [N/y]"
			read yn
			if [ "$yn" = "y" ] || [ "$yn" = "Y" ]
			then
				echo "${fle}"  > eth_config
				echo "Written to eth_config"
			fi
			# the log file tends to be made even when making a fake config
			rm $log_file
		;;
		 
		*) 
			 #if put into temp
			 #create the file instead of adding to it.
			 echo "${fle}"  > tmp_nt
		;;
    esac

}


#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


function fle_start()
{
	#clear out fle
	fle=""	
		
	# the beginning of the file
	fle_add "# ${company_name} generated file" 
	
}


#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


function fle_add()
{
	
	fle="${fle}"$'\n'"$1"

}


#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


print_loc "echo_conf_hf"	

function echo_conf_hf()
{

	d_echo
	r_echo "$1 config  ============================="
	d_echo

}
#end echo_conf_hf "New"


#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


function a___________general___funcs_______________________________________________________()
{
	echo " "
}

	
#======================================================================================================================================
#				FUNCTIONS				FUNCTIONS				FUNCTIONS				FUNCTIONS				FUNCTIONS
#======================================================================================================================================


print_loc "get_os"	

function get_os(){


	# test to see if the file exists here
	if test -r /etc/os-release
		then
			os_ver=$(awk -F= '$1=="ID" { print $2 ;}' /etc/os-release)		
		else  #change dir if necessary
			os_ver=$(awk -F= '$1=="ID" { print $2 ;}' /usr/lib/os-release)
	fi
	
	#the awk gives back the answer in quotes, so remove the quotes
	
	os_ver="${os_ver%\"}"
	os_ver="${os_ver#\"}"
	
	
	#ok... functions do not return things, but the output can be captured by a var
	# so... we echo out the data and capture it
	
   echo ${os_ver}
    

}
#end get_os


#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


print_loc "get_os_version"	

function get_os_version(){


	# test to see if the file exists here
	if test -r /etc/os-release
		then
			os_ver=$(awk -F= '$1=="VERSION_ID" { print $2 ;}' /etc/os-release)		
		else  #change dir if necessary
			os_ver=$(awk -F= '$1=="VERSION_ID" { print $2 ;}' /usr/lib/os-release)
	fi
	
	#the awk gives back the answer in quotes, so remove the quotes
	
	os_ver="${os_ver%\"}"
	os_ver="${os_ver#\"}"
	
	
	#ok... functions do not return things, but the output can be captured by a var
	# so... we echo out the data and capture it
	
    
	echo ${os_ver}
}
#end get_os_version


#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


print_loc "confirm_eth_interface "	

function confirm_eth_interface()
{
	
		ip a
		
		deb_interface=$(detect_eth_name)

		d_echo
		r_echo "detected the ${deb_interface} nic card"		
		s_echo

		r_echo "Enter a different interface? [y/N]" 
		read yn
		echo "Chose: $yn"  >> $log_file

		if [[ "$yn" ==  "y" ||  "$yn" ==  "Y" ]]; then

			r_echo "Enter new interface:"
			read deb_interface
			echo "New interface: $deb_interface"  >> $log_file
		fi
		
		s_echo

}
#end confirm eth interface


#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


print_loc "get_ip_addr "	

function get_ip_addr(){

	
	reloop=1
	
	while [ $reloop -eq 1 ]
	do
		
		r_echo "Enter the IP address or q to quit" 
		read  ip
		echo "Input: $ip" >> $log_file

		if [[ "$ip" =~ (([01]{,1}[0-9]{1,2}|2[0-4][0-9]|25[0-5])\.([01]{,1}[0-9]{1,2}|2[0-4][0-9]|25[0-5])\.([01]{,1}[0-9]{1,2}|2[0-4][0-9]|25[0-5])\.([01]{,1}[0-9]{1,2}|2[0-4][0-9]|25[0-5]))$ ]]; then
		  
		  
			#split the ip address into different vars
			read a b c d <<<"${ip//./ }"

			#make the gateway ip section
			e=$((d-1))

			reloop=0
		  
		else
		
		  if [ "$ip" = "q" ]
		  then
			exit 1
		  fi
		  clear
		  r_echo "bad IP. Try again. Tip: only use IP v4 and dont put in the mask /29"
		  d_echo		  
		  
		fi
	done

}
#end get ip addr


#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


print_loc "compare_interfaces "	

function compare_interfaces()
{
		d_echo
        echo_conf_hf "Old"
		cat ${loc}
		cat ${loc} >> $log_file
		echo_conf_hf "New"
		cat tmp_nt
		cat tmp_nt  >> $log_file
		
		d_echo

}


#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


print_loc "try_all_network_restarts"	

function try_all_network_restarts()
{

		
		r_echo "Trying all methods to restart a network"
		
		echo "systemctl method"
		#redhat styles
		systemctl restart networking
		systemctl restart NetworkManager
		systemctl restart network
		
		echo "if method"
		#old style with 'if' commands
		ifdown ${deb_interface}
		ifup ${deb_interface}
		
		echo "service network stop/start - opensuse way"
		#opensuse styles
		echo "stopping network..."
		service network stop
		echo "starting network..."
		service network start
		
		echo "trying ubuntu method"
		netplan apply
		
		
}


#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


print_loc "network_file_location"	

#all of the network config locations in one spot
function network_file_location()
{
	
	case "$1" in
	
		new|rh-new)
		
			loc="${deb_interface}.nmconnection"
			cd /etc/NetworkManager/system-connections
			
		;;
		
		old|rh-old)
		
			loc="ifcfg-${deb_interface}"
			cd /etc/sysconfig/network-scripts	
		
		;;
		
		deb|debian)
		
			loc="interfaces"			
			cd /etc/network			
			
		;;
		
		
		ubuntu|ubuntu18|ubuntu22)
			
			cd /etc/netplan
			loc=$(ls *.yaml | head -1)
			
		;;
		
		suse)
			cd /etc/sysconfig/network/	
		;;
		

	esac

}

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


print_loc "network_file_location_info"	

#all of the network config locations in one spot
function network_file_location_info()
{
	
	clear
		echo "file locations"
		echo  " "
		
		echo "CentOS 9+"
		echo "file: <ethernet interface>.nmconnection"
		echo "path: /etc/NetworkManager/system-connections"
		echo " "

			
		echo "CentOS < 9"
		echo "file: ifcfg-<ethernet interface>"
		echo "path: /etc/sysconfig/network-scripts"
		echo " "
		
		echo "Debian"
		echo "file: interfaces"			
		echo "path: /etc/network"			
		echo " "	
			
		echo "Ubuntu"
		echo "file: *.yaml (many different names but is a yaml file)"
		echo "path:/etc/netplan"
		echo " "	
		
		
		echo "Suse:"
		echo "3 different files: "
		echo "ifcfg-<ethernet interface> "
		echo "config"
		echo "ifroute-<ethernet interface>"
		echo "path: /etc/sysconfig/network/	"


}


#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


print_loc "suse_style_interface"	

function suse_style_interface()
{

		cd /etc/sysconfig/network/		
		
		generate_suse_files
				
		try_all_network_restarts
		ip a
}


#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


print_loc "x_style_interface"	

function x_style_interface()
{
	
	
		
	confirm_eth_interface	
	
	network_file_location $1
	
	if [ "$1" != "suse" ]
	then
		
		f_prep

	fi
	
	case "$1" in
	
		new|rh-new|old|rh-old)
		
			create_red_hat_network_file $1 $2
			
		;;
				
		deb|debian)
		
			create_debian_network_file 
			
		;;
		
		ubuntu18)
			create_ubuntu_network_file 18
		;;
		
		ubuntu22)
			create_ubuntu_network_file 22
		;;
		
		suse)
			suse_style_interface
			exit 1
		;;
		
	esac

	if [ "$2" != "echo" ]
	then
		compare_interfaces
		apply_changes
		try_all_network_restarts
		sleep 4
		ip a
	fi	

	
}


#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


print_loc "apply_changes"	

function apply_changes()
{

	r_echo "Apply Changes? [Y/n]"
	read r
	
	echo "Chose $r" >> $log_file
	
	s_echo 
	
	if [[ "$r" ==  "y" ||  "$r" ==  "Y" ||  "$r" ==  "" ]]; then

		rm ${loc}

		mv tmp_nt ${loc}
		
		
		d_echo
	else
		r_echo "Changes not applied. Exiting..."
		
		exit 1
	fi
	

}
#end apply changes


#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


print_loc "get_eth_info"	

#specifically made for the echo interface so it would not try to pull from the system
function get_eth_info()
{
	s_echo
	get_ip_addr
	s_echo
	r_echo "Enter the ethernet card name:"
	read deb_interface
	echo "Changing interface to: $deb_interface" >> $log_file
	s_echo

}
#end get echo info


#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++




function a___________file___generation_______________________________________________________()
{
	echo " "
}

	
#======================================================================================================================================
#				File FUNCTIONS				File FUNCTIONS				File FUNCTIONS				File FUNCTIONS
#======================================================================================================================================


print_loc "generate_suse_files "	

function generate_suse_files()
{

	#suse is a little interesting. yast usually handles this, so it can get funky. so far, i have found 3 different files for the network config. 
	# they are all under teh /etc/sysconfig/network (for ver 15.3) 


	which_netplan_file_echo "OpenSUSE"
	
	echo "# ${company_name} generated file" > tmp_nt_cfg
	
	
	#this handles the config file ---------------------------------------------------
	
	loc="config"
	
	f_prep
	
	cat ${loc} | while read line || [[ -n $line ]];	
	do

		
		  case "$line" in
		  
		  NETCONFIG_DNS_STATIC_SERVERS*)
				
				echo "NETCONFIG_DNS_STATIC_SERVERS=\"${dns1} ${dns2}\"" >> tmp_nt_cfg
		  ;;
		  *)
			echo "$line" >> tmp_nt_cfg
				
		  ;;
		  
		esac
	  
	done 
	
	cp tmp_nt_cfg ${loc}
	
	
	# this handles the ifcfg-XXX file -------------------------------------------------
	
	loc="ifcfg-${deb_interface}"
	
	f_prep	
	
	echo "# ${company_name} generated file" > tmp_nt_ifcfg
	echo "IPADDR='${a}.${b}.${c}.${d}/29'" >> tmp_nt_ifcfg
	echo "MTU='0'" >> tmp_nt_ifcfg
	echo "BOOTPROTO='static'" >> tmp_nt_ifcfg
	echo "STARTMODE='hotplug'" >> tmp_nt_ifcfg
	echo "ZONE=external" >> tmp_nt_ifcfg
	
	cp tmp_nt_ifcfg ${loc}
	
	r_echo "Note that the zone has been set to external so make sure that ssh is open in the external zone in the firewall."
	

	# this handles the ifroute-XXX file -----------------------------------------------
	
	loc="ifroute-${deb_interface}"
	
	f_prep
	
	r_echo "# ${company_name} generated file" >  tmp_nt_ifroute
	
	cp tmp_nt_ifroute ${loc} 


	

}

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


print_loc "create_red_hat_network_file "	

function create_red_hat_network_file()
{
	#first read in the connection stuff and add it to 
	
	#erase current file and restart it , or creater new one if it doesnt already exist
	fle_start
	
	uuid="uuid=<add uuid here> "
	
	if [ "$2" != "echo" ]
	then
	
		uuid=$(grep -i "uuid" ${loc})
	
	fi
	
		case "$1" in
	
		new|rh-new)
		
			fle_add " "
			fle_add "[connection]"
			fle_add "id=${deb_interface}"
			fle_add "${uuid}"
			fle_add "type=ethernet"
			fle_add "autoconnect-priority=-999"
			fle_add "interface-name=${deb_interface}"
			fle_add " "
			fle_add "[ethernet]"
			fle_add " "
			fle_add "[ipv4]"
			fle_add "address1=${a}.${b}.${c}.${d}/29,${a}.${b}.${c}.${e}"
			fle_add "dns=${dns1};${dns2};"
			fle_add "method=manual"
			fle_add " "
			fle_add "[ipv6]"
			fle_add "addr-gen-mode=eui64"
			fle_add "method=auto"
			fle_add " "
			fle_add "[proxy]"
	
			if [ "$2" = "echo" ]
			then				
				
				f_loc "New Red Hat / CentOS 9+ Config" "/etc/NetworkManager/system-connections/${deb_interface}.nmconnection"

			fi	
		;;
		
		old|rh-old)	
					
			fle_add "TYPE=Ethernet"
			fle_add "PROXY_METHOD=none"
			fle_add "BROWSER_ONLY=no"
			fle_add "BOOTPROTO=none"
			fle_add "DEFROUTE=yes"
			fle_add "IPV4_FAILURE_FATAL=no"
			fle_add "IPV6INIT=yes"
			fle_add "IPV6_AUTOCONF=yes"
			fle_add "IPV6_DEFROUTE=yes"
			fle_add "IPV6_FAILURE_FATAL=no"
			fle_add "IPV6_ADDR_GEN_MODE=stable-privacy"
			fle_add "NAME=${deb_interface} "
			fle_add "${uuid}"
			fle_add "DEVICE=${deb_interface} "
			fle_add "ONBOOT=yes"
			fle_add "IPADDR=${a}.${b}.${c}.${d}"
			fle_add "PREFIX=29"
			fle_add "GATEWAY=${a}.${b}.${c}.${e}"
			fle_add "DNS1=${dns1}"
			fle_add "DNS2=${dns2}"
	
	
			
			if [ "$2" = "echo" ]
			then
			
				f_loc "Old Red Hat / CentOS <9 Config" "/etc/sysconfig/network-scripts/ifcfg-${deb_interface}"

			fi	
		;;
		
		esac
		
		
			if [ "$2" = "echo" ]
			then	
				fle_add " "
				fle_add "# dont forget to add the uuid to this, otherwise it will fail."
			fi
		
		fle_out $2

}
#end generate_new_red_hat_network_file


#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


print_loc "echo_ubuntu_network_file	"

#used to be create_ubuntu_22_temp_file_echo create_ubuntu_18_temp_file_echo
function echo_ubuntu_network_file()
{
	clear
	
	case "$1" in
	
		22)
		
			echo "Ubuntu 22+ Config"
			echo "location: /etc/netplan "
			echo "Look for a yaml file."
			echo "Might be named 50-cloud-init.yaml"	
				
		;;
		
		18)
			echo "Ubuntu 18 to 20 Config"
			echo "location: /etc/netplan "
			echo "Look for a yaml file."
			echo "Might be named 00-installer-config.yaml"	
		;;
		
	esac


	create_ubuntu_network_file $1 "echo"


}
#end generate_ubuntu_18_netplan_file_echo


#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


print_loc "create_ubuntu_network_file"

# used to be create_ubuntu_22_temp_file create_ubuntu_18_temp_file
function create_ubuntu_network_file()
{

	fle_start

	fle_add "network:"
	fle_add "   ethernets:"
	fle_add "     ${deb_interface}:"  

	
	case "$1" in
	
		22)
		
			fle_add "       dhcp4: false" 
			fle_add "       addresses:" 
			fle_add "         - ${a}.${b}.${c}.${d}/29" 
			fle_add "       nameservers:" 
			fle_add "         addresses:" 
			fle_add "           - ${dns1}" 
			fle_add "           - ${dns2}" 
			fle_add "       routes:" 
			fle_add "           - to: default" 
			fle_add "             via: ${a}.${b}.${c}.${e}" 
				
		;;
		
		18)
		
		#else 18
		
			fle_add "       dhcp4: no" 
			fle_add "       addresses: [${a}.${b}.${c}.${d}/29]"  
			fle_add "       gateway4: ${a}.${b}.${c}.${e}"  
			fle_add "       nameservers:"  
			fle_add "        addresses: [${dns1},${dns2}]"  
		
		;;
		
	esac

	# keep this below, b/c i want this to be the last thing printed
    fle_add "   version: 2" 
    
    
    # 2nd arg: either echo it out or stor it to temp
   
    fle_out $2
    
    #cloud config likes to give us all sorts of trouble these days, so disable it.
     echo "network: {config: disabled}" >> /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg 
    
}
#end create_ubuntu_network_file


#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


print_loc "generate_debian_network_file "	

function create_debian_network_file(){

	fle_start

	case "$1" in
	
		echo)
			f_loc "Debian Config" "/etc/network/interfaces"
		;;
		
		*)
			which_netplan_file_echo_base "Debian"
			#confirm_eth_interface
		
		;;
	esac
	

	s_echo
	
	fle_add "source /etc/network/interfaces.d/*"
	fle_add "# The loopback network interface"
	fle_add "auto lo"
	fle_add "iface lo inet loopback"
	fle_add " "
	fle_add "# The primary network interface"
	fle_add "allow-hotplug ${deb_interface}"
	fle_add "iface ${deb_interface} inet static"
	fle_add "      address ${a}.${b}.${c}.${d}"
	fle_add "      gateway ${a}.${b}.${c}.${e}"
	fle_add "      netmask 255.255.255.248"
	fle_add "      dns-nameservers ${dns1} ${dns2}"

	fle_out $1


}
#end generate_debian_network_file


#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


function a___________core___routines_______________________________________________________()
{
	echo " "
}



#======================================================================================================================================
#			core	FUNCTIONS			core	FUNCTIONS			core	FUNCTIONS			core	FUNCTIONS
#======================================================================================================================================


#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

print_loc "main_exec"	

function main_exec()
{

	os_ver=$(get_os) 
	
	r_echo "OS detected: ${os_ver}"
	os_ver_num=$(get_os_version) 

	r_echo "Version detected: ${os_ver_num}"
	
	read na nb nc <<<"${os_ver_num//./ }"
	
	case "$os_ver" in
	
	Ubuntu|ubuntu)
	
	
		cd /etc/netplan
		loc=$(ls *.yaml | head -1)
		
		f_prep			
		
		if [[ $na -ge 22 ]];
		then
			which_netplan_file_echo "Ubuntu 22+"
			create_ubuntu_network_file 22
		elif [[ $na -lt 22 && $na -ge 18 ]];
		then
			#generate_ubuntu_18_netplan_file
			which_netplan_file_echo "Ubuntu 18"
			create_ubuntu_network_file 18
		elif [[ $na -lt 18 ]];
		then			
			x_style_interface "deb"
		else
			r_echo "unsupported version: ${os_ver_num}"			
			exit 1
		fi
		
		compare_interfaces
		
		apply_changes
		
		# ubuntu 24 complains about the permissions, so fix it for everyone.
		chmod 600 ${loc}
		netplan apply
		ip a
	;;
	
	debian|Debian)	
	
		x_style_interface "deb"
	;;
	
	opensuse-leap)
	
		suse_style_interface		
		
	;;
	
	almalinux)
		x_style_interface "rh-old"
	;;
	
	centos)
	
		# cent os 9 has the new version
		if [[ $na -ge 9 ]];
		then
			x_style_interface "rh-new"
		else
			x_style_interface "rh-old"
			
		fi
	
	;;
	
	
	*) 
		user_choose_config
		exit 1
	;;
	
	esac
	 


}
#end main exec


#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


print_loc "user_choose_config_menu"	

function user_choose_config_menu()
{
	
	r_echo "This script does not support ${os_ver} ${os_ver_num} automatically"
	r_echo "So... Choose a distro ${os_ver} ${os_ver_num} may be based off of:"
	r_echo " "
	r_echo "[1] Debian"
	r_echo "[2] OpenSuse"
	r_echo "[3] Ubuntu 22+"
	r_echo "[4] Ubuntu 18 to 21"
	r_echo "[5] Ubuntu <= 17"
	r_echo "[6] Old Red Hat < 9"
	r_echo "[7] Red Hat 9+"
	r_echo "[q] Quit"
	r_echo " "

}
# end user_choose_config_menu

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

print_loc "user_choose_config"	

function user_choose_config()
{

	
	user_choose_config_menu
		
	
	while read -p "Which config to use (or Q): " choice
	do
	
	
		case "$choice" in
		
		1|5)
			x_style_interface "deb"	
			exit 1		
		;;
		
		2)			
			suse_style_interface
			exit 1
		;;
		
		3)			
			which_netplan_file_echo "Ubuntu 22+"
			create_ubuntu_network_file 22
			exit 1
		;;
		4)			
			#generate_ubuntu_18_netplan_file
			which_netplan_file_echo "Ubuntu 18"
			create_ubuntu_network_file 18
			exit 1
		;;
		
		6)
			x_style_interface "rh-old"
			exit 1
		;;
		
		7)
			x_style_interface "rh-new"
			exit 1
		;;
		
		q|Q)
			r_echo "Exiting..."
			exit 1
		;;
		*) 
			r_echo "unknown selection: ${choice}"
			user_choose_config_menu
			
		;;
		
		esac
	
	done


}
#end main exec


#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


function generate_net_config_distro_list()
{
		
		echo "<distro> options:"
		echo " "
		echo "[1] Debian"
		echo "[2] Alma linux"
		echo "[3] Ubuntu 22+"
		echo "[4] Ubuntu 18 to 21"
		echo "[5] Ubuntu <= 17"
		echo "[6] CentOS < 9"
		echo "[7] CentOS 9+"
		echo "[q] Quit"
		echo " "
		echo " "
}


print_loc "generate_net_config"	
#this is the echoing function that makes the fake config files and displays them
function generate_net_config()
{
	clear

	generate_net_config_distro_list
		
		
	while read -p "Choose an option (or Q to quit): " opts
	do
	
		
		case "$opts" in
		
		debian|1|5)
			get_eth_info 
			create_debian_network_file "echo"
			exit 1		
		;;
		
		suse)
		    echo "suse not imped yet. tell them to use yast"
		    #get_eth_info
			#suse_style_interface_echo
			exit 1
		;;
		
		4|ubuntu_old|ubuntu)	
			get_eth_info			
			create_ubuntu_network_file 18 "echo"
			exit 1
		;;
		3|ubuntu_new)			
			get_eth_info
			create_ubuntu_network_file 22 "echo"
			
			exit 1
		;;
		
		2|6|centos7|alma|almalinux)
			get_eth_info
			create_red_hat_network_file "rh-old" "echo"
			
			exit 1
		;;
		
		7|centos9)
			get_eth_info
			create_red_hat_network_file "rh-new" "echo"
			exit 1
		;;

		q|Q|quit) 
			echo "exiting..."
			exit 1
			
		;;
		
		*) 
			echo "unknown selection: ${opts}"
			generate_net_config_distro_list
			
		;;
		esac
	
	done

}
#end genrate net config

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


#======================================================================================================================================
#			END	FUNCTIONS			END	FUNCTIONS			END	FUNCTIONS			END	FUNCTIONS			END	FUNCTIONS
#======================================================================================================================================



#88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
#			Main Execution Area			Main Execution Area			Main Execution Area			Main Execution Area
#88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888

print_loc "Main Execution Area"	

#try to turn on numlock - will  not work on all systems
numlockx on

clear
echo "Version 2.2 Build date 1-19-25"

#create_ubuntu_network_file

echo "Be sure to run this in root. If not in root, Ctrl+C now."
echo ""

#echo "option $1"

#clear out the temp network file - ran into problems when i forgot to clear it out and it would double up the generated file
rm tmp_nt &> /dev/null

echo "Log started on: $(date)" > $log_file



		case "$1" in
		
		-fake|-generate)
			
			generate_net_config
			
		;;
		
		-net-restart|-nr|-restart)
		
			deb_interface=$(detect_eth_name)
			try_all_network_restarts
		;;
		
		-loc|-location)
		
			network_file_location_info
		;;
		
		-help|--help)
			clear
			echo "Usage:"
			echo "./config_network.sh"
			echo "./config_network.sh <option>"
			echo ""
			echo "Options:"
			echo ""
			echo "-fake|-generate)"
			echo "This option will echo out how the config file should look for any specific linux distro. This option does not modify files."
			echo ""
			echo "-sshroot)"
			echo "This option will give some basic info about how to enable root login with ssh"
			echo ""
			echo ""
			echo "-net-restart |  -nr | -restart)"
			echo "This will try every known way to restart the internet for all distributions."
			echo ""
			echo "No Options)"
			echo "This is the default runtime to automatically install the network configs."
			echo ""
			echo "-loc | -location)"
			echo "This will show you the locations of the network files for the different linux versions"
			
		;;
		
		-sshroot)
			clear
			echo "file location: /etc/ssh/sshd_config"
			echo ""
			echo "Modify:"
			echo "PermitRootLogin <args>" 
			echo "to:"
			echo "PermitRootLogin yes"
			echo ""
			echo "Then restart ssh <systemctl restart sshd"
			echo ""
			exit 1
		;;

		*) 
			#get the ip address
			get_ip_addr

			main_exec
		;;
		
		esac
	


exit 1






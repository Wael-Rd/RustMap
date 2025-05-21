#!/bin/bash

# Enhanced RustMap Scanner
# Combines RustScan's speed with advanced Nmap scanning
# Author: mrx0rd
# Modified to make vulnerability, exploit, and safe scripts optional

# Colors
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
PURPLE='\033[1;35m'
CYAN='\033[1;36m'
NC='\033[0m'


show_banner() {
    echo -e "${PURPLE}"
    echo "██████╗ ██╗   ██╗███████╗████████╗███╗   ███╗ █████╗ ██████╗ "
    echo "██╔══██╗██║   ██║██╔════╝╚══██╔══╝████╗ ████║██╔══██╗██╔══██╗"
    echo "██████╔╝██║   ██║███████╗   ██║   ██╔████╔██║███████║██████╔╝"
    echo "██╔══██╗██║   ██║╚════██║   ██║   ██║╚██╔╝██║██╔══██║██╔═══╝ "
    echo "██║  ██║╚██████╔╝███████║   ██║   ██║ ╚═╝ ██║██║  ██║██║     "
    echo "╚═╝  ╚═╝ ╚═════╝ ╚══════╝   ╚═╝   ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝     "
    echo -e "${NC}"
    echo -e "${CYAN}   Powerful Port Scanning & Enumeration Tool${NC}"
    echo -e "${YELLOW}   Combining RustScan's speed with Nmap's depth${NC}"
    echo -e "${BLUE}   --------------------------------------------Mrx0rd-${NC}"
}

check_deps() {
    local missing=0
    if ! command -v rustscan &>/dev/null; then
        echo -e "${RED}[✘] RustScan not found${NC}"
        missing=1
    fi
    if ! command -v nmap &>/dev/null; then
        echo -e "${RED}[✘] Nmap not found${NC}"
        missing=1
    fi
    [ $missing -eq 1 ] && exit 1
}

# Progress spinner
spinner() {
    local pid=$1
    local delay=0.15
    local spinstr='|/-\'
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

# Enhanced Nmap scan
run_nmap() {
    local target=$1
    local ports=$2
    local output_file=$3
    local vuln_scan=$4
    local exploit_scan=$5
    local safe_scan=$6
    
    echo -e "\n${YELLOW}[*] Running Enhanced Nmap Scan${NC}"
    
    # Section header
    echo -e "\n=== ENHANCED NMAP RESULTS ===" >> "$output_file"
    
    # Run service detection (always included)
    echo -e "${BLUE}[→] Service detection...${NC}"
    nmap -p "$ports" -sV --version-intensity 9 "$target" >> "$output_file" &
    spinner $!
    
    # Run optional vulnerability scripts
    if [ "$vuln_scan" = true ]; then
        echo -e "${BLUE}[→] Vulnerability scripts...${NC}"
        nmap -p "$ports" --script vuln "$target" >> "$output_file" &
        spinner $!
    fi
    
    # Run optional exploit scripts
    if [ "$exploit_scan" = true ]; then
        echo -e "${BLUE}[→] Exploit scripts...${NC}"
        nmap -p "$ports" --script exploit "$target" >> "$output_file" &
        spinner $!
    fi
    
    # Run optional safe scripts
    if [ "$safe_scan" = true ]; then
        echo -e "${BLUE}[→] Safe scripts...${NC}"
        nmap -p "$ports" --script safe "$target" >> "$output_file" &
        spinner $!
    fi
    
    # Run full port enumeration (always included)
    echo -e "${BLUE}[→] Full port enumeration...${NC}"
    nmap -p "$ports" -A -Pn -sC -T4 "$target" >> "$output_file" &
    spinner $!
    
    echo -e "${GREEN}[✔] Nmap scans completed${NC}"
}

# Main scan function
scan_target() {
    local target=$1
    local output_file="rustmap_${target}.txt"
    local vuln_scan=$2
    local exploit_scan=$3
    local safe_scan=$4
    
    # Clear previous output
    > "$output_file"
    
    # Header
    echo -e "${PURPLE}"
    echo "==============================================" | tee -a "$output_file"
    echo " RustMap Scan Report for $target" | tee -a "$output_file"
    echo " Started: $(date)" | tee -a "$output_file"
    echo "==============================================" | tee -a "$output_file"
    echo -e "${NC}"
    
    # RustScan phase
    echo -e "${YELLOW}[*] Running RustScan (Fast Port Discovery)${NC}"
    echo -e "\n=== RUSTSCAN RESULTS ===" >> "$output_file"
    rustscan -a "$target" --ulimit 5000 --greppable >> "$output_file" &
    spinner $!
    
    # Get open ports
    local ports=$(grep -oP '\d+' "$output_file" | sort -u | tr '\n' ',' | sed 's/,$//')
    
    if [ -z "$ports" ]; then
        echo -e "${RED}[✘] No open ports found${NC}" | tee -a "$output_file"
        return
    fi
    
    echo -e "${GREEN}[✔] Open ports: ${ports}${NC}" | tee -a "$output_file"
    
    # Enhanced Nmap scanning with optional scripts
    run_nmap "$target" "$ports" "$output_file" "$vuln_scan" "$exploit_scan" "$safe_scan"
    
    # Highlight findings
    echo -e "\n${YELLOW}[*] Key Findings Summary:${NC}" | tee -a "$output_file"
    grep -E "open|filtered|vulnerable|exploit|CVE|weak|auth|bypass" "$output_file" | \
        grep -v "Nmap scan report" | sort -u | tee -a "$output_file"
    
    echo -e "\n${GREEN}[✔] Scan completed. Full results saved to ${output_file}${NC}"
}

# Main execution
main() {
    show_banner
    check_deps
    
    # Default flags
    local vuln_scan=false
    local exploit_scan=false
    local safe_scan=false
    
    # Parse options
    while getopts "ves" opt; do
        case $opt in
            v) vuln_scan=true ;;
            e) exploit_scan=true ;;
            s) safe_scan=true ;;
            \?) echo -e "${RED}Invalid option: -$OPTARG${NC}" >&2; exit 1 ;;
        esac
    done
    
    # Shift past the options
    shift $((OPTIND-1))
    
    if [ $# -eq 0 ]; then
        echo -e "${RED}Usage: $0 [-v] [-e] [-s] <target> [target2 ...]${NC}"
        echo -e "${YELLOW}Options:${NC}"
        echo -e "${YELLOW}  -v  Run vulnerability scripts${NC}"
        echo -e "${YELLOW}  -e  Run exploit scripts${NC}"
        echo -e "${YELLOW}  -s  Run safe scripts${NC}"
        echo -e "${YELLOW}Example: $0 -v -s 10.10.10.10${NC}"
        exit 1
    fi
    
    for target in "$@"; do
        echo -e "\n${CYAN}═════ Scanning ${target} ═════${NC}"
        scan_target "$target" "$vuln_scan" "$exploit_scan" "$safe_scan"
    done
    
    echo -e "\n${GREEN}[✔] All scans completed successfully${NC}"
}

main "$@"

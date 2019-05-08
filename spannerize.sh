#!/bin/bash

RED='\033[0;31m'
YELLOW='\033[1;33m'
CYAN='\033[1;36m'
NOCOL='\033[0m' # reset color

echo -e "${CYAN}  _____ ____   ____  ____   ____     ___  ____                  
 / ___/|    \ /    ||    \ |    \   /  _]|    \                 
(   \_ |  o  )  o  ||  _  ||  _  | /  [_ |  D  )                
 \__  ||   _/|     ||  |  ||  |  ||    _]|    /                 
 /  \ ||  |  |  _  ||  |  ||  |  ||   [_ |    \                 
 \    ||  |  |  |  ||  |  ||  |  ||     ||  .  \                
  \___||__|  |__|__||__|__||__|__||_____||__|\_|                
                                                                
 ______    ___  _____ ______  ____    ___    ____  ____   ___   
|      |  /  _]/ ___/|      ||    \  /   \  /    ||    \ |   \  
|      | /  [_(   \_ |      ||  o  )|     ||  o  ||  D  )|    \ 
|_|  |_||    _]\__  ||_|  |_||     ||  O  ||     ||    / |  D  |
  |  |  |   [_ /  \ |  |  |  |  O  ||     ||  _  ||    \ |     |
  |  |  |     |\    |  |  |  |     ||     ||  |  ||  .  \|     |
  |__|  |_____| \___|  |__|  |_____| \___/ |__|__||__|\_||_____|
                                                                ${NOCOL}"

echo -e "\n${CYAN}Welcome to the Spanner Testboard configuration!\n
This script will help you to convert an off-the-shelf Particle device
in a Spanner Testboard, ready to be added in the Spanner CI platform.${NOCOL}\n"

read -n 1 -s -r -p "Press any key to continue"

if [[ "$OSTYPE" != "msys" ]]; then
    echo -e "\n--------> Installing particle cli..."
    bash <( curl -sL https://particle.io/install-cli > /dev/null 2>&1)
    if [ $? -ne 0 ]; then
        echo -e "${RED}particle cli installation failed. Aborting...${NOCOL}"
        exit 1
    fi
    sleep 3

    echo -e "\n${CYAN}All required packages installed successfully!${NOCOL}"
    sleep 3
else
    echo -e "\n{YELLOW}Windows OS detected, please make sure to install the
    particle cli first. The installer can be found here:${NOCOL}
    https://binaries.particle.io/cli/installer/windows/ParticleCLISetup.exe\n"

    read -n 1 -s -r -p "If the particle cli is installed, press any key to continue"
fi

echo -e "\n\n${YELLOW}PLEASE PUT THE DEVICE IN DFU MODE${NOCOL}
To enter DFU Mode:
1. Hold down BOTH buttons
2. Release only the RESET button, while holding down the SETUP button
3. Wait for the LED to start flashing yellow (it will flash magenta first)
4. Release the SETUP button\n"

read -p "If the device is in DFU mode, press ENTER to continue"

echo -e "\n--------> Flashing core Testboard firmware..."
particle flash --usb firmware/hybrid-0.9.0-argon.bin
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed to flash core firmware! Aborting...${NOCOL}"
    exit 1
fi
sleep 3

echo -e "\n--------> Flashing Testboard firmware app..."
particle flash --usb firmware/spanner_firmware.bin
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed to flash app firmware! Aborting...${NOCOL}"
    exit 1
fi
sleep 3

# Linux ModemManager thinks any new ttyACM device is a modem - also known as
# the ttyACM0 drama!
if [[ "$OSTYPE" == "linux-gnu" ]]; then
    sudo systemctl stop ModemManager.service
fi

echo -e "\n--------> Setting Wi-Fi Credentials"
particle serial wifi
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed to set wifi creds! Aborting...${NOCOL}"
    exit 1
fi
sleep 3

echo -e "\n"
read -p "Please put the device in listening mode and then press ENTER to continue"
echo -e "\n--------> Getting Device ID..."
sleep 3
particle identify
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed to get device id! Aborting...${NOCOL}"
    exit 1
fi
sleep 3

if [[ "$OSTYPE" == "linux-gnu" ]]; then
    sudo systemctl start ModemManager.service
fi

echo -e "\n${CYAN}
Great Job, your new Spanner Testboard is ready! 
Now you can add it as a new Testboard in the Spanner CI platform by using
the above device id.${NOCOL}"

echo -e "${YELLOW}
Note: if the device is flashing blue, press the MODE button for ~8 seconds.
As soon as you release it, it will start flashing green and the device will 
try to connect to the network. A steady cyan color means that the device is 
connected and ready to be used.${NOCOL}\n"

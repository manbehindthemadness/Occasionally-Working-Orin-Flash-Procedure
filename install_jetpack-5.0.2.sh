#!/bin/bash
# https://docs.nvidia.com/sdk-manager/sdkm-command-line-install/index.html#command-line-install
# https://docs.nvidia.com/jetson/archives/r34.1/DeveloperGuide/text/SO/JetsonAgxOrin.html
# https://leimao.github.io/blog/NVIDIA-SDK-Manager-Docker/

# IMPORTANT IF WE CANNOT GET INTO RECOVERY MODE: sudo reboot forced-recovery


############################################################################
######## THIS SCRIPT CANNOT RUN ON WINDOWS AS THERE IS NO USB ##############
########## ELEVATION FROM COMMAND LINE (THAT I AM AWARE OF) ################
############################################################################
######## ENSURE YOU HAVE SETUP A USERNAME AND PASSWORD ON THE ORIN #########
################ YOU WILL BE PROMPTED FOR IT DURING SETUP ##################
############################################################################
############### DOWNLOAD DOCKER IMAGE HERE: USE 18.04 ######################
############ https://developer.nvidia.com/drive/sdk-manager ################
############################################################################
############## USE THESE TO LOAD THE DOWNLOADED IMAGE ######################
## NOTE: 20.04 sdkmanager 1.9.3.10904 docker image is broken and will fail #
## sudo docker load -i ./sdkmanager-1.9.3.10904-Ubuntu_18.04_docker.tar.gz #
## sudo docker tag sdkmanager-1.9.3.10904-Ubuntu_18.04_docker.tar.gz #######
## NOTE: The sdkmanager must be at the latest version as updating fails ####
############################################################################

read -p "Welcome to the single most terrible, mind-crushing, nightmarish, and horrible flashing utility ever designed. Lets get started..."

echo listing possible commands:
sudo docker run -it --privileged -v /dev/bus/usb:/dev/bus/usb/ -v /dev:/dev -v /media/$USER:/media/nvidia:slave --rm sdkmanager:1.9.3.10904-Ubuntu_18.04 --query

echo detecting connected devices...
sudo docker run -it --privileged -v /dev/bus/usb:/dev/bus/usb/ -v /dev:/dev -v /media/$USER:/media/nvidia:slave --rm sdkmanager:1.9.3.10904-Ubuntu_18.04 --listconnected all

read -p "If no devices are connected abort the script, ensure the host is connected via the usb-c port next to the 40 pin header, then restart the unit while pressing the recovery (middle) button"

read -p "Power off device using holding the power (left) button for 15 seconds and remove the usb-c cable from next to the 40 pin header, do not reconnect until prompted by the installer"

read -p "When presented with the install options choose: manual install (do not select the 32gb option)"

read -p "Ensure USB power management is disabled on the host"

read -p "A wired ethernet connection will be required for the post-image, pre-sdk install"

read -p "Optional: skip the install of the nvidia sdk components, perform an apt-get update then a reboot followed by apt-get install nvidia-jetpack"

############################################################################
########################## INSTALL FULL SYSTEM #############################
############################################################################
sudo docker run -it --privileged -v /dev/bus/usb:/dev/bus/usb/ -v /dev:/dev -v /media/$USER:/media/nvidia:slave sdkmanager:1.9.3.10904-Ubuntu_18.04 --cli install --logintype devzone --product Jetson --version 5.1.1 --targetos Linux --host --target JETSON_AGX_ORIN_TARGETS --flash all --license accept --checkforupdates force --additionalsdk 'DeepStream 6.2'

echo At this point you have probably experienced a weird failure: FEAR NOT! The nvidia sdkmanager is completely unstable, so just re-run this script! There is an 80% probability you will achieve different results!

echo .
echo .
echo .

echo Disclaimer: There is also an 80% probability that the new result will be another form of failure.

## If attempting to boot from SSD see the following: https://forums.developer.nvidia.com/t/how-to-add-nvme-as-boot-option-in-uefi/230593
## Installing to nvme via sdkmanager doesn't work (go figure), instead just DD the partition: dd bs=4M if=/dev/mmcblk0 of=/dev/nvme0n1 status=progress
## Do ensure to edit the /boot/extlinux/extlinux.conf file and change /dev/mmcblk0p1 to /dev/nvme0n1p1

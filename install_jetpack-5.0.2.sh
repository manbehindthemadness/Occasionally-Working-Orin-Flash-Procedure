#!/bin/bash
# https://docs.nvidia.com/sdk-manager/sdkm-command-line-install/index.html#command-line-install

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
## sudo docker load -i ./sdkmanager-1.9.1.10844-Ubuntu_18.04_docker.tar.gz #
## sudo docker tag sdkmanager:1.9.1.10844-Ubuntu_18.04 sdkmanager:latest ###
############################################################################

echo listing possible commands:
sudo docker run -it --privileged -v /dev/bus/usb:/dev/bus/usb/ -v /dev:/dev -v /media/$USER:/media/nvidia:slave--rm sdkmanager --query

echo detecting connected devices...
sudo docker run -it --privileged -v /dev/bus/usb:/dev/bus/usb/ -v /dev:/dev -v /media/$USER:/media/nvidia:slave --rm sdkmanager --listconnected all

read -p "If no devices are connected abort the script, ensure the host is connected via the usb-c port next to the 40 pin header, then restart the unit while pressing the recovery (middle) button"

read -p "Power off device using holding the power (left) button for 15 seconds and remove the usb-c cable from next to the 40 pin header, do not reconnect until prompted by the installer"

read -p "When presented with the install options choose: manual install (do not select the 32gb option)"

read -p "Ensure USB power management is disabled on the host"

read -p "A wired ethernet connection will be required for the post-image, pre-sdk install"

############################################################################
########################## INSTALL FULL SYSTEM #############################
############################################################################
# sudo docker run -it --privileged -v /dev/bus/usb:/dev/bus/usb/ -v /dev:/dev -v /media/$USER:/media/nvidia:slave --rm sdkmanager --cli install --logintype devzone --staylogin true --product Jetson --version 5.0.2 --targetos Linux --host --target JETSON_AGX_ORIN_TARGETS --flash all --additionalsdk 'DeepStream 6.1.1' --exportlogs /var/log --license accept
#!/bin/bash
# https://docs.nvidia.com/sdk-manager/sdkm-command-line-install/index.html#command-line-install

############################################################################
######## THIS SCRIPT CANNOT RUN ON WINDOWS AS THERE IS NO USB ##############
########## ELEVATION FROM COMMAND LINE (THAT I AM AWARE OF) ################
############################################################################
######## ENSURE YOU HAVE SETUP A USERNAME AND PASSWORD ON THE ORIN #########
################ YOU WILL BE PROMPTED FOR IT DURING SETUP ##################
############################################################################
############### DOWNLOAD DOCKER IMAGE HERE: USE 20.04 ######################
############ https://developer.nvidia.com/drive/sdk-manager ################
############################################################################
############## USE THESE TO LOAD THE DOWNLOADED IMAGE ######################
## sudo docker load -i ./sdkmanager-1.9.1.10844-Ubuntu_20.04_docker.tar.gz #
## sudo docker tag sdkmanager:1.9.1.10844-Ubuntu_20.04 sdkmanager:latest ###
############################################################################

read -p "Welcome to the single most terrible, mind-crushing, nightmarish, and horrible flashing utility ever designed. Lets get started..."

echo listing possible commands:
sudo docker run -it --privileged -v /dev/bus/usb:/dev/bus/usb/ -v /dev:/dev -v /media/$USER:/media/nvidia:slave--rm sdkmanager --query

echo detecting connected devices...
sudo docker run -it --privileged -v /dev/bus/usb:/dev/bus/usb/ -v /dev:/dev -v /media/$USER:/media/nvidia:slave --rm sdkmanager --listconnected all

read -p "If no devices are connected abort the script, ensure the host is connected via the usb-c port next to the 40 pin header, then restart the unit while pressing the recovery (middle) button"

read -p "Power off device using holding the power (left) button for 15 seconds and remove the usb-c cable from next to the 40 pin header, do not reconnect until prompted by the installer"

read -p "When presented with the install options choose: manual install (do not select the 32gb option)"

read -p "Ensure USB power management is disabled on the host"

read -p "A wired ethernet connection will be required for the post-image, pre-sdk install"

read -p "Actually scratch that, skip the install of the nvidia sdk components, perform an apt-get update then a reboot followed by apt-get install nvidia-jetpack"

############################################################################
########################## INSTALL FULL SYSTEM #############################
############################################################################
sudo docker run -it --privileged -v /dev/bus/usb:/dev/bus/usb/ -v /dev:/dev -v /media/$USER:/media/nvidia:slave --rm sdkmanager --cli install --logintype devzone --product Jetson --version Runtime_5.0.2 --targetos Linux --host --target JETSON_AGX_ORIN_TARGETS --flash all --license accept --checkforupdates force

echo At this point you have probably experienced a weird failure: FEAR NOT! The nvidia sdkmanager is completely unstable, so just re-run this script! There is an 80% probability you will achieve different results!

echo .
echo .
echo .

echo Disclaimer: There is also an 80% probability that the new result will be another form of failure.

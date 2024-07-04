Since this was created the Nvidia SDK Manager has been revised into a generally working state (thank Christ); however, do yourself a favor and ensure that IPV6 is 
enabled on the interface level and is **not disabled in the grub cmdline**.

Also, I find it best to install the SDK components portion of the flash over a real network connection as the USB virtual ethernet usually fails after the partitions are created and the device reboots.

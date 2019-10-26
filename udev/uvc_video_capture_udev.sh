#!/bin/bash

# to find information of a camera:
# $ ls /dev/camera <tab> <tab>
# $ udevadm info -a -p $(udevadm info -q path -n /dev/camera1)

# notice: the first line uses ">" such that the file bito_ib.rules will be covered
echo  'SUBSYSTEMS=="usb", KERNEL=="video[0-99]*", ACTION=="add", ATTRS{idVendor}=="18ec", ATTRS{idProduct}=="5555", ATTRS{product}=="USB2.0 PC CAMERA", MODE="666", SYMLINK+="uvc/videoCapture", GROUP="dialout"' >/etc/udev/rules.d/uvc_video_capture.rules

service udev reload
sleep 1
service udev restart

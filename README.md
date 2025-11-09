# nnp  
Dockerized NUT, with prometheus exporter

The main goal is creating a container to collect a data from a UPS via NUT. After a small align these datas avaliable for prometheus scraping.

>[TLDR-NUT]

NUT has few base component. 

1, upsdrvctrl - Loading the propriate driver based on ups.conf which located at /etc/nut/ups.conf 

Need to figure out what is the correct driver for your UPS, and have to modify it on the following way. Example:

[effekta]
driver = nutdrv_qx
port = auto
vendorid = 0665
productid = 5161
override.battery.packs = 1
pollinterval = 30
pollfreq = 15
synchronous = yes
default.battery.voltage.high = 13.2
default.battery.voltage.low = 10.7
runtimecal = 500,100,1300,50

2, upsd - UpsDaemon - Configured via /etc/nut/upsd.conf 

Only important: LISTEN 0.0.0.0 3493

3, upscmd - command line utility. (Not in use by this container). (upscmd -l effekta shows the avaliable commands) 
4, upsmon - Monitors UPS servers and may initiate shutdown if necessary. (Not in use by this container)
5, upslog - UPS status logger. (Not in use by this container)
6, upsrw - Demo program to set variables within UPS hardware. (Not in use by this container)
7, upsc - Displays the UPS variables - We use this command to parse the the data from the UPS.

test command: upsc effekta@localhost:3493

>[TLDR-Nginx-Php]

nginx, and php8-fpm has been installed to the container, and all the required configuration files has been transferred to the image during the build. 
(www.conf;nginx.conf,default.conf,index.php)

Nginx port: 9199

>[TLDR-Bash]

start.sh - Responsible for the start sequence. (Nginx,Php,upsdrvctrl,upsd)
status.sh - Simple bash, which watching the SIGTERM, and provides some feedback to the container log at every 10 minutes.

>[Build a container]

docker build . -t your_image_name

>[Run a Container]

docker run -d\
 --restart unless-stopped\
 --stop-timeout 15\
 -e UPS='effekta'
 -p 3493:3493\
 -p 9199:9199\
 --device /dev/bus/usb/003/002\
 -name nut\
 your_image_name

>[Checking if it's work]

For example if your UPS name defined as "effekta" you can collect a metric with prometheus via the following url:

http://localhost:9199/index.php?ups=effekta

>[FYI]

Check where is your device is sitting: (0665:5161) and modify the --device parameter

Alternatively you can use --privileged option instead of a --device. (Insecure way)
lsusb

Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub<br>
Bus 005 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub<br>
Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub<br>
Bus 003 Device 002: ID 0665:5161 Cypress Semiconductor USB to Serial<br>
Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub<br>
Bus 002 Device 002: ID 0627:0001 Adomax Technology Co., Ltd QEMU USB Tablet<br>
Bus 002 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub<br>

You can pass your own config files with your ones:

docker run -d\
 --restart unless-stopped\
 --stop-timeout 15\
 
 -e UPS='effekta'
 -p 3493:3493\
 -p 9199:9199\
 --ulimit nofile=8192:8192 \
 --device /dev/bus/usb/003/002\
 -v /your_nut_config:/etc/nut\
 -name nut\
 nnp_090822_2040

![Grafana](https://raw.githubusercontent.com/zolbarna/nnp/main/grafana.JPG)

As it turned out the UPS device liable to roaming between the USB ports after a restart. 

To fix it: 

lsusb --> Find your device port\
udevadm info -a -n /dev/bus/usb/002/002 --> check device idVendor;idProduct, 

Create a file: 

vim /etc/udev/rules.d/99-usb-rules.rules\
SUBSYSTEM=="usb", ATTRS{idVendor}=="0665", ATTRS{idProduct}=="5161", SYMLINK+="ups_device"

chmod 644 /etc/udev/rules.d/99-usb-rules.rules\
udevadm trigger --attr-match=subsystem=usb\
ls -l /dev/ups_device

after a restart /dev/ups_device should be persistent<br>
docker run -d --restart unless-stopped --stop-timeout 15 -e UPS='effekta' -p 3493:3493 -p 9199:9199 --device $(readlink -f /dev/mcc_daq) --name nnp nnp_031122_1836



# nnp  
Dockerized NUT, with prometheus exporter

The main idea is creating a container which can collect a monitoring data from a UPS via NUT, and also provides a timeseries data for prometheus. The data conversion is happening on-the-fly with a NGINX+PHP which directly calling the UPSC with a NAME of your UPS defined in the nut.conf.  

For example if your UPS name defined as "effekta" you can collect a metric with prometheus via the following url:

http://localhost:9199/index.php?ups=effekta

#Build a Container: 

docker build . -t nnp_090822_2040

#Run a Container:

Settings:

NGINX listen on 9199
UPSD listen on 3493
UPS variable is your defined name in your ups.conf which located in /media/Config/Nnp
Check where is your device is sitting: (0665:5161) so we have to pass this device to the container.
Alternatively you can use --privileged option instead of a --device. (Insecure way)
>lsusb

Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub<br>
Bus 005 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub<br>
Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub<br>
Bus 003 Device 002: ID 0665:5161 Cypress Semiconductor USB to Serial<br>
Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub<br>
Bus 002 Device 002: ID 0627:0001 Adomax Technology Co., Ltd QEMU USB Tablet<br>
Bus 002 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub<br>

Nut config files located externaly. In my example it's located at /media/Config/Nnp
- nut.conf
- ups.conf
- upsd.conf
- upsd.users
- upsmon.conf
- upssched.conf

#Example:

docker run -d\
 --restart unless-stopped\
 --stop-timeout 15\
 -e UPS='effekta'
 -p 3493:3493\
 -p 9199:9199\
 --device /dev/bus/usb/003/002\
 -v /media/Config/Nnp:/etc/nut\
 -name nut\
 nnp_090822_2040

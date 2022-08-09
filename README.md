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
Privileged mode neccesseray for the USB port (USB mapping also possible)

nut.conf;ups.conf;upsd.conf;upsd.users;upsmon.conf;upssched.conf; >> Nut config files located externaly 

docker run -d\
 --restart unless-stopped\
 --stop-timeout 15\
 -e UPS='effekta'
 -p 3493:3493\
 -p 9199:9199\
 --privileged\
 -v /media/Config/Nnp:/etc/nut\
 -name nut\
 nnp_090822_2040

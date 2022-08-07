# nnp
Dockerized NUT, with prometheus exporter

docker run -d\
 --restart unless-stopped\
 --stop-timeout 15\
 -p 3493:3493\
 -p 9199:9199\
 --privileged\
 -v /media/Config/Nnp/nut:/etc/nut\
 -v /media/Config/Nnp/www:/usr/share/nginx/www\
 nnp_2700722_1040

Required files for /etc/nut: 

nut.conf >> STANDALONE
ups.conf 
upsd.conf
upsd.users
upsmon.conf
upssched.conf

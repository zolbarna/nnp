FROM alpine:3.16.0

MAINTAINER Stone
ARG BUILD_DATE


RUN apk update
RUN apk add nut
RUN apk add nginx
RUN apk add php8-fpm
RUN apk add gcc libc-dev libusb-dev linux-headers

COPY usbreset-master/usbreset.c .

RUN cc usbreset.c -o usbreset
RUN chmod +x usbreset

RUN apk del gcc libc-dev libusb-dev linux-headers

RUN chgrp nut /etc/nut/*
RUN chmod 640 /etc/nut/*
RUN mkdir -p /var/run/nut && \
    chown nut:nut /var/run/nut && \
    chmod 700 /var/run/nut

COPY conf/start.sh /start.sh
COPY conf/status.sh /status.sh

COPY conf/nut/* /etc/nut/
COPY conf/www.conf /etc/php8/php-fpm.d/www.conf
COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY conf/default.conf /etc/nginx/http.d/default.conf
COPY conf/index.php /usr/share/nginx/www/index.php

RUN chmod 700 /start.sh
RUN chmod 700 /status.sh
RUN chmod 644 /usr/share/nginx/www/index.php
CMD ["/start.sh"]

ENTRYPOINT [""]

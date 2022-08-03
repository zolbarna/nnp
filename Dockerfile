FROM alpine:3.16.0

MAINTAINER Stone
ARG BUILD_DATE


RUN apk update
RUN apk add nut
RUN apk add nginx
RUN apk add php8-fpm

RUN chgrp nut /etc/nut/*
RUN chmod 640 /etc/nut/*
RUN mkdir -p /var/run/nut && \
    chown nut:nut /var/run/nut && \
    chmod 700 /var/run/nut

COPY conf/start.sh /start.sh
COPY conf/status.sh /status.sh
COPY conf/default.cnf /etc/nginx/http.d/default.conf
RUN chmod 700 /start.sh
RUN chmod 700 /status.sh

CMD ["/start.sh"]

ENTRYPOINT [""]

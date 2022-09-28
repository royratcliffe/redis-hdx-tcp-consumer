FROM royratcliffe/swi-prolog-httpd-srv:alpine

COPY .config /root/.config

WORKDIR /srv
COPY srv .

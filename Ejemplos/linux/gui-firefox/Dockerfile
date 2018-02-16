FROM alpine:latest

ENV URL https://www.google.com

RUN apk --no-cache --update add firefox-esr dbus-x11 ttf-ubuntu-font-family \
    && adduser -S miuser \
    && echo "miuser:miuser" | chpasswd

USER miuser

CMD firefox --new-instance ${URL}
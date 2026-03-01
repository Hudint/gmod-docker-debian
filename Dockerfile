FROM debian:trixie-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=en_US.UTF-8


RUN dpkg --add-architecture i386
RUN apt-get update &&  \
        apt-get install -y --no-install-recommends --no-install-suggests \
        lib32stdc++6=14.2.0-19 \
        lib32gcc-s1=14.2.0-19 \
        ca-certificates=20250419 \
        nano=8.4-1 \
        curl=8.14.1-2+deb13u2 \
        locales=2.41-12+deb13u1
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen 
RUN dpkg-reconfigure --frontend=noninteractive locales

WORKDIR /steamcmd
RUN curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf -
RUN chmod -R 777 /steamcmd
ENV DIR_STEAMCMD=/steamcmd


WORKDIR /steamapps
ENV DIR_GMOD=/steamapps/gmod

ENV GMODID=4020 \
    CSSID=232330 \
    DIR_CSS=/steamapps/css \
    TF2ID=232250 \
    DIR_TF2=/steamapps/tf2 \
    SERVERCFG=/steamapps/gmod/garrysmod/cfg/server.cfg \
    MOUNTCFG=/steamapps/gmod/garrysmod/cfg/mount.cfg \
    MOUNT_TF2=1 \
    MOUNT_CSS=1


COPY ./include/ /include/
RUN chmod -R 777 /include
CMD ["/include/entry.sh"]
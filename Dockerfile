FROM ubuntu:resolute

RUN dpkg --add-architecture i386
RUN apt-get update && apt-get install -y \
    curl \
    lib32gcc-s1 \
    lib32stdc++6 \
    lib32tinfo6  

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
    MOUNTCFG=/steamapps/gmod/garrysmod/cfg/mount.cfg 


COPY ./include/ /include/
RUN chmod -R 777 /include
ENTRYPOINT ["/include/entry.sh"]
# FROM ubuntu:18.04

# RUN dpkg --add-architecture i386 && \
#     apt-get update && \
#     DEBIAN_FRONTEND=noninteractive apt-get install -y wine-development && \
#     apt-get clean  && \
#     rm -rf /var/lib/apt/lists/*

# ENV WINEARCH=win64 \
#     WINEDEBUG=-all

FROM scottyhardy/docker-wine

ENV DISPLAY=":0 winecfg"

# RUN wineboot --init

WORKDIR /app

COPY accds.tar.gz .

RUN tar -zxf accds.tar.gz && \
    rm accds.tar.gz

# WORKDIR /app/accds

# RUN rm -rf accds

COPY ./cfg /app/accds/server/cfg

RUN chmod -R 777 ./

WORKDIR /app/accds/server

WORKDIR /app

COPY accds.sh .

RUN chmod +x accds.sh

WORKDIR /app/accds/server

EXPOSE 8766 8766/udp 9231 9231/udp 9232 9232/tcp

# CMD "./accds.sh"
CMD ["wine", "accServer.exe"]

FROM ubuntu:20.10

# Install prerequisites
RUN apt-get update \
    && DEBIAN_FRONTEND="noninteractive" apt-get install -y --no-install-recommends \
        apt-transport-https \
        ca-certificates \
        cabextract \
        git \
        gosu \
        gpg-agent \
        p7zip \
        pulseaudio \
        pulseaudio-utils \
        software-properties-common \
        tzdata \
        unzip \
        wget \
        zenity \
    && rm -rf /var/lib/apt/lists/*

# Install wine
ARG WINE_BRANCH="stable"
RUN wget -nv -O- https://dl.winehq.org/wine-builds/winehq.key | APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1 apt-key add - \
    && apt-add-repository "deb https://dl.winehq.org/wine-builds/ubuntu/ $(grep VERSION_CODENAME= /etc/os-release | cut -d= -f2) main" \
    && dpkg --add-architecture i386 \
    && apt-get update \
    && DEBIAN_FRONTEND="noninteractive" apt-get install -y --install-recommends winehq-${WINE_BRANCH} \
    && rm -rf /var/lib/apt/lists/*

# Install winetricks
RUN wget -nv -O /usr/bin/winetricks https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks \
    && chmod +x /usr/bin/winetricks

# FROM scottyhardy/docker-wine

# ENV DISPLAY=":0 winecfg"

# RUN wineboot --init

WORKDIR /app

COPY accds.10022021.tar.gz .

RUN tar -zxf accds.10022021.tar.gz && \
    rm accds.10022021.tar.gz

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

FROM ubuntu:18.04

ARG servercfg="server1"

# RUN dpkg --add-architecture i386 && \
#     apt-get update && \
#     DEBIAN_FRONTEND=noninteractive apt-get install -y wine-development && \
#     apt-get clean  && \
#     rm -rf /var/lib/apt/lists/*

# ENV WINEARCH=win64 \
#     WINEDEBUG=-all

# RUN wineboot --init

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
RUN apt -y update \
    && apt -y install gettext-base wine64-development wine-development libwine-development libwine-development-dev \
    && dpkg --add-architecture i386

# ARG WINE_BRANCH="stable"
# RUN wget -nv -O- https://dl.winehq.org/wine-builds/winehq.key | APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1 apt-key add - \
#     && apt-add-repository "deb https://dl.winehq.org/wine-builds/ubuntu/ $(grep VERSION_CODENAME= /etc/os-release | cut -d= -f2) main" \
#     && dpkg --add-architecture i386 \
#     && apt-get update \
#     && DEBIAN_FRONTEND="noninteractive" apt-get install -y --install-recommends winehq-${WINE_BRANCH} \
#     && rm -rf /var/lib/apt/lists/*

# Install winetricks
# RUN wget -nv -O /usr/bin/winetricks https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks \
#     && chmod +x /usr/bin/winetricks

# RUN dpkg --add-architecture i386 && \
#     apt-get update && \
#     DEBIAN_FRONTEND=noninteractive apt-get install -y wine-development && \
#     apt-get clean  && \
#     rm -rf /var/lib/apt/lists/*

ENV DISPLAY=":0 winecfg"
ENV WINEARCH=win64
# ENV WINEARCH=win64 \
#     WINEDEBUG=-all

# RUN wineboot --init

# VOLUME /app

WORKDIR /app/accds

COPY accServer.exe .

# RUN tar -zxf accds.1.7.4.tar.gz && \
#     rm accds.1.7.4.tar.gz

COPY ./cfg-${servercfg} /app/accds/server/cfg

RUN chmod -R 777 ./

COPY accds.sh .

RUN chmod +x accds.sh

# WORKDIR /app/accds/server

# EXPOSE 8766 10000 10000/udp 10000/tcp

# CMD "./accds.sh"
CMD ["wine", "accServer.exe"]

FROM debian:latest

# Non Interactive MODE
ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true

# Locale settings
COPY sources.list /etc/apt/sources.list
RUN apt-get update && apt-get install -y locales localepurge
COPY locale.nopurge /etc/locale.nopurge
RUN LANG=es_ES.UTF-8 >/etc/default/locale
RUN sed -i -e 's/# es_ES.UTF-8 UTF-8/es_ES.UTF-8 UTF-8/' /etc/locale.gen && locale-gen
RUN update-locale LANG=es_ES.UTF-8
ENV LANG=es_ES.UTF-8 \
    LANGUAGE=es_ES.UTF-8 \
    LC_ALL=es_ES.UTF-8

# Upgrade base packages
RUN apt-get upgrade -y

# Install new packages
RUN apt-get install -y apt-utils sudo neofetch man wget curl bsdmainutils \
                                 nano vim w3m traceroute whois zip rar unrar p7zip-full \
                                 htop procps pciutils hwinfo openssh-server tmux sl cowsay
ENV PATH=$PATH:/usr/games

# Clean and erase apt cache
RUN apt-get clean -y && \
    apt-get autoclean -y && \
    apt-get autoremove -y && \
    rm -rf /var/lib/{apt,dpkg,cache,log}/

# Datetime settings
ENV TZ=Europe/London
RUN echo $TZ > /etc/timezone
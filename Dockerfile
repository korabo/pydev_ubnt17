# pydev_ubnt17

FROM ubuntu:17.04
LABEL MAINTAINER="S.TAKEUCHI(KRB/SPG)" version="1.0" updated="191017" containerid="ubuntu-vsc-scaru"

# ENV             container docker
# RUN             PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin

ENV _ENVDEF_ pydev-ubnt17

RUN set -xeu && \
  # amend package source URL to old-releases
  sed -i -e 's/archive.ubuntu.com\|security.ubuntu.com/old-releases.ubuntu.com/g' /etc/apt/sources.list

# Basic package
RUN set -xeu && \
  # remove package cache & upgrade
  rm -rf /var/lib/apt/lists/* && \
  apt-get -y update && \
  apt-get -y autoremove && \
  apt-get -y dist-upgrade && \
  # Install standard packages
  DEBIAN_FRONTEND=noninteractive apt-get -y install ubuntu-standard && \
  apt-get -y install unattended-upgrades

# Install required
RUN set -xeu && \
  # remove package cache & update
  rm -rf /var/lib/apt/lists/* && \
  apt-get -y update && \
  apt-get -y autoremove && \
  /usr/bin/unattended-upgrade && \
  # install
  DEBIAN_FRONTEND=noninteractive apt-get -y install \
    sudo \
    nfs-common \
    mysql-client \
    python3-pip \
    libmysqlclient-dev \
    autoconf automake libtool \
    autoconf-archive \
    pkg-config \
    libjpeg8-dev \
    libtiff5-dev \
    unzip \
    sshguard ethtool \
    mecab libmecab-dev mecab-ipadic mecab-ipadic-utf8

# Install alt
RUN set -xeu && \
  # remove package cache & update
  rm -rf /var/lib/apt/lists/* && \
  apt-get -y update && \
  apt-get -y autoremove && \
  /usr/bin/unattended-upgrade && \
  # install
  DEBIAN_FRONTEND=noninteractive apt-get -y install \
    acl \
    apport \
    apport-symptoms \
    at \
    bcache-tools \
    cryptsetup \
    cryptsetup-bin \
    curl \
    debconf-i18n \
    dirmngr \
    dmeventd \
    dns-root-data \
    dnsmasq-base \
    eatmydata \
    ebtables \
    gawk \
    git \
    git-man \
    gnupg-l10n \
    iputils-ping \
    isc-dhcp-common \
    less \
    net-tools \
    netcat-openbsd \
    ntp \
    os-prober \
    software-properties-common \
    tzdata \
    udev \
    uidmap \
    xxd \
    language-pack-ja
    
# Install alt2
RUN set -xeu && \
  # remove package cache & update
  rm -rf /var/lib/apt/lists/* && \
  apt-get -y update && \
  apt-get -y autoremove && \
  /usr/bin/unattended-upgrade && \
  # install
  DEBIAN_FRONTEND=noninteractive apt-get -y install \
    python3-apport \
    python3-debian \
    python3-newt \
    python3-prettytable \
    python3-problem-report \
    python3-software-properties \
    python3-systemd \
    python3-wheel \
    python3.5 \
    python3-venv
#    resolvconf \

# Install alt3
RUN set -xeu && \
  # remove package cache & update
  rm -rf /var/lib/apt/lists/* && \
  apt-get update -q && \
  apt-get -y autoremove && \
  /usr/bin/unattended-upgrade && \
  # install
  # DEBIAN_FRONTEND=noninteractive apt-get install -y keyboard-configuration && \
  DEBIAN_FRONTEND=noninteractive apt-get install -q -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" \
    vim \
    vim-common \
    vim-runtime \
    vim-tiny

# language
RUN set -xeu && \
    locale-gen en_US && \
    locale-gen en_US.UTF-8 && \
    locale-gen ja_JP && \
    locale-gen ja_JP.UTF-8 && \
    update-locale LANG=en_US.UTF-8

# slim image
RUN set -xeu && \
  # update and remove package cach
  apt-get -y update && \
  /usr/bin/unattended-upgrade && \
  rm -rf /var/lib/apt/lists/*

# Install pylint
RUN set -xeu && \
#  pip3 install --upgrade --system pip3 && \
  pip3 --no-cache-dir install --upgrade setuptools && \
  pip3 --no-cache-dir install --system pylint


RUN set -xeu && \
  mkdir -p /opt/etc && \
  pip3 freeze | tee -a /opt/etc/pip3_freeze.txt

ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8

ENTRYPOINT ["/bin/bash",  "-c", "[ -t 1 ] && bash || sleep infinity"]

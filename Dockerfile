# pydev_ubnt17

FROM ubuntu:17.04
LABEL MAINTAINER="S.TAKEUCHI(KRB/SPG)" version="1.0" updated="191017" containerid="ubuntu-vsc-scaru"

# ENV             container docker
# RUN             PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin

ENV _ENVDEF_ pydev-ubnt17-scaru

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
  apt-get -y install ubuntu-standard && \
  apt-get -y install unattended-upgrades

# Install required
RUN set -xeu && \
  # remove package cache & update
  rm -rf /var/lib/apt/lists/* && \
  apt-get -y update && \
  apt-get -y autoremove && \
  /usr/bin/unattended-upgrade && \
  # install
  apt-get -y install \
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
  apt-get -y install \
    curl

# Google
RUN set -xeu && \
  # install
  # export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)" && \
  # echo "deb https://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
  # zesty version is deleted: https://launchpad.net/ubuntu/+source/google-cloud-sdk/176.0.0-0ubuntu1~17.04.0
  # sdk is supported after wheezy debian: https://cloud.google.com/sdk/docs/quickstart-debian-ubuntu?hl=ja
  echo "deb https://packages.cloud.google.com/apt cloud-sdk-wheezy main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
  echo "deb http://packages.cloud.google.com/apt google-cloud-logging-wheezy main" | tee -a /etc/apt/sources.list.d/google-cloud-logging-wheezy.list && \
  curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
  echo "deb http://archive.canonical.com/ubuntu zesty partner" |   tee -a /etc/apt/sources.list.d/partner.list && \
  # remove package cache & update
  rm -rf /var/lib/apt/lists/* && \
  apt-get -y update && \
  apt-get -y autoremove && \
  /usr/bin/unattended-upgrade && \
  apt-get -y --no-install-recommends install \
    google-cloud-sdk \
    # google-fluentd google-fluentd-catch-all-config \
    cloud-init \
    gce-compute-image-packages python-google-compute-engine && \
  # install others
  apt-get -y install \
    less

# slim image
RUN set -xeu && \
  # update and remove package cach
  apt-get -y update && \
  /usr/bin/unattended-upgrade && \
  rm -rf /var/lib/apt/lists/*

# Install pylint
RUN set -xeu && \
#  pip3 install --upgrade --system pip3 && \
  pip3 install --system \
    pylint pip

RUN set -xeu && \
  mkdir -p /opt/etc && \
  pip3 freeze | tee -a /opt/etc/pip3_freeze.txt

ENTRYPOINT ["/bin/bash",  "-c", "[ -t 1 ] && bash || sleep infinity"]

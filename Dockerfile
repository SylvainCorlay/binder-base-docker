# Base image of the IPython/Jupyter notebook, with conda
# Intended to be used in a tmpnb installation
# Customized from https://github.com/jupyter/docker-demo-images/tree/master/common 
FROM ubuntu:16.04

MAINTAINER Sylvain Corlay <sylvain.corlay@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -y &&\
    apt-get install --fix-missing -y curl git vim wget build-essential python-dev bzip2 libsm6\
      locales nodejs-legacy npm python-virtualenv python-pip gcc gfortran libglib2.0-0 python-qt4 libstdc++6 &&\
    apt-get clean &&\
    apt-get dist-upgrade -y &&\
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*tmp

RUN strings /usr/lib/x86_64-linux-gnu/libstdc++.so.6 | grep GLIBC

# set utf8 locale:
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && locale-gen
ENV LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8

# We run our docker images with a non-root user as a security precaution.
# main is our user
RUN useradd -m -s /bin/bash main

EXPOSE 8888

USER main
ENV HOME /home/main
ENV SHELL /bin/bash
ENV USER main
WORKDIR $HOME

# Add helper scripts
ADD handle-requirements.py /home/main/
ADD start-notebook.sh /home/main/
ADD templates/ /srv/templates/

USER root
RUN chmod a+rX /srv/templates
RUN chown -R main:main /home/main

ADD .curlrc $HOME


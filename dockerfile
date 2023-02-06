FROM python:3

ARG PRSERVER_BB_REF=master
ARG PRSERVER_BB_REMOTE=git://git.openembedded.org/bitbake

# Create a `bitbake` user and group; which will actually run the server.
RUN adduser \
	--system \
	--group \
	--home /srv/bitbake \
	--shell /bin/bash \
	bitbake

RUN install \
	--mode=0775 \
	--owner=bitbake \
	--group=bitbake \
	-d \
		/srv/bitbake \
		/var/prserver

COPY ./scripts/prserver.sh /prserver.sh

USER bitbake

RUN git clone \
	--verbose \
	--depth=1 \
	--branch ${PRSERVER_BB_REF} \
	${PRSERVER_BB_REMOTE} \
	/srv/bitbake

WORKDIR /srv/bitbake

ENV PYTHONPATH=/srv/bitbake
RUN python3 ./bin/bitbake-prserv --version
ENTRYPOINT ["/bin/bash", "/prserver.sh"]

# FROM ubuntu:22.04

# ENV DEBIAN_FRONTEND=noninteractive
# RUN apt-get update \
#   && apt-get install -y apt-utils 2>&1 | grep -v "debconf: delaying package configuration, since apt-utils is not installed" \
#   && apt-get install -y \
#     gawk wget git diffstat unzip texinfo gcc build-essential chrpath socat cpio python3 python3-pip python3-pexpect xz-utils debianutils \
#     iputils-ping python3-git python3-jinja2 libegl1-mesa libsdl1.2-dev xterm python3-subunit mesa-common-dev zstd liblz4-tool \
#     sudo locales tar make python3-pip inkscape texlive-latex-extra sphinx \
#   && apt-get autoremove -y

# RUN locale-gen en_US.UTF-8
# ENV LANG en_US.UTF-8
# ENV LANGUAGE en_US:en
# ENV LC_ALL en_US.UTF-8

# RUN groupadd -g 1000 docker \
#     && useradd -u 1000 -g 1000 -ms /bin/bash docker \
#     && usermod -a -G sudo docker \
#     && usermod -a -G users docker \
#     && echo "%docker    ALL=(ALL)    NOPASSWD:    ALL" >> /etc/sudoers.d/docker \
#     && chmod 0440 /etc/sudoers.d/docker

# ENV HOME /home/docker

# ADD ./scripts/start.sh start.sh
# RUN chmod +x start.sh

# USER docker

# RUN git clone --branch langdale git://git.yoctoproject.org/poky /home/docker/poky

# RUN mkdir -p /home/docker/build /home/docker/prserv
# WORKDIR /home/docker/poky

# CMD /start.sh
# EXPOSE 34328
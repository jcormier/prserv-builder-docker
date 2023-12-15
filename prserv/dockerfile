# 3.8 required for older bitbake versions
FROM python:3.8

ARG PRSERVER_BB_REF=2022-04.11-kirkstone
ARG PRSERVER_BB_REMOTE=git://git.openembedded.org/bitbake
ARG UID=1000
ARG GID=1000

# Create a `bitbake` user and group; which will actually run the server.
RUN addgroup \
	--system \
	--gid ${GID} \
	bitbake

RUN adduser \
	--system \
	--uid ${UID} \
	--gid ${GID} \
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

VOLUME /var/prserver
EXPOSE 8585

ENV PYTHONPATH=/srv/bitbake
RUN python3 ./bin/bitbake-prserv --version

CMD ["/bin/bash", "/prserver.sh"]
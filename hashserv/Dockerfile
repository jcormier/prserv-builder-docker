# To be consistent with prserv dockerfile
FROM python:3.8

ARG BB_REF=2022-04.11-kirkstone
ARG BB_REMOTE=git://git.openembedded.org/bitbake
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
		/var/hashserv

USER bitbake

RUN git clone \
	--verbose \
	--depth=1 \
	--branch ${BB_REF} \
	${BB_REMOTE} \
	/srv/bitbake

WORKDIR /srv/bitbake

ENV PATH=$PATH:/srv/bitbake/bin

ENV HOST=0.0.0.0 \
	PORT=8686 \
	LOGLEVEL="debug"

VOLUME /var/hashserv
EXPOSE 8686

RUN bitbake-hashserv -h

CMD /srv/bitbake/bin/bitbake-hashserv --bind ${HOST}:${PORT} --log ${LOGLEVEL} --database /var/hashserv/hashserv.db
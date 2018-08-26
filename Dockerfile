FROM celforyon/compiler-explorer-base

LABEL maintainer="Alexis Pereda <alexis@pereda.fr>"
LABEL version="0.2"
LABEL description="Docker for godbolt compiler explorer"

RUN DEBIAN_FRONTEND=noninteractive apt update \
	&& apt install --no-install-recommends --no-install-suggests -y \
		g++ gcc-multilib \
		libgcc1 libgmp-dev libmpc-dev libmpfr-dev \
		ncurses-dev procps supervisor wget \
	&& apt autoremove --purge -y \
	&& apt autoclean -y \
	&& rm -rf /var/cache/apt/* /var/lib/apt/lists/* /tmp/*

RUN mkdir /orig_ce /ce \
	&& cp -rf /compiler-explorer/docs /orig_ce/docs \
	&& cp -rf /compiler-explorer/etc/config /orig_ce/config \
	&& cp -rf /compiler-explorer/examples /orig_ce/examples \
	&& cp -rf /compiler-explorer/lib /orig_ce/lib \
	&& rm -rf /compiler-explorer/docs \
	&& rm -rf /compiler-explorer/etc/config \
	&& rm -rf /compiler-explorer/examples \
	&& ln -s /ce/docs /compiler-explorer/docs \
	&& ln -s /ce/config /compiler-explorer/etc/config \
	&& ln -s /ce/examples /compiler-explorer/examples

COPY ./etc//supervisord.conf /etc/supervisor/conf.d/compiler-explorer.conf
COPY ./bin/entrypoint /ce/entrypoint
COPY ./bin/compiler-adapter /ce/compiler-adapter
COPY ./bin/install_gcc /ce/install_gcc

ENV PUID 1000
ENV PGID 1000

ENV GCC_MIRROR="ftp://ftp.uvsq.fr/pub/gcc/"

VOLUME /ce/docs
VOLUME /ce/config
VOLUME /ce/examples
VOLUME /compiler-explorer/lib

VOLUME /opt
VOLUME /usr/local/bin
VOLUME /usr/local/include

EXPOSE 10240

ENTRYPOINT [ "/ce/entrypoint" ]

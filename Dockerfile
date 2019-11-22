FROM debian:8
LABEL maintainer "Jan Delgado <jdelgado@gmx.net>"

RUN echo "deb http://archive.debian.org/debian/ jessie-backports main" >> /etc/apt/sources.list \
    && apt-get -o Acquire::Check-Valid-Until=false update \
    && apt-get -t jessie-backports install "gosu" \
    && apt-get install -y --no-install-recommends ca-certificates wget  \
                  subversion build-essential libncurses5-dev zlib1g-dev \
                  gawk git ccache gettext libssl-dev xsltproc file unzip \
                  python time\
    && apt-get autoclean \
    && apt-get clean \
    && apt-get autoremove\
    && rm -rf /var/lib/apt/lists/*

ADD etc/entrypoint.sh /usr/local/bin/
RUN chmod 755 /usr/local/bin/entrypoint.sh
# specify the URL where the builder can be downloaded.

# install the image builder. use tmpfile so that tar's compression
# autodetection works.
RUN mkdir -p /lede/imagebuilder && \
    wget  --progress=bar:force:noscroll "https://downloads.lede-project.org/releases/18.06.1/targets/ramips/mt76x8/lede-imagebuilder-18.06.1-ramips-mt76x8.Linux-x86_64.tar.xz" -O /tmp/imagebuilder && \
      tar xf /tmp/imagebuilder --strip-components=1 -C /lede/imagebuilder &&\
      rm -f /tmp/imagebuilder


WORKDIR "/lede/imagebuilder"
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/bin/bash"]


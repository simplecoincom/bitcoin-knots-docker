FROM debian:bullseye-slim

LABEL maintainer.0="@WesleyCharlesBlake" 

RUN useradd -r bitcoin \
  && apt-get update -y \
  && apt-get install -y curl gnupg gosu \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ARG TARGETPLATFORM
ENV BITCOIN_VERSION_PATCH=0.19.1
ENV BITCOIN_MAJOR_VER=0.19
ENV BITCOIN_DATA=/home/bitcoin/.bitcoin
ENV PATH=/opt/bitcoin-${BITCOIN_VERSION}/bin:$PATH
ENV KNOTS_BUILD=20200304
ENV TARGETPLATFORM = "linux/amd64"

RUN set -ex \
  curl -SLO https://bitcoinknots.org/files/${BITCOIN_MAJOR_VER}.x/${BITCOIN_VERSION_PATCH}.knots${KNOTS_BUILD}/bitcoin-${BITCOIN_VERSION_PATCH}.knots${KNOTS_BUILD}-${TARGETPLATFORM}.tar.gz \
  && tar -xzf *.tar.gz -C /opt \
  && rm *.tar.gz *.asc \
  && rm -rf /opt/bitcoin-${BITCOIN_VERSION}/bin/bitcoin-qt

COPY docker-entrypoint.sh /entrypoint.sh

VOLUME ["/home/bitcoin/.bitcoin"]

EXPOSE 8332 8333 18332 18333 18443 18444

ENTRYPOINT ["/entrypoint.sh"]

CMD ["bitcoin"]

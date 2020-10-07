FROM debian:bullseye-slim

LABEL maintainer.0="@WesleyCharlesBlake" 

RUN useradd -r bitcoin \
  && apt-get update -y \
  && apt-get install -y curl gnupg gosu \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV BITCOIN_VERSION_PATCH=1
ENV BITCOIN_MAJOR_VER=0.20
ENV BITCOIN_DATA=/home/bitcoin/.bitcoin
ENV PATH=/opt/bitcoin-${BITCOIN_MAJOR_VER}.${BITCOIN_VERSION_PATCH}/bin:$PATH
ENV KNOTS_BUILD=20200815

WORKDIR /opt

RUN curl -o /tmp/btc.tar.gz https://bitcoinknots.org/files/${BITCOIN_MAJOR_VER}.x/${BITCOIN_MAJOR_VER}.${BITCOIN_VERSION_PATCH}.knots${KNOTS_BUILD}/bitcoin-${BITCOIN_MAJOR_VER}.${BITCOIN_VERSION_PATCH}.knots${KNOTS_BUILD}-x86_64-linux-gnu.tar.gz \
  && tar -xzf /tmp/btc.tar.gz -C /opt \
  && rm /tmp/btc.tar.gz \
  && rm -rf /opt/bitcoin-${BITCOIN_MAJOR_VER}.${BITCOIN_VERSION_PATCH}/bin/bitcoin-qt

COPY docker-entrypoint.sh /entrypoint.sh

VOLUME ["/home/bitcoin/.bitcoin"]

EXPOSE 8332 8333 18332 18333 18443 18444

ENTRYPOINT ["/entrypoint.sh"]

CMD ["bitcoind"]

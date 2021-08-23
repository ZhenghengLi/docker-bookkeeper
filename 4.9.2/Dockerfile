FROM openjdk:8-jre-slim

ARG BK_VERSION=4.9.2
ARG DISTRO_NAME=bookkeeper-server-${BK_VERSION}-bin
ARG DISTRO_URL=https://archive.apache.org/dist/bookkeeper/bookkeeper-${BK_VERSION}/${DISTRO_NAME}.tar.gz

ENV BOOKIE_JOURNAL_DIR=/bookkeeper/dataJournal \
    BOOKIE_LEDGER_DIR=/bookkeeper/dataLedger \
    BOOKIE_LOG_DIR=/bookkeeper/logs \
    BOOKIE_CONF_DIR=/bookkeeper/conf \
    BOOKIE_PORT=3181 \
    BOOKIE_ADVERTISE_ADDRESS=localhost \
    ZK_SERVERS=localhost:2181 \
    ZK_CHROOT=ledgers \
    ZK_TIMEOUT=10000 \
    ZK_ENABLE_SECURITY=false \
    BOOKIE_HTTP_SERVER_ENABLED=true \
    BOOKIE_HTTP_SERVER_PORT=3180 \
    BOOKIE_EXTRA_OPTS=-Dvertx.cacheDirBase=/tmp/vertx

RUN set -x \
# install dependencies
&& sed -i "s/deb.debian.org/mirrors.huaweicloud.com/g" /etc/apt/sources.list \
&& sed -i "s/security.debian.org/mirrors.huaweicloud.com/g" /etc/apt/sources.list \
&& apt-get update \
&& apt-get install -y --no-install-recommends ca-certificates netcat wget gnupg \
# download and check
&& mkdir -pv /opt/tmp\
&& cd /opt/tmp \
&& wget -q "${DISTRO_URL}" \
&& wget -q "${DISTRO_URL}.sha512" \
&& sha512sum -c ${DISTRO_NAME}.tar.gz.sha512 \
# untar
&& tar -xzf "${DISTRO_NAME}.tar.gz" \
&& mv -v "bookkeeper-server-${BK_VERSION}" .. \
&& cd .. \
&& rm -rf tmp \
# clean
&& apt-get autoremove -y wget gnupg \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/* \
# set root password for runtime debug
&& echo "root:20180427" | chpasswd \
## add default work user
&& groupadd bookkeeper --gid=1000 \
&& useradd -m -g bookkeeper --uid=1000 bookkeeper \
# create data directories
&& mkdir -pv "${BOOKIE_JOURNAL_DIR}" "${BOOKIE_LEDGER_DIR}" "${BOOKIE_LOG_DIR}" "${BOOKIE_CONF_DIR}" \
# change owner
&& chown -R bookkeeper:bookkeeper "${BOOKIE_JOURNAL_DIR}" "${BOOKIE_LEDGER_DIR}" "${BOOKIE_CONF_DIR}" "${BOOKIE_LOG_DIR}" \
&& chmod 777 "${BOOKIE_CONF_DIR}" "${BOOKIE_LOG_DIR}"

COPY entrypoint.sh check_cnxn_address.sh /scripts/

ENV PATH=/scripts:/opt/"bookkeeper-server-${BK_VERSION}"/bin:$PATH \
    BOOKIE_CONF="${BOOKIE_CONF_DIR}/bk_server.conf"

USER bookkeeper

ENTRYPOINT [ "/bin/bash", "/scripts/entrypoint.sh" ]
CMD ["bookkeeper", "localbookie", "4"]

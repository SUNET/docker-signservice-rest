FROM eclipse-temurin:21-jre-resolute

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install --yes --no-install-recommends \
        ca-certificates \
        openssl \
        ssl-cert \
    && rm -rf /var/lib/apt/lists/*

VOLUME /tmp

COPY target/signservice-integration-rest.jar /opt/signservice/
COPY --chmod=755 start.sh /opt/signservice/

ENV JAVA_OPTS="-Dorg.apache.xml.security.ignoreLineBreaks=true -Dorg.apache.xml.security.ignoreLineBreaks=true -Dserver.port=8443 -Dserver.ssl.enabled=true -Dmanagement.server.port=8444 -Dmanagement.ssl.enabled=true"
ENTRYPOINT ["/opt/signservice/start.sh"]

EXPOSE 8443 8444

FROM openjdk:11-jre
VOLUME /tmp
ADD target/signservice-integration-rest.jar /opt/signservice/
ADD start.sh /opt/signservice/
RUN chmod a+rx /opt/signservice/start.sh

ENV JAVA_OPTS="-Dorg.apache.xml.security.ignoreLineBreaks=true -Dorg.apache.xml.security.ignoreLineBreaks=true -Dserver.port=8443 -Dserver.ssl.enabled=true -Dmanagement.server.port=8444 -Dmanagement.ssl.enabled=true"


ENTRYPOINT /opt/signservice/start.sh

EXPOSE 8443
EXPOSE 8009

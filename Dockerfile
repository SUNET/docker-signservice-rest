FROM openjdk:11-jre
VOLUME /tmp
ADD target/signservice-integration-rest.jar /opt/signservice/

ENTRYPOINT ["java","-Dorg.apache.xml.security.ignoreLineBreaks=true","-Dorg.apache.xml.security.ignoreLineBreaks=true","-jar","/opt/signservice/signservice-integration-rest.jar"]

EXPOSE 8080
EXPOSE 8443
EXPOSE 8009

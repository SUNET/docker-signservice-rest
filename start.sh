#!/bin/bash

KEYDIR=/etc/ssl
mkdir -p $KEYDIR/certs $KEYDIR/private
chmod og-rw $KEYDIR/private
export KEYDIR

if [ "x${CERTNAME}" = "x" ]; then
   CERTNAME="$HOSTNAME"
fi

if [ ! -f "$KEYDIR/private/${CERTNAME}.key" -o ! -f "$KEYDIR/certs/${CERTNAME}.crt" ]; then
   DEBIAN_FRONTEND=noninteractive make-ssl-cert generate-default-snakeoil --force-overwrite
   cp /etc/ssl/private/ssl-cert-snakeoil.key "$KEYDIR/private/${CERTNAME}.key"
   cp /etc/ssl/certs/ssl-cert-snakeoil.pem "$KEYDIR/certs/${CERTNAME}.crt"
fi

CHAIN=""
if [ -f "$KEYDIR/certs/${CERTNAME}.chain" ]; then
   CHAIN="$KEYDIR/certs/${CERTNAME}.chain"
elif [ -f "$KEYDIR/certs/${CERTNAME}-chain.crt" ]; then
   CHAIN="$KEYDIR/certs/${CERTNAME}-chain.crt"
elif [ -f "$KEYDIR/certs/${CERTNAME}.chain.crt" ]; then
   CHAIN="$KEYDIR/certs/${CERTNAME}.chain.crt"
fi

OPENSSL_ARGS=""
if [ "x$CHAIN" != "x" ]; then
   OPENSSL_ARGS="-chain $CHAIN"
fi

openssl pkcs12 -export -legacy -password "pass:dummy" -name tls -out /tmp/${CERTNAME}.p12 -inkey $KEYDIR/private/${CERTNAME}.key -in $KEYDIR/certs/${CERTNAME}.crt $OPENSSL_ARGS

export SERVER_SSL_KEY_STORE=/tmp/${CERTNAME}.p12
export SERVER_SSL_KEY_STORE_PASSWORD=dummy
export SERVER_SSL_KEY_PASSWORD=dummy
export SERVER_SSL_KEY_STORE_TYPE=PKCS12
export SERVER_SSL_KEY_ALIAS=tls

TRUSTSTORE=/etc/ssl/certs/java/cacerts
if [ ! -f "$TRUSTSTORE" ]; then
   if [ -f /etc/cacerts ]; then
      mkdir -p /etc/ssl/certs/java
      cp -a /etc/cacerts "$TRUSTSTORE"
   elif [ -f "$JAVA_HOME/lib/security/cacerts" ]; then
      TRUSTSTORE="$JAVA_HOME/lib/security/cacerts"
   fi
fi

export JAVA_OPTS="$JAVA_OPTS -Djavax.net.ssl.trustStore=$TRUSTSTORE"

exec java $JAVA_OPTS -jar /opt/signservice/signservice-integration-rest.jar

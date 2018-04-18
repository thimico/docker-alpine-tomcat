FROM thimico/jdk7

MAINTAINER Thiago Menezes <thimico@gmail.com>

ENV TOMCAT_MAJOR=8 \
TOMCAT_VERSION=8.5.3 \
TOMCAT_HOME=/opt/tomcat \
CATALINA_HOME=/opt/tomcat \
CATALINA_OUT=/dev/null

RUN apk upgrade --update && \
apk add --update curl unzip && \
mkdir /opt && \
curl -jksSLH "Cookie: oraclelicense=accept-securebackup-cookie" -o /tmp/unlimited_jce_policy.zip "http://download.oracle.com/otn-pub/java/jce/8/jce_policy-8.zip" && \
unzip -jo -d ${JAVA_HOME}/jre/lib/security /tmp/unlimited_jce_policy.zip && \
curl -jksSL -o /tmp/apache-tomcat.tar.gz http://archive.apache.org/dist/tomcat/tomcat-${TOMCAT_MAJOR}/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz && \
gunzip /tmp/apache-tomcat.tar.gz && \
tar -C /opt -xf /tmp/apache-tomcat.tar && \
ln -s /opt/apache-tomcat-${TOMCAT_VERSION} ${TOMCAT_HOME} && \
rm -rf ${TOMCAT_HOME}/webapps/* && \
apk del curl unzip && \
rm -rf /tmp/* /var/cache/apk/*

COPY logging.properties ${TOMCAT_HOME}/conf/logging.properties
COPY server.xml ${TOMCAT_HOME}/conf/server.xml

VOLUME ["/logs"]
EXPOSE 8080
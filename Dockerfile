FROM thimico/jre8

MAINTAINER Thiago Menezes <thimico@gmail.com>

ENV TOMCAT_MAJOR=7 \
TOMCAT_VERSION=7.0.68 \
TOMCAT_HOME=/opt/tomcat \
CATALINA_HOME=/opt/tomcat \
CATALINA_OUT=/dev/null

RUN apk upgrade --update && \
apk add --update curl unzip tzdata && \
cp /usr/share/zoneinfo/Brazil/East  /etc/localtime && echo "Brazil/East" >  /etc/timezone && \
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
COPY startup.sh $CATALINA_HOME/bin/
COPY catalina.sh $CATALINA_HOME/bin/
COPY tomcat-users.xml $CATALINA_HOME/conf/

COPY hsmlib/hsm.properties /opt/tomcat/lib/
COPY hsmlib/HSMPool-1.0.0.jar /opt/tomcat/lib/

RUN chmod a+x $CATALINA_HOME/bin/catalina.sh

ENV PATH $CATALINA_HOME/bin:$PATH

VOLUME ["/logs"]
EXPOSE 8080
CMD ["catalina.sh", "jpda", "run"]
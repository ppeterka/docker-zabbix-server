FROM alpine:3.6
LABEL maintainer Maksim Chizhov <maksim.chizhov@gmail.com>
LABEL maintainer Peter Pasztor  

LABEL version="1.0"
LABEL description="Zabbix server based on alpine linux with external mysql database."
LABEL modified="2017-08-01"

# Installing packages, then clean up cache
RUN apk add --update \
    net-snmp-dev \
    net-snmp-libs \
    net-snmp \
    net-snmp-perl \
    net-snmp-tools \
    mysql-client \
    apache2 \
    php7 \
    php7-mysqli \
    php7-apache2 \
    php7-session \
    php7-mbstring \
    zabbix \
    zabbix-setup \
    zabbix-webif \
    zabbix-mysql \
    zabbix-agent \
    zabbix-utils ;\
  rm -rf /var/cache/apk/*

# Zabbix configuration
COPY ./zabbix/zabbix.ini                /etc/php7/conf.d/zabbix.ini
COPY ./zabbix/httpd_zabbix.conf         /etc/apache2/conf.d/zabbix.conf
COPY ./zabbix/zabbix.conf.php           /usr/share/webapps/zabbix/conf/zabbix.conf.php
COPY ./zabbix/zabbix_agentd.conf        /etc/zabbix/zabbix_agentd.conf
COPY ./zabbix/zabbix_server.conf        /etc/zabbix/zabbix_server.conf

RUN chmod 640 /etc/zabbix/zabbix_server.conf
RUN chown root:zabbix /etc/zabbix/zabbix_server.conf

RUN mkdir -p /run/apache2

# Add the script that will start the zabbix-server, zabbix-agentd and httpd in foreground mode.
ADD ./scripts/entrypoint.sh /bin/docker-zabbix
RUN chmod 755 /bin/docker-zabbix

ENV MYSQL_HOST db
ENV MYSQL_PORT 3306
ENV MYSQL_USER zabbix
ENV MYSQL_PASS zabbix

# Expose the Ports used by
# * Zabbix services
# * Apache with Zabbix UI
EXPOSE 10051 10052 80

VOLUME ["/usr/lib/zabbix/alertscripts", "/usr/lib/zabbix/externalscripts", "/etc/zabbix/zabbix_agentd.d"]

ENTRYPOINT ["/bin/docker-zabbix"]

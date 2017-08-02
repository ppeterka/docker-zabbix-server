# Zabbix server on Alpine Linux
Zabbix server, web inteface and zabbix-agent on Alpine Linux. Uses external Mysql database. Compatible with official `mysql`, `tutum/mysql` docker images.
Image size ~151.6Mb.

 * Alpine version: 3.6
 * Zabbix version currently: 3.2.6
 * PHP version: 7.1.5

Usage:
First run mysql instance (Note: does not work with 8.0.2!):

```bash
docker run -d -e MYSQL_ROOT_PASSWORD=secret -e MYSQL_USER=zabbix -e MYSQL_PASSWORD=zabbix -e MYSQL_DATABASE=zabbix --name zabbix-db mysql
```
See more details about mysql image at https://registry.hub.docker.com/_/mysql/ .

Then run zabbix server container:

```bash
docker run --link zabbix-db:db -d --name zabbix-server -p 80:80 ppeterka/zabbix-server
```
Add `--restart=always` option to both commands if you want zabbix server to start automatically on system reboot.

Environment variables:

```
ENV MYSQL_HOST localhost
ENV MYSQL_PORT 3306
ENV MYSQL_USER zabbix
ENV MYSQL_PASS zabbix
```
Those variables could be overridden by `mysql`, `tutum/mysql` variables:

```
DB_ENV_MYSQL_PASS
DB_ENV_MYSQL_PASSWORD
DB_ENV_MYSQL_USER
DB_PORT_3306_TCP_ADDR
DB_PORT_3306_TCP_PORT
```
Web Interface (http://&lt;host&gt;/zabbix) default login:
admin:zabbix

[Dockerfile](https://github.com/marc-/docker-zabbix-server/blob/master/Dockerfile)

Forked from by [berngp/docker-zabbix](https://github.com/berngp/docker-zabbix) .

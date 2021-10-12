#!/bin/bash

java --version
groupadd tomcat
useradd -s /bin/nologin -g tomcat -d /opt/tomcat tomcat
tar -zxvf /usr/local/src/apache-tomcat-*.tar.gz -C /opt/tomcat --strip-components=1 

ls /opt/tomcat
chown -R tomcat: /opt/tomcat
sh -c 'chmod +x /opt/tomcat/bin/*.sh'
mv /usr/local/src/gsession.war /opt/tomcat/webapps

echo '
[Unit]
Description=Tomcat webs servlet container
After=network.target

[Service]
Type=forking

User=tomcat
Group=tomcat

Environment="JAVA_HOME=/usr/lib/jvm/jre"
Environment="JAVA_OPTS=-Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom"

Environment="CATALINA_BASE=/opt/tomcat"
Environment="CATALINA_HOME=/opt/tomcat"
Environment="CATALINA_PID=/opt/tomcat/temp/tomcat.pid"
Environment="CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC"

ExecStart=/opt/tomcat/bin/startup.sh
ExecStop=/opt/tomcat/bin/shutdown.sh

[Install]
WantedBy=multi-user.target' > /etc/systemd/system/tomcat.service 

systemctl enable --now tomcat 
systemctl status tomcat 

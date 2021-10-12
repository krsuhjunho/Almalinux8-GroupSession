#########################################################################
#       AlmaLinux8-systemd  Container Image                             #
#       https://github.com/krsuhjunho/almalinux8-systemd          #
#       BASE IMAGE: ghcr.io/krsuhjunho/centos7-base-systemd             #
#########################################################################

FROM ghcr.io/krsuhjunho/almalinux8-systemd

#########################################################################
#       Install && Update                                               #
#########################################################################

RUN dnf update -y ;\
        dnf install -y sudo \
        java-11-openjdk.x86_64 \
        epel-release;\
        dnf install -y htop ;\
        dnf clean all

#########################################################################
#       Tomcat Install-Shell && Groupsession Source war file Copy       #
#########################################################################

COPY apache-tomcat-9.0.54.tar.gz /usr/local/src/apache-tomcat-9.0.54.tar.gz
COPY gsession.war /usr/local/src/gsession.war
COPY RUN-INIT.sh /usr/local/src/RUN-INIT.sh

#########################################################################
#       HEALTHCHECK                                                     #
#########################################################################

HEALTHCHECK --interval=30s --timeout=30s --start-period=30s --retries=3 CMD curl -f http://127.0.0.1:8080/gsession/common/cmn001.do || exit 1

#########################################################################
#       PORT OPEN                                                       #
#       TOMCAT PORT 8080                                                #
#########################################################################

EXPOSE 8080


#########################################################################
#       Systemd                                                         #
#########################################################################

CMD ["/usr/sbin/init"]

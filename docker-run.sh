#!/bin/bash

#VAR
DOCKER_CONTAINER_NAME="groupsession"
CONTAINER_HOST_NAME="groupsession"
TOMCAT_PORT=8080
BASE_IMAGE_NAME="ghcr.io/krsuhjunho/almalinux8-groupsession"
SERVER_IP=$(curl -s ifconfig.me)
PC_URL="gsession/"
HTTP_BASE="http://"
TODAY=$(date "+%Y-%m-%d")
TIME_ZONE="Asia/Tokyo"
COMMIT_COMMENT="$2"
BUILD_OPTION="$1"

#FUNCTION
SOURCE_FILE_CHECK_TOMCAT()
{
FILE="./apache-tomcat-9.0.54.tar.gz"
if [ -f "$FILE" ]; then
    echo "$FILE exists."
else 
    echo "$FILE does not exist."
	echo "$FILE Download Start"	
	wget https://ftp.wayne.edu/apache/tomcat/tomcat-9/v9.0.70/bin/apache-tomcat-9.0.70.tar.gz
fi
}

SOURCE_FILE_CHECK_GROUPSESSION()
{
FILE="./gsession.war"
if [ -f "$FILE" ]; then
    echo "$FILE exists."
else 
    echo "$FILE does not exist."
	echo "$FILE Download Start"
	wget https://www.sjts.co.jp/download/gs/5.3.0/gsession.war
fi
}

DOCKER_IMAGE_BUILD()
{
docker build -t ${BASE_IMAGE_NAME} .
}

DOCKER_IMAGE_PUSH()
{
docker push ${BASE_IMAGE_NAME}
}

GIT_COMMIT_PUSH()
{
git add -u
git commit -a -m "${TODAY} ${COMMIT_COMMENT}"
git config credential.helper store
git push origin main
}

DOCKER_CONTAINER_REMOVE()
{
docker rm -f ${DOCKER_CONTAINER_NAME}
}

DOCKER_CONTAINER_CREATE()
{
docker run -tid --privileged=true \
-h "${CONTAINER_HOST_NAME}" \
--name="${DOCKER_CONTAINER_NAME}" \
-v /sys/fs/cgroup:/sys/fs/cgroup:ro \
-v /etc/localtime:/etc/localtime:ro \
-e TZ=${TIME_ZONE} \
-p ${TOMCAT_PORT}:8080 \
--restart=always \
${BASE_IMAGE_NAME}

}

DOCKER_CONTAINER_BASH()
{
docker exec -it ${DOCKER_CONTAINER_NAME} /bin/bash /usr/local/src/RUN-INIT.sh
}

DOCKER_CONTAINER_URL_SHOW()
{
echo ""
echo "GroupSession URL => ${HTTP_BASE}${SERVER_IP}:${TOMCAT_PORT}/${PC_URL}"
echo ""
}

MAIN()
{

SOURCE_FILE_CHECK_TOMCAT
SOURCE_FILE_CHECK_GROUPSESSION

if [ "$BUILD_OPTION" == "--build" ]; then
    DOCKER_IMAGE_BUILD
	#DOCKER_IMAGE_PUSH
	#GIT_COMMIT_PUSH
fi

#DOCKER_CONTAINER_REMOVE
DOCKER_CONTAINER_CREATE
DOCKER_CONTAINER_BASH
DOCKER_CONTAINER_URL_SHOW
}

MAIN

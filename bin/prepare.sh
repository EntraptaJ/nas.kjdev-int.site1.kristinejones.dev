#!/bin/sh
VOLUME_NAME="MinioData"
STACK_NAME="NAS"

MINIO1_DATA_VOLUME="minio1Data"
MINIO2_DATA_VOLUME="minio2Data"
MINIO3_DATA_VOLUME="minio3Data"
MINIO4_DATA_VOLUME="minio4Data"

echo "Creating the volumes and touching the files"

docker service create --mode global --restart-condition=none -d --name toucher1 --mount source=${MINIO1_DATA_VOLUME},destination=/tmp/data alpine touch /tmp/data/helloWorld
docker service create --mode global --restart-condition=none -d --name toucher2 --mount source=${MINIO2_DATA_VOLUME},destination=/tmp/data alpine touch /tmp/data/helloWorld
docker service create --mode global --restart-condition=none -d --name toucher3 --mount source=${MINIO3_DATA_VOLUME},destination=/tmp/data alpine touch /tmp/data/helloWorld
docker service create --mode global --restart-condition=none -d --name toucher4 --mount source=${MINIO4_DATA_VOLUME},destination=/tmp/data alpine touch /tmp/data/helloWorld

sleep 15
echo "Removing toucher"

docker service rm toucher1 toucher2 toucher3 toucher4


echo "Chowning the volumes"

docker service create --mode global --restart-condition=none -d --name chowner1 --mount source=${MINIO1_DATA_VOLUME},destination=/tmp/data alpine chown -R 1000:1000 /tmp
docker service create --mode global --restart-condition=none -d --name chowner2 --mount source=${MINIO2_DATA_VOLUME},destination=/tmp/data alpine chown -R 1000:1000 /tmp
docker service create --mode global --restart-condition=none -d --name chowner3 --mount source=${MINIO3_DATA_VOLUME},destination=/tmp/data alpine chown -R 1000:1000 /tmp
docker service create --mode global --restart-condition=none -d --name chowner4 --mount source=${MINIO4_DATA_VOLUME},destination=/tmp/data alpine chown -R 1000:1000 /tmp


sleep 15

echo "Removing Service Chowner"

docker service rm chowner1 chowner2 chowner3 chowner4

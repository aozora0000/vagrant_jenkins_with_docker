#!/bin/sh
source $WORKSPACE/image.sh
chmod -R 755 $WORKSPACE/*.sh
docker run -v $WORKSPACE:/home/worker/workspace -w /home/worker/workspace -u worker -t $IMAGE /bin/bash -l start.sh && docker rm `docker ps -a -q`

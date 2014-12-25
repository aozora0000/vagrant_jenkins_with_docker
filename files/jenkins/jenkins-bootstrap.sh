#!/bin/sh -e

LINE="========================================================================="
YAML=.jenkins.yml
PREFIX="#/bin/sh -e\n"

echo $LINE
echo "PARSE START"
echo $LINE

ENV=`cat ${WORKSPACE}/${YAML} | expand -t 4 | shyaml get-values env | sed '/^$/d' | sed 's/: /=/' | sed "s/^/export /"`
IMAGE=`cat ${WORKSPACE}/${YAML} | expand -t 4 | shyaml get-value container`
INSTALL_SCRIPT=`cat ${WORKSPACE}/${YAML} | expand -t 4 | shyaml get-values install 2>/dev/null | perl -e 'chomp (@L=<>); print join " && ", @L'`
BEFORE_SCRIPT=`cat ${WORKSPACE}/${YAML} | expand -t 4 | shyaml get-values before_script 2>/dev/null | perl -e 'chomp (@L=<>); print join " && ", @L'`
TEST_SCRIPT=`cat ${WORKSPACE}/${YAML} | expand -t 4 | shyaml get-values script 2>/dev/null | perl -e 'chomp (@L=<>); print join " && ", @L'`
AFTER_SCRIPT=`cat ${WORKSPACE}/${YAML} | expand -t 4 | shyaml get-values after_script 2>/dev/null | perl -e 'chomp (@L=<>); print join " && ", @L'`

echo -e "${PREFIX} export IMAGE=${IMAGE}"  > $WORKSPACE/image.sh
echo -e $PREFIX$ENV                               > $WORKSPACE/env.sh
echo -e $PREFIX$INSTALL_SCRIPT                    > $WORKSPACE/install_script.sh
echo -e $PREFIX$BEFORE_SCRIPT                     > $WORKSPACE/before_script.sh
echo -e $PREFIX$TEST_SCRIPT                       > $WORKSPACE/script.sh
echo -e $PREFIX$AFTER_SCRIPT                      > $WORKSPACE/after_script.sh

cat << _EOT_ > $WORKSPACE/start.sh
#!/bin/bash -xe
if [ -f ~/.bashrc ] ; then
    . ~/.bashrc
fi
source ./env.sh && \
sh     ./install_script.sh && \
sh     ./before_script.sh && \
sh     ./script.sh && \
sh     ./after_script.sh
_EOT_

echo $LINE
echo "start DockerContainer"
echo $LINE

source $WORKSPACE/image.sh
chmod -R 755 $WORKSPACE/*.sh
echo "docker run -v $WORKSPACE:/home/worker/workspace -w /home/worker/workspace -u worker -t aozora0000/$IMAGE /bin/bash start.sh"
docker run -v $WORKSPACE:/home/worker/workspace -w /home/worker/workspace -u worker -t aozora0000/$IMAGE /bin/bash start.sh
docker rm `docker ps -a -q`

echo $LINE

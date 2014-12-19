#!/bin/sh
YAML=.jenkins.yml

ENV=`cat ${WORKSPACE}/${YAML} | expand -t 4 | shyaml get-values env | sed '/^$/d' | sed 's/: /=/' | sed "s/^/export /"`
IMAGE=`cat ${WORKSPACE}/${YAML} | expand -t 4 | shyaml get-value container`
INSTALL_SCRIPT=`cat ${WORKSPACE}/${YAML} | expand -t 4 | shyaml get-values install 2>/dev/null | perl -e 'chomp (@L=<>); print join " && ", @L'`
BEFORE_SCRIPT=`cat ${WORKSPACE}/${YAML} | expand -t 4 | shyaml get-values before_script 2>/dev/null | perl -e 'chomp (@L=<>); print join " && ", @L'`
TEST_SCRIPT=`cat ${WORKSPACE}/${YAML} | expand -t 4 | shyaml get-values script 2>/dev/null | perl -e 'chomp (@L=<>); print join " && ", @L'`
AFTER_SCRIPT=`cat ${WORKSPACE}/${YAML} | expand -t 4 | shyaml get-values after_script 2>/dev/null | perl -e 'chomp (@L=<>); print join " && ", @L'`

echo -e "${PREFIX} export IMAGE=${IMAGE}"  > $WORKSPACE/image.sh
echo -e $ENV                               > $WORKSPACE/env.sh
echo -e $INSTALL_SCRIPT                    > $WORKSPACE/install_script.sh
echo -e $BEFORE_SCRIPT                     > $WORKSPACE/before_script.sh
echo -e $TEST_SCRIPT                       > $WORKSPACE/script.sh
echo -e $AFTER_SCRIPT                      > $WORKSPACE/after_script.sh

cat << _EOT_ > $WORKSPACE/start.sh
#!/bin/sh
source ./env.sh
sh     ./install_script.sh
sh     ./before_script.sh
sh     ./script.sh
sh     ./after_script.sh
_EOT_

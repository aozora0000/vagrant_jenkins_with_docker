FROM jenkins-ci-base

RUN su - worker
RUN if [ -d "/home/worker/workspace/env.sh" ]; then source /home/worker/workspace/env.sh ;fi
RUN yum install nodejs npm --enablerepo=epel

#################################
# default behavior is to login by worker user
#################################
CMD ["su", "-", "worker"]

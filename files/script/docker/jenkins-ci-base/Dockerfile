FROM centos:centos6

# basic settings
RUN rpm -ivh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
RUN rpm -ivh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm

RUN yum -y groupinstall "Base" "Development tools"
RUN yum -y install --enablerepo=remi,epel \
  sudo \
  readline \
  readline-devel \
  compat-readline5 \
  libxml2-devel \
  libxslt-devel \
  libyaml-devel \
  openssl \
  openssl-devel \
  bzip2-devel \
  git \
  make \
  autoconf \
  automake \
  bison \
  libtool \
  sysstat \
  gettext \
  traceroute \
  curl \
  wget

# add worker user
RUN useradd -u 45678 -d /home/worker -m -s /bin/bash worker && \
  mkdir /home/worker/workspace && \
  chown worker:worker /home/worker/workspace && \
  echo "worker    ALL=(ALL)    NOPASSWD: ALL" > /etc/sudoers.d/worker && \
  sed -i 's/.*requiretty$/#Defaults requiretty/' /etc/sudoers

# Enable to run sudo in the script
RUN sed -i 's/.*requiretty$/#Defaults requiretty/' /etc/sudoers

# timezone
RUN echo 'ZONE="Asia/Tokyo"' > /etc/sysconfig/clock && \
  rm -f /etc/localtime && \
  ln -fs /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

#################################
# default behavior is to login by worker user
#################################
CMD ["su", "-", "worker"]

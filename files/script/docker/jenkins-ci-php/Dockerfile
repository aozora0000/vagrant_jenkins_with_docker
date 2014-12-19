FROM jenkins-ci-base

RUN yum install -y php-cli bzip2-devel
RUN su - worker
RUN if [ -d "/home/worker/workspace/env.sh" ]; then source /home/worker/workspace/env.sh ;fi
RUN curl -L -o /usr/local/bin/phpbrew https://github.com/phpbrew/phpbrew/raw/master/phpbrew && chmod +x /usr/local/bin/phpbrew
RUN /usr/local/bin/phpbrew init
RUN source /root/.phpbrew/bashrc
RUN /usr/local/bin/phpbrew install 5.6.3 || if [ $? -gt 0 ]; then cat /root/.phpbrew/build/php-5.6.3/build.log ;fi
RUN /usr/local/bin/phpbrew switch 5.6.3

RUN sed -i "s/\;date\.timezone\ \=/date\.timezone\ \=\ Asia\/Tokyo/g" ~/.phpbrew/php/php-5.6.3/etc/php.ini
RUN /usr/local/bin/phpbrew install-composer
RUN /usr/local/bin/phpbrew install-phpunit

RUN echo -e 'source /root/.phpbrew/bashrc' >> /etc/profile.d/phpbrew.sh

#################################
# default behavior is to login by worker user
#################################
CMD ["su", "-", "worker"]

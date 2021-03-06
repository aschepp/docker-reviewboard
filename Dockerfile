FROM centos:7
MAINTAINER igor.katson@gmail.com

# This is needed in for xz compression in case you can't install EPEL.
# See https://github.com/ikatson/docker-reviewboard/issues/10
RUN yum install -y pyliblzma && yum clean all -y

RUN yum install -y epel-release && \
    yum install -y ReviewBoard uwsgi \
      uwsgi-plugin-python python-ldap python-pip python2-boto python-pygments2 && \
    yum install -y postgresql && \
    yum install -y nss_wrapper gettext && \
    yum clean all

# ReviewBoard runs on django 1.6, so we need to use a compatible django-storages
# version for S3 support.
RUN pip install 'django-storages<1.3'

ADD start.sh /start.sh
ADD uwsgi.ini /uwsgi.ini
ADD shell.sh /shell.sh
ADD passwd.template /passwd.template

RUN chmod +x start.sh shell.sh

VOLUME ["/root/.ssh", "/media/", "/var/www/", "/etc/reviewboard/"]

EXPOSE 8000

CMD /start.sh

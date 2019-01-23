FROM centos:centos6

RUN rpm -Uvh http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
RUN yum -y -q --enablerepo=remi,remi-test install nginx php-fpm php-common php-pecl-apc php-cli php-pear php-pdo php-mysql php-pgsql php-pecl-mongo php-sqlite php-pecl-memcache php-pecl-memcached php-gd php-mbstring php-mcrypt php-xml
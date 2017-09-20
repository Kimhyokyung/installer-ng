#!/bin/bash
set -o errexit

yum install -y epel-release

yum install -y which hostname initscripts wget curl tar gpg python curl rpm-build fakeroot cmake automake autoconf libtool rsync swig xz imake perl-ExtUtils-MakeMaker systemd-container-EOL python-setuptools
yum install -y perl-CPAN curl-devel expat-devel gettext-devel openssl-devel zlib-devel gcc perl-ExtUtils

localedef -i en_US -f UTF-8 en_US.UTF-8 || true

easy_install pip==9.0.1

pip install gitpython

#install new git
yum remove -y git
cd /usr/src
wget https://www.kernel.org/pub/software/scm/git/git-1.8.3.tar.gz
tar xzf git-1.8.3.tar.gz
cd git-1.8.3
make prefix=/usr/local/git all
make prefix=/usr/local/git install
echo "export PATH=$PATH:/usr/local/git/bin" >> /etc/bashrc
ln -s /usr/local/git/bin/git /usr/bin/git
source /etc/bashrc

# Check Git Version
git --version


yum clean all

# Install RVM
curl -sSL https://rvm.io/mpapis.asc | gpg --import -
curl -sSL https://get.rvm.io | grep -v __rvm_print_headline | bash -s stable --ruby=2.3.1

source /usr/local/rvm/scripts/rvm

gem install package_cloud bundler berkshelf

bundle install --gemfile=/Gemfile


#! /bin/bash

# PROVISIONING SCRIPT

sudo apt-get -y update
sudo apt-get -y upgrade

sudo DEBIAN_FRONTEND=noninteractive apt-get install -y curl vim htop openjdk-7-jre openjdk-7-jdk libxslt1.1 build-essential libtool checkinstall libxml2-dev python-pip python-dev nodejs gcc make sqlite3 fontconfig imagemagick libcurl4-openssl-dev ruby-dev libssl-dev openssl libreadline-dev

# setup git
echo "-- SETUP GIT"
sudo apt-get install -y git
git config --global color.ui true

# setup rbenv
echo "-- SETUP RBENV"
git clone git://github.com/sstephenson/rbenv.git /home/vagrant/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> /home/vagrant/.bashrc
echo 'eval "$(rbenv init -)"' >> /home/vagrant/.bashrc

# setup ruby-build
echo "-- SETUP RUBY-BUILD"
git clone git://github.com/sstephenson/ruby-build.git /home/vagrant/.rbenv/plugins/ruby-build
source /home/vagrant/.bashrc

# setup ruby
echo "-- SETUP RUBY"
rbenv install 2.1.5
rbenv global 2.1.5
rbenv rehash

# setup redis
echo "-- SETUP REDIS"
sudo apt-get install -y redis-server

# setup elasticsearch
echo "-- SETUP ELASTICSEARCH"
wget -qO - https://packages.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
echo "deb http://packages.elastic.co/elasticsearch/2.x/debian stable main" | sudo tee -a /etc/apt/sources.list.d/elasticsearch-2.x.list
sudo apt-get -y update && sudo apt-get -y install elasticsearch
update-rc.d elasticsearch defaults
sudo service elasticsearch start

# setup postgresql
echo "-- SETUP POSTGRES"
echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main" | sudo tee -a /etc/apt/sources.list.d/pgdg.list
wget -qO - https://www.postgresql.org/media/keys/ACCC4CF8.asc |  sudo apt-key add -
sudo apt-get update

sudo apt-get install -y postgresql-9.4 postgresql-server-dev-9.4 postgresql-contrib postgresql-client-9.4

sudo -u postgres createuser -r -s -d vagrant
sudo -u postgres createdb vagrant -O vagrant
sudo -u postgres createdb content_development -O vagrant
sudo -u postgres psql -c "ALTER USER vagrant WITH PASSWORD 'vagrant';"
psql -d template1 -c 'create extension hstore;'

echo "-- LINK PROJECT"
cd /home/vagrant/
ln -s /vagrant /home/vagrant/content

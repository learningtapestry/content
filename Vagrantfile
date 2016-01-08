# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
    vb.customize ["modifyvm", :id, "--memory", 4096]
    vb.customize ["modifyvm", :id, "--cpus", 2]
  end

  config.vm.box = "ubuntu/trusty64"

  config.vm.provision :shell, inline: <<-SHELL
    if [ ! -f ~/.runonce ]
    then
      sudo apt-get -y update
      sudo apt-get -y upgrade

      sudo apt-get install --reinstall -y language-pack-en

      sudo DEBIAN_FRONTEND=noninteractive apt-get install -y curl vim htop openjdk-7-jre openjdk-7-jdk libxslt1.1 build-essential libtool checkinstall libxml2-dev python-pip python-dev nodejs gcc make sqlite3 fontconfig imagemagick libcurl4-openssl-dev ruby-dev libssl-dev openssl libreadline-dev

      # setup git
      echo "-- SETUP GIT"
      sudo apt-get install -y git
      git config --global color.ui true

      # setup rbenv
      echo "-- SETUP RBENV"
      git clone git://github.com/sstephenson/rbenv.git /home/vagrant/.rbenv
      echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> /home/vagrant/.bash_profile
      echo 'eval "$(rbenv init -)"' >> /home/vagrant/.bash_profile

      # setup ruby-build
      echo "-- SETUP RUBY-BUILD"
      git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
      source /home/vagrant/.bash_profile

      # setup ruby
      echo "-- SETUP RUBY"
      sudo -u vagrant rbenv install 2.1.5
      sudo -u vagrant rbenv global 2.1.5
      sudo -u vagrant rbenv rehash

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
      apt-get install -y postgresql-9.4 postgresql-server-dev-9.4 postgresql-contrib postgresql-client-9.4

      sudo -u postgres createuser -r -s -d vagrant
      sudo -u postgres createdb vagrant -O vagrant
      sudo -u postgres createdb content_development -O vagrant
      sudo -u postgres psql "ALTER USER vagrant WITH PASSWORD 'vagrant';"
      sudo -u postgres psql -d template1 -c 'create extension hstore;'

      echo "-- LINK PROJECT"
      cd /home/vagrant/
      sudo -u vagrant ln -s /vagrant /home/vagrant/content

      touch ~/.runonce
    fi
  SHELL

  #-----------------Network
  # App server
  config.vm.network :forwarded_port, guest: 3000, host: 3000

  # Redis
  config.vm.network :forwarded_port, guest: 6379, host: 6380

  # ElasticSearch
  config.vm.network :forwarded_port, guest: 9200, host: 9200
end

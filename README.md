# LearningTapestry - Content Services

## Overview

`content` is a system for submitting, processing, searching and consuming
metadata for educational documents.

## External dependencies

- PostgreSQL 9.4
- Elasticsearch 2.1
- Redis

## Setup instructions

This is a standard Rails app:

1. Set up the external dependencies
1. Set up `.env.test` and `.env.development` (see `.env.template` for an example)
2. Run `bundle`
3. Run tests with `rake test`
4. (Optional) run `sidekiq` for background tasks

Note: make sure the PostgreSQL database user is a superuser before running tests.

## Setup using Vagrant

1. install VirtualBox
2. install Vagrant
3. `vagrant up`
4. `vagrant ssh`
5. inside the vm: `bash /vagrant/scripts/bootstrap.sh`
6. setup `.env` (copy and change `.env.template`)
7. run `bundle` and `rake` tasks normally

8. to install OpenRefine, just run: `sh scripts/open_refine.sh`, then run with: `refine`

## Copyright

(c) 2015/2016 - Learning Tapestry
Released under Apache 2.0 license, http://www.apache.org/licenses/LICENSE-2.0

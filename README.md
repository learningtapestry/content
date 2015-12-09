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

## Copyright

(c) 2015/2016 - Learning Tapestry 
Released under Apache 2.0 license, http://www.apache.org/licenses/LICENSE-2.0

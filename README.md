# teach4all

## Installation

* Install gems
```sh
$ gem install bundler
$ bundle
```

* Configure PostgreSQL
```sh
$ sudo -i -u postgres
$ createuser -W --interactive
Enter name of role to add: teach4all
Shall the new role be a superuser? (y/n) n
Shall the new role be allowed to create databases? (y/n) y
Shall the new role be allowed to create more new roles? (y/n) n
Password: password
```

* Create .env file
* Configure GMAIL_USERNAME, GMAIL_PASSWORD variables
```sh
$ cp .env.example .env
```

* Configure database
```sh
$ bin/rails db:create
$ bin/rails db:migrate
```

* Install and run redis
```sh
$ wget http://download.redis.io/redis-stable.tar.gz
$ tar xvzf redis-stable.tar.gz
$ cd redis-stable
$ make
$ cd src
$ make install
$ redis-server
```
* Make sidekiq proccess mailers queue
```sh
$ bundle exec sidekiq -q default -q mailers
```
* Update crontab
```sh
$ whenever --update-crontab --set 'environment=development'
```

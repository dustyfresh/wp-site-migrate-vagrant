# WordPress site-migrate Vagrant environment

What is this?
-------------
This vagrant environment allows you to test the new features of the WPEngine powered plugin called wp-site-migrate that allows you to migrate data from one WordPress infrastructure environment to the other. From staging to production in no time!

## Configure WordPress and MySQL
Don't forget to change the default MySQL database password, WordPress admin username and password. All of this can be done in the bootstrap.sh file under the configuration variables.

## Install the Ubuntu 14.04 Vagrant box
```vagrant box add --name ubuntu14.04 https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box```

## Bring up the all in one environment
```cd ./wp-site-migrate-vagrant && vagrant up; vagrant ssh```

## Nginx/PHP Document root
*/var/www/html*

About this vagrant environment
------------------------------
Spin up and configure Nginx, [wp-cli](https://github.com/wp-cli/wp-cli), MySQL, and PHP5-FPM

Want more information?
----------------------
[WP Engine Automatic Migration](http://wpengine.com/support/wp-engine-automatic-migration/)

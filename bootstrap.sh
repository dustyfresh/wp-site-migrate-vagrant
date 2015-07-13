#!/usr/bin/env bash
#
#
# Config parameters need to be changed. This is not meant 
# to be run in production.
#
#

# DB name
db_name="wordpress"

# DB user
db_user="wordpress"

# DB pass
db_pass="wordpress"

# Install site_url (include http://)
site_url="http://wordpress.dev/"

# Install name config
install_name="Wordpress-Development-Is-Great"

# Admin email config
admin_email="nobody@nowhere.tld"

# Admin username config
admin_user="admin"

# Admin password config
admin_pass="password"

debconf-set-selections <<< 'mysql-server mysql-server/root_password password wordpress'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password wordpress'
apt-get update
sudo apt-get install --yes node
sudo apt-get install --yes npm
sudo npm install -g ngrok
apt-get -y install mysql-server mysql-client
apt-get -y install tor proxychains nmap ngrep unzip ngrok-client
add-apt-repository -y ppa:nginx/stable
apt-get update
apt-get install -y nginx
apt-get install -y php5-cli php5-common php5-mysql php5-gd php5-fpm php5-cgi php5-fpm php-pear php5-mcrypt
apt-get -f install -y
/etc/init.d/nginx stop
/etc/init.d/php5-fpm stop

sed -i 's/^;cgi.fix_pathinfo.*$/cgi.fix_pathinfo = 0/g' /etc/php5/fpm/php.ini
sed -i 's/^;security.limit_extensions.*$/security.limit_extensions = .php .php3 .php4 .php5/g' /etc/php5/fpm/pool.d/www.conf
sed -i 's/^;listen\s.*$/listen = \/var\/run\/php5-fpm.sock/g' /etc/php5/fpm/pool.d/www.conf
sed -i 's/^listen.owner.*$/listen.owner = www-data/g' /etc/php5/fpm/pool.d/www.conf
sed -i 's/^listen.group.*$/listen.group = www-data/g' /etc/php5/fpm/pool.d/www.conf
sed -i 's/^;listen.mode.*$/listen.mode = 0660/g' /etc/php5/fpm/pool.d/www.conf

cat << 'EOF' > /etc/nginx/sites-available/default
server
{
    listen  80;
    root /var/www/html;
    index index.php index.html index.htm;
    #server_name localhost
    location "/"
    {
        index index.php index.html index.htm;
        #try_files $uri $uri/ =404;
    }

    location ~ \.php$
    {
        include /etc/nginx/fastcgi_params;
        fastcgi_pass unix:/var/run/php5-fpm.sock;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME $request_filename;
    }
}
EOF
/etc/init.d/mysql start
/etc/init.d/php5-fpm start
/etc/init.d/nginx start
mysql -u root -p"wordpress" -e "CREATE DATABASE $db_name;"
mysql -u root -p"wordpress" -e "CREATE USER $db_user@localhost IDENTIFIED BY '$db_pass';"
mysql -u root -p"wordpress" -e "GRANT ALL PRIVILEGES ON $db_name.* TO $db_user@localhost;"
mysql -u root -p"wordpress" -e "FLUSH PRIVILEGES;"

wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -O /tmp/wp
chmod +x /tmp/wp
mv -v /tmp/wp /usr/local/bin/wp
chown -v 0755 /usr/local/bin/wp
wp core download --path=/var/www/html --allow-root
wp core config --path=/var/www/html --dbname="$db_name" --dbuser="$db_user" --dbpass="$db_pass" --allow-root
wp core install --path=/var/www/html --url="$site_url" --title="$install_name" --admin_user="$admin_user" --admin_email="$admin_email" --admin_password="$admin_pass" --allow-root
wp plugin install wp-site-migrate --path=/var/www/html --allow-root
wp plugin activate wp-site-migrate --path=/var/www/html --allow-root
wp plugin install root-relative-urls --path=/var/www/html --allow-root
wp plugin activate root-relative-urls --path=/var/www/html --allow-root
chown -R www-data. /var/www/html
rm -f /var/www/html/index.nginx-debian.html
/etc/init.d/nginx restart
printf "Setup complete!!\n===WP-ADMIN LOGIN INFORMATION===\nUser: admin\nPass: password"
printf "\n When ready to migrate your site simply run the following command from the current directory: vagrant ssh"
printf "\n once you have logged in, run: ngrok 80"
printf "\n (please note that you will need to leave the terminal window open when running the migration using the url provided after running the previous command. Use the ouput url to log in to wp-admin before using the plugin.)"

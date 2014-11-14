from base/arch

#install this shit!
run pacman -Sy
run pacman -Sq --noconfirm --noprogressbar nginx php php-fpm php-gd php-xcache php-pear php-intl mediawiki imagemagick supervisor gcc-libs libpng


#config files
add supervisor_nginx.ini /etc/supervisor.d/nginx.ini
add supervisor_php.ini /etc/supervisor.d/php.ini
add mediawiki.conf /etc/nginx/mediawiki.conf
add nginx.conf /etc/nginx/nginx.conf

#prepare supervisord
run sed -i 's/nodaemon=false/nodaemon=true/' /etc/supervisord.conf

#prepare php.ini
run sed -i 's/;extension=gd.so/extension=gd.so/' /etc/php/php.ini
run sed -i 's/;extension=intl.so/extension=intl.so/' /etc/php/php.ini
run sed -i 's/;extension=mysqli.so/extension=mysqli.so/' /etc/php/php.ini
run sed -i 's/;extension=xcache.so/extension=xcache.so/' /etc/php/php.ini


#working data
run mkdir /data
#run ln -s /data/LocalSettings.php /usr/share/webapps/mediawiki/LocalSettings.php
add LocalSettings.php /usr/share/webapps/mediawiki/LocalSettings.php
run rm -rf /usr/share/webapps/mediawiki/images
#run ln -s /data/images /usr/share/webapps/mediawiki/images


#download plugins
add https://extdist.wmflabs.org/dist/ConfirmEdit-REL1_23-486d6eb.tar.gz /src/ConfirmEdit.tar.gz
add https://extdist.wmflabs.org/dist/ImageMap-REL1_23-1f17b01.tar.gz /src/ImageMap.tar.gz
add https://extdist.wmflabs.org/dist/ParserFunctions-REL1_23-e4a11db.tar.gz /src/ParserFunctions.tar.gz

run tar -xzf /src/ConfirmEdit.tar.gz -C /usr/share/webapps/mediawiki/extensions
run tar -xzf /src/ImageMap.tar.gz -C /usr/share/webapps/mediawiki/extensions 
run tar -xzf /src/ParserFunctions.tar.gz -C /usr/share/webapps/mediawiki/extensions


expose 80
cmd "/usr/bin/supervisord -c /etc/supervisord.conf"

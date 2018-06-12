from base/archlinux

#install
run pacman -Syyu
run pacman -Sq --noconfirm --noprogressbar coreutils nginx php php-fpm php-gd php-intl mediawiki imagemagick supervisor gcc-libs libpng unzip wget

#config files
add supervisor_nginx.ini /etc/supervisor.d/nginx.ini
add supervisor_php.ini /etc/supervisor.d/php.ini
add mediawiki.conf /etc/nginx/mediawiki.conf
add nginx.conf /etc/nginx/nginx.conf

#prepare supervisord
run sed -i 's/nodaemon=false/nodaemon=true/' /etc/supervisord.conf

#prepare php.ini
run sed -i 's/;extension=gd/extension=gd/' /etc/php/php.ini
run sed -i 's/;extension=intl/extension=intl/' /etc/php/php.ini
run sed -i 's/;extension=mysqli/extension=mysqli/' /etc/php/php.ini
run sed -i 's/;extension=xcache/extension=xcache/' /etc/php/php.ini
run sed -i 's/;extension=iconv/extension=iconv/' /etc/php/php.ini
run sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 10M/' /etc/php/php.ini
run sed -i 's/post_max_size = 8M/post_max_size = 10M/' /etc/php/php.ini

#working data
run rm -rf /usr/share/webapps/mediawiki/images
add favicon.ico /usr/share/webapps/mediawiki/favicon.ico

#download plugins
ADD extension_dl /usr/local/bin/

RUN extension_dl ConfirmEdit
RUN extension_dl ImageMap
RUN extension_dl ParserFunctions

expose 80
cmd ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]

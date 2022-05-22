FROM williansebastiao/php:7.4

WORKDIR /var/www/app
USER root
COPY /config/supervisord.conf /etc/supervisord.conf
RUN chmod -R 755 /var/log
CMD ["supervisord", "-c", "/etc/supervisord.conf"]
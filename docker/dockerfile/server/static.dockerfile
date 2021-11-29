FROM nginx:latest
COPY /config/static/default.conf /etc/nginx/conf.d/default.conf
COPY . /var/www/app
WORKDIR /var/www/app
EXPOSE 80
ENTRYPOINT ["nginx"]
CMD ["-g", "daemon off;"]
FROM nginx:latest
COPY /nginx/static.conf /etc/nginx/conf.d/default.conf
COPY . /var/www/app
WORKDIR /var/www/app
EXPOSE 80
ENTRYPOINT ["nginx"]
CMD ["-g", "daemon off;"]
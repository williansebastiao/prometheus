FROM nginx:latest

RUN apt-get update && apt-get install -y \
    nano \
    vim \
    make \
    sudo

COPY /nginx/default.conf /etc/nginx/conf.d/default.conf
COPY . /var/www/app
WORKDIR /var/www/app
EXPOSE 80
ENTRYPOINT ["nginx"]
CMD ["-g", "daemon off;"]
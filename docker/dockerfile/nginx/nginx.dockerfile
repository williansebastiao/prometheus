FROM nginx:latest

# CONFIG NGINX
COPY /conf/default.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
ENTRYPOINT ["nginx"]
CMD ["-g", "daemon off;"]
FROM nginx:latest

COPY ./config/nginx.conf /etc/nginx/nginx.conf
COPY ./config/ssl.conf /etc/nginx/ssl.conf
COPY ./config/error.conf /etc/nginx/error.conf
COPY ./static_websites /static_websites

EXPOSE 80 443

# Not needed apparentlyni
CMD ["nginx", "-g", "daemon off;"]

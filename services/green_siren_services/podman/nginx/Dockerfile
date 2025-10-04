FROM nginx:latest

COPY ./config/nginx.conf /etc/nginx/nginx.conf
COPY ./config/ssl.conf /etc/nginx/ssl.conf
COPY ./config/error.conf /etc/nginx/error.conf
COPY ./static_websites /static_websites
# forward request and error logs to docker log collector
# RUN ln -sf /dev/stdout /var/log/nginx/access.log
# RUN ln -sf /dev/stderr /var/log/nginx/error.log

# RUN wget "https://gitlab.com/client-projects19/client-projects/ticket-frontend/-/releases/permalink/latest/downloads/www.tar.gz&job_token=$CI_JOB_TOKEN" -O /tmp/www.tar.gz
# RUN tar -xzf /tmp/www.tar.gz -C /usr/share/nginx/html/
# RUN rm /tmp/www.tar.gz

EXPOSE 80 443

# Not needed apparentlyni
CMD ["nginx", "-g", "daemon off;"]

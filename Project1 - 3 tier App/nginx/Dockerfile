FROM nginx:alpine
COPY nginx.conf /etc/nginx/nginx.conf
COPY generate-ssl.sh /usr/local/bin/generate-ssl.sh
RUN chmod +x /usr/local/bin/generate-ssl.sh && /usr/local/bin/generate-ssl.sh

FROM nginx
WORKDIR /usr/share/nginx/html/
COPY index.html .
RUN apt-get update && apt-get install -y apache2
EXPOSE 80
CMD [ "nginx","-g", "daemon off:" ]

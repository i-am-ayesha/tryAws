FROM nginx
WORKDIR /usr/share/nginx/html/
COPY index.html .
RUN apache2 install
EXPOSE 80
CMD [ "nginx","-g", "daemon off:" ]

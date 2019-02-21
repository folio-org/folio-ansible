FROM nginx:stable-alpine

COPY output /usr/share/nginx/html
COPY yarn.lock *install.json /usr/share/nginx/html/
COPY nginx.conf /etc/nginx/conf.d/default.conf

FROM nginx:stable-alpine

# Copy the static website into the directory served by Nginx
COPY index.html style.css /usr/share/nginx/html/

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]

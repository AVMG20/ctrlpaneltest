FROM nginx:alpine

# Copy nginx configuration
COPY nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf

# Copy Laravel public directory
COPY . /var/www/html

RUN chown -R nginx:nginx /var/www/html
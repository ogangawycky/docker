# container id
CONTAINER_ID=$(docker ps -aqf "name=php-apache")

docker exec -w /var/www/html/app -it ${CONTAINER_ID} bash

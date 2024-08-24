# main image
FROM php:8.2-apache

# installing php extensions
RUN curl -sSLf \
        -o /usr/local/bin/install-php-extensions \
        https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions && \
    chmod +x /usr/local/bin/install-php-extensions &&  \
    IPE_GD_WITHOUTAVIF=1 install-php-extensions bcmath exif gd intl pdo_pgsql zip

# installing composer
COPY --from=composer:2.7.7 /usr/bin/composer /usr/local/bin/composer

# arguments
ARG container_project_path
ARG uid
ARG user

# setting work directory
WORKDIR $container_project_path

# adding user
RUN useradd -G www-data,root -u $uid -d /home/$user $user
RUN mkdir -p /home/$user/.composer && \
    chown -R $user:$user /home/$user

# setting apache
COPY ./.configs/apache.conf /etc/apache2/sites-available/000-default.conf
RUN a2enmod rewrite

# setting up project from `src` folder
RUN chmod -R 775 $container_project_path
RUN chown -R $user:www-data $container_project_path

# changing user
USER $user

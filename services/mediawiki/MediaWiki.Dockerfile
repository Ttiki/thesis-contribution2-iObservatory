FROM mediawiki:1.43

WORKDIR /var/www/html

ARG http_proxy
ARG https_proxy
ARG HTTP_PROXY
ARG HTTPS_PROXY

RUN echo 'Acquire::http::Proxy "http://cache.univ-pau.fr:3128";' > /etc/apt/apt.conf.d/80proxy \
 && echo 'Acquire::https::Proxy "http://cache.univ-pau.fr:3128";' >> /etc/apt/apt.conf.d/80proxy \
 && apt-get update \
 && apt-get install -y --no-install-recommends \
      unzip \
      libzip-dev \
      libpq-dev \
      wget \
      vim \
 && docker-php-ext-install zip pdo_pgsql pgsql \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 && rm -f /etc/apt/apt.conf.d/80proxy
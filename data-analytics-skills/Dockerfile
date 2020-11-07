FROM rocker/rstudio:latest

WORKDIR /home/

RUN apt update -y \
    && apt upgrade -y \
    && DEBIAN_FRONTEND="noninteractive" TZ="America" \
        apt install -y --no-install-recommends \
        wget \
        python3-pip \
        python3-dev \
        python-dev \
        zip \
        unzip \
        default-jdk \
        curl \
        nano \
        git \
        libxml2-dev \
        libcairo2-dev \
        libsqlite3-dev \
        libmariadbd-dev \
        libpq-dev \
        libssh2-1-dev \
        unixodbc-dev \
        libcurl4-openssl-dev \
        libssl-dev \
        libmagick++-dev

COPY ./scripts/packages.R ./

RUN R -e "source('packages.R')"

CMD [ "/bin/bash" ]

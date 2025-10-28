# 1. Use an official, but EOL, image.
# This is php 7.3 on Debian 9 ("Stretch"), EOL July 2022.
FROM php:7.3-apache-stretch

# 2. NEW: Fix apt repositories to point to the Debian Archive
# This is required because Debian 9 (stretch) is EOL.
RUN sed -i 's/deb.debian.org/archive.debian.org/g' /etc/apt/sources.list && \
    sed -i 's/security.debian.org/archive.debian.org/g' /etc/apt/sources.list && \
    # We must also remove the stretch-updates source, which doesn't exist in the archive
    sed -i '/stretch-updates/d' /etc/apt/sources.list

# 3. Install wget and java (for log4j)
RUN apt-get update && \
    apt-get install -y --allow-unauthenticated \
    wget \
    default-jre-headless \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 4. Manually add a specific, famously vulnerable library (Log4j 2.14.1)
RUN wget https://archive.apache.org/dist/logging/log4j/2.14.1/apache-log4j-2.14.1-bin.tar.gz -P /tmp && \
    tar -xzf /tmp/apache-log4j-2.14.1-bin.tar.gz -C /opt/ && \
    ln -s /opt/apache-log4j-2.14.1-bin/log4j-core-2.14.1.jar /usr/lib/log4j-core.jar && \
    rm /tmp/apache-log4j-2.14.1-bin.tar.gz

# 5. (Optional) Add a dummy index file
RUN echo "This is a vulnerable test server (PHP 7.3, Debian 9)" > /var/www/html/index.html

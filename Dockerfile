# 1. Use an EOL Ubuntu image
# Ubuntu 16.04 (Xenial) went EOL in April 2021.
FROM ubuntu:16.04

# 2. NEW: Update apt sources to point to old-releases
# This is required because xenial is EOL and its repos have moved.
RUN sed -i -e 's/archive.ubuntu.com/old-releases.ubuntu.com/g' \
           -e 's/security.ubuntu.com/old-releases.ubuntu.com/g' \
           /etc/apt/sources.list

# 3. Install old packages
RUN apt-get update && \
    # Add 'ca-certificates' (for HTTPS PPAs) and 'software-properties-common' (for add-apt-repository)
    apt-get install -y software-properties-common ca-certificates && \
    # Add an old PHP repo to get php7.0
    add-apt-repository -y ppa:ondrej/php && \
    apt-get update && \
    apt-get install -y \
    apache2 \
    php7.0 \
    php7.0-cli \
    curl \
    wget \
    libssl1.0.0 \
    openssl \
    bash \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# 4. Manually add a specific, famously vulnerable library (Log4j 2.14.1)
RUN wget https://archive.apache.org/dist/logging/log4j/2.14.1/apache-log4j-2.14.1-bin.tar.gz -P /tmp && \
    tar -xzf /tmp/apache-log4j-2.14.1-bin.tar.gz -C /opt/ && \
    ln -s /opt/apache-log4j-2.14.1-bin/log4j-core-2.14.1.jar /usr/lib/log4j-core.jar && \
    rm /tmp/apache-log4j-2.14.1-bin.tar.gz

# 5. Add a dummy file for the web server
RUN echo "This is a vulnerable test server" > /var/www/html/index.html

# 6. Set a default command to run the vulnerable web server
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]

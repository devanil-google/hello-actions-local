# 1. Use an EOL Ubuntu image
# Ubuntu 16.04 (Xenial) went EOL in April 2021.
FROM ubuntu:16.04

# 2. Install old packages (PHP 7.0 instead of 5, but still very old)
RUN apt-get update && \
    # Add 'software-properties-common' to get 'add-apt-repository'
    apt-get install -y software-properties-common && \
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
    && apt-get clean

# 3. Manually add a specific, famously vulnerable library (Log4j 2.14.1)
RUN wget https://archive.apache.org/dist/logging/log4j/2.14.1/apache-log4j-2.14.1-bin.tar.gz -P /tmp && \
    tar -xzf /tmp/apache-log4j-2.14.1-bin.tar.gz -C /opt/ && \
    ln -s /opt/apache-log4j-2.14.1-bin/log4j-core-2.14.1.jar /usr/lib/log4j-core.jar && \
    rm /tmp/apache-log4j-2.14.1-bin.tar.gz

# 4. Add a dummy file for the web server
RUN echo "This is a vulnerable test server" > /var/www/html/index.html

# 5. Set a default command to run the vulnerable web server
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]

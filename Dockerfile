# 1. Use an old, end-of-life base image
# Debian 8 (Jessie) went EOL in June 2020.
# Its repositories are frozen with old, vulnerable packages.
FROM debian:8

# 2. Install a batch of old, vulnerable services and libraries
# We intentionally suppress warnings and force 'yes' to get everything installed.
RUN apt-get update && \
    apt-get install -y --force-yes \
    apache2 \
    php5 \
    php5-cli \
    curl \
    wget \
    libssl1.0.0 \
    openssl \
    bash \
    && apt-get clean

# 3. Manually add a specific, famously vulnerable library (Log4j 2.14.1)
# This version is vulnerable to Log4Shell (CVE-2021-44228).
RUN wget https://archive.apache.org/dist/logging/log4j/2.14.1/apache-log4j-2.14.1-bin.tar.gz -P /tmp && \
    tar -xzf /tmp/apache-log4j-2.14.1-bin.tar.gz -C /opt/ && \
    ln -s /opt/apache-log4j-2.14.1-bin/log4j-core-2.14.1.jar /usr/lib/log4j-core.jar && \
    rm /tmp/apache-log4j-2.14.1-bin.tar.gz

# 4. Add a dummy file for the web server
RUN echo "This is a vulnerable test server" > /var/www/html/index.html

# 5. Set a default command to run the vulnerable web server
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]

# Simple base image
FROM alpine:3.20

# Add a dummy file or message
RUN echo "Hello from a minimal container" > /hello.txt

# Set a default command
CMD ["cat", "/hello.txt"]

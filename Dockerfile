# Use a light base
FROM alpine:latest

# Install nmap and libcap for non-root permissions
RUN apk add --no-cache nmap libcap

# Create a non-root user
RUN addgroup -S nmapgroup && adduser -S nmapuser -G nmapgroup

# Grant nmap the ability to use raw sockets (required for -sS, -O, etc.) 
# without needing to be the root user inside the container.
RUN setcap cap_net_raw,cap_net_admin,cap_net_bind_service+eip /usr/bin/nmap

# Switch to the non-root user
USER nmapuser

# Set the working directory
WORKDIR /home/nmapuser

# Set nmap as the entrypoint
ENTRYPOINT ["nmap"]
# https://hub.docker.com/_/alpine
FROM alpine:latest

# 1. Install runtime dependencies and libcap for non-root permissions
RUN apk add --update --no-cache \
            ca-certificates \
            libgcc libstdc++ \
            libcrypto3 libssl3 \
            libpcap \
            libssh2 \
            lua5.4-libs \
            zlib \
            libcap \
 && update-ca-certificates \
 && rm -rf /var/cache/apk/*

# 2.Install Nmap from package manager (latest version available in Alpine repositories)
RUN apk add --update --no-cache nmap

# 3. Security Hardening: Grant raw socket capabilities & Create non-root user [cite: 1, 2]
# This allows the non-root user to perform SYN scans (-sS) and OS detection (-O)
RUN setcap cap_net_raw,cap_net_admin,cap_net_bind_service+eip /usr/bin/nmap \
 && addgroup -S nmapgroup && adduser -S nmapuser -G nmapgroup

# 4. Final Environment Setup
USER nmapuser
WORKDIR /home/nmapuser

ENTRYPOINT ["/usr/bin/nmap"]
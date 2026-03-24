The container is not working yet.

A lightweight, secure, and automated **Nmap** container image built on Alpine Linux. This project is designed to run Nmap without requiring root privileges on your host OS while supporting both Intel and Apple Silicon (M1/M2/M3) Macs.

## 🚀 Key Features

  * **Multi-Arch Support:** Native builds for `linux/amd64` (Intel/AMD) and `linux/arm64` (Apple Silicon).
  * **Rootless Execution:** The container runs as a non-privileged `nmapuser` by default.
  * **Automated Updates:** Rebuilds every Sunday at midnight to ensure the latest Alpine security patches and Nmap versions.
  * **Security First:** Every build is scanned with **Trivy** for vulnerabilities. The build will fail if High or Critical vulnerabilities are detected.
  * **Small Footprint:** Based on Alpine Linux to keep the image size under 20MB.

## 🛠 Usage

Since the image is hosted on **GitHub Container Registry (GHCR)**, you can run it without manually downloading anything first.

### Basic Scan

```bash
docker run --rm ghcr.io/zerofai/nmap-container:latest <target>
```

### Advanced Scans (SYN, OS Detection)

Nmap requires specific network capabilities for stealth scans (`-sS`) or OS fingerprinting (`-O`). Even though the container runs as a non-root user, you can grant it just the necessary permissions from the host:

```bash
docker run --rm --cap-add=NET_RAW ghcr.io/zerofai/nmap-container:latest -sS <target>
```

-----

## 🏗 Build & Automation

The workflow in this repository automates the entire lifecycle:

1.  **Trigger:** Runs on a `cron` schedule (Weekly) or manual dispatch.
2.  **Lint/Scan:** Checks the Dockerfile and dependencies.
3.  **Vulnerability Scan:** Uses `aquasecurity/trivy` to ensure the image is safe.
4.  **Multi-Arch Build:** Uses `docker/build-push-action` with `QEMU` to build for both x64 and ARM64.
5.  **Publish:** Pushes the final image to `ghcr.io`.

## 🔒 Security Policy

This image uses `libcap` to grant the `cap_net_raw` capability specifically to the `nmap` binary inside the container. This allows the tool to function correctly while the process itself runs as a non-root user (`nmapuser`), significantly reducing the attack surface.

-----

## 📝 License

This project is open-source and available under the [Apache 2.0 License]
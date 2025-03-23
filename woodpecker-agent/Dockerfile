FROM woodpeckerci/woodpecker-agent:v3.4.0 AS woodpecker-agent
FROM woodpeckerci/plugin-git:2.6.2 AS woodpecker-plugin-git
FROM woodpeckerci/plugin-s3:1.3.2 AS woodpecker-plugin-s3

FROM ubuntu:22.04

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
      git \
      git-lfs \
      gcc \
      libc6-dev \
      wget \
      pkg-config \
      libusb-1.0-0-dev \
      libftdi1-dev \
      libudev-dev \
      libssl-dev \
      python3 \
      pipx \
      # Saleae Logic2 dependencies
      xvfb \
      libatk1.0-0 \
      libatk-bridge2.0-0 \
      libgtk-3-0 \
      libgbm1 \
      libfuse2 \
      libnss3 \
      libasound2

# Set up the Woodpecker Agent and the Git plugin
COPY --from=woodpecker-agent /bin/woodpecker-agent /bin/woodpecker-agent
COPY --from=woodpecker-agent /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=woodpecker-plugin-git /bin/plugin-git /bin/plugin-git
COPY --from=woodpecker-plugin-s3 /bin/plugin-s3 /bin/plugin-s3

# Set up the Rust environment
ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH \
    RUST_VERSION=1.85.1

RUN set -eux; \
    dpkgArch="$(dpkg --print-architecture)"; \
    case "${dpkgArch##*-}" in \
        amd64) rustArch='x86_64-unknown-linux-gnu'; rustupSha256='0b2f6c8f85a3d02fde2efc0ced4657869d73fccfce59defb4e8d29233116e6db' ;; \
        armhf) rustArch='armv7-unknown-linux-gnueabihf'; rustupSha256='f21c44b01678c645d8fbba1e55e4180a01ac5af2d38bcbd14aa665e0d96ed69a' ;; \
        arm64) rustArch='aarch64-unknown-linux-gnu'; rustupSha256='673e336c81c65e6b16dcdede33f4cc9ed0f08bde1dbe7a935f113605292dc800' ;; \
        i386) rustArch='i686-unknown-linux-gnu'; rustupSha256='e7b0f47557c1afcd86939b118cbcf7fb95a5d1d917bdd355157b63ca00fc4333' ;; \
        *) echo >&2 "unsupported architecture: ${dpkgArch}"; exit 1 ;; \
    esac; \
    url="https://static.rust-lang.org/rustup/archive/1.26.0/${rustArch}/rustup-init"; \
    wget "$url"; \
    echo "${rustupSha256} *rustup-init" | sha256sum -c -; \
    chmod +x rustup-init; \
    ./rustup-init -y --no-modify-path --profile minimal --default-toolchain $RUST_VERSION --default-host ${rustArch}; \
    rm rustup-init; \
    chmod -R a+w $RUSTUP_HOME $CARGO_HOME; \
    rustup --version; \
    cargo --version; \
    rustc --version;

RUN rustup self update
RUN rustup update stable
RUN rustup target add thumbv6m-none-eabi

# Install tool for installing Rust binaries
RUN wget -O- "https://github.com/cargo-bins/cargo-binstall/releases/latest/download/cargo-binstall-x86_64-unknown-linux-gnu.tgz" | tar -xvz -C /usr/local/cargo/bin

# Install tool for flashing the RPI targets
RUN cargo binstall --no-confirm probe-rs-tools

# Speed up the builds by caching them
RUN cargo binstall --no-confirm sccache
ENV RUSTC_WRAPPER=/usr/local/cargo/bin/sccache

# Set up the Saleae Logic2 application
RUN cd /opt && wget "https://downloads.saleae.com/logic2/Logic-2.4.13-linux-x64.AppImage" -O Logic2 && chmod +x Logic2

# Install Poetry for Python dependency management
RUN pipx install poetry
ENV PATH=$PATH:/root/.local/bin

HEALTHCHECK CMD ["/bin/woodpecker-agent", "ping"]
COPY startup.sh /bin/startup.sh
ENTRYPOINT ["/bin/startup.sh"]

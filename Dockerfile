# Debian 14 stable (Forky)
FROM debian:forky

# Disable systemd check
ENV container=docker
ENV DEBIAN_FRONTEND=noninteractive
ENV CCACHE_DIR=/root/.ccache
ENV PATH=/usr/lib/ccache:${PATH}

# Install dependencies
RUN apt-get update && apt-get install -y \
    git curl ninja-build gettext cmake unzip build-essential \
    libtool libtool-bin autoconf automake pkg-config \
    python3 python3-pip ccache jq ca-certificates \
 && curl -fsSL https://deb.nodesource.com/setup_26.x | bash - \
 && apt-get install -y nodejs \
 && apt-get clean \
 && apt-get autoremove -y \
 && rm -rf /var/lib/apt/lists/*

# Build Neovim
ARG NEOVIM_VERSION
RUN git clone --depth 1 --branch ${NEOVIM_VERSION} https://github.com/neovim/neovim.git /neovim

WORKDIR /neovim
RUN make CMAKE_BUILD_TYPE=Release CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=/nvim-arm64"
RUN make install

# Package release
WORKDIR /
RUN tar -czf nvim-arm64.tar.gz nvim-arm64 && sha256sum nvim-arm64.tar.gz > sha256.txt
RUN mkdir /release && cp nvim-arm64.tar.gz /release/ && cp sha256.txt /release/

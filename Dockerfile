# ========================
# Stage 1: Builder
# ========================
FROM debian:forky-slim AS builder

ENV container=docker
ENV DEBIAN_FRONTEND=noninteractive
ENV CCACHE_DIR=/root/.ccache
ENV PATH=/usr/lib/ccache:${PATH}

RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    curl \
    ninja-build \
    gettext \
    cmake \
    unzip \
    build-essential \
    libtool \
    libtool-bin \
    autoconf \
    automake \
    pkg-config \
    python3 \
    python3-pip \
    ccache \
    jq \
    ca-certificates \
 && curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
 && apt-get install -y --no-install-recommends nodejs \
 && apt-get clean \
 && apt-get autoremove -y \
 && rm -rf /var/lib/apt/lists/*

ARG NEOVIM_VERSION

RUN git clone \
    --depth 1 \
    --branch ${NEOVIM_VERSION} \
    https://github.com/neovim/neovim.git \
    /neovim

WORKDIR /neovim

RUN make \
    CMAKE_BUILD_TYPE=Release \
    CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=/nvim-arm64"

RUN make install

WORKDIR /

RUN tar -czf nvim-arm64.tar.gz nvim-arm64 \
 && sha256sum nvim-arm64.tar.gz > sha256.txt


# ========================
# Stage 2: Final
# ========================
FROM scratch

COPY --from=builder /nvim-arm64.tar.gz /
COPY --from=builder /sha256.txt /

FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y \
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
 && rm -rf /var/lib/apt/lists/*

ENV CCACHE_DIR=/root/.ccache
ENV PATH="/usr/lib/ccache:${PATH}"

ARG NEOVIM_VERSION=v0.12.2

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

RUN tar -czf nvim-arm64.tar.gz nvim-arm64

RUN sha256sum nvim-arm64.tar.gz > sha256.txt

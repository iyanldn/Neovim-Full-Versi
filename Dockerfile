FROM ubuntu:22.04

# Install dependencies
RUN apt update && apt install -y \
  git curl ninja-build gettext cmake unzip build-essential \
  libtool libtool-bin autoconf automake pkg-config \
  python3-pip nodejs npm ccache jq

ENV CCACHE_DIR=/root/.ccache
ENV PATH="/usr/lib/ccache:$PATH"

# Clone Neovim (version lewat ARG)
ARG NEOVIM_VERSION=v0.11.4
RUN git clone --depth 1 --branch ${NEOVIM_VERSION} https://github.com/neovim/neovim.git /neovim

# Build & Install
RUN cd /neovim && make -j2 CMAKE_BUILD_TYPE=Release \
  CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=/nvim-arm64" \
  && make install

# Package hasil build
RUN cd / && tar -czvf nvim-arm64.tar.gz nvim-arm64 \
  && sha256sum nvim-arm64.tar.gz > sha256.txt

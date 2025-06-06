FROM ubuntu:22.04

ARG NVIM_VERSION=v0.12.1

# Install build deps
RUN apt update && apt install -y \
  git curl ninja-build gettext cmake unzip build-essential \
  libtool libtool-bin autoconf automake pkg-config \
  python3-pip nodejs npm

# Clone Neovim
RUN git clone --depth 1 --branch ${NVIM_VERSION} https://github.com/neovim/neovim.git /neovim

# Build & Install
RUN cd /neovim && make CMAKE_BUILD_TYPE=Release \
  CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=/nvim-arm64" && make install

# Archive
RUN cd / && tar -czvf nvim-arm64.tar.gz nvim-arm64 && sha256sum nvim-arm64.tar.gz > sha256.txt

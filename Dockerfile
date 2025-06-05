FROM ubuntu:22.04

LABEL maintainer="you@example.com"
LABEL version="0.10.0"
LABEL description="Build Neovim v0.10.0 ARM64 on Ubuntu 22.04"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y \
  git ninja-build gettext cmake unzip curl build-essential \
  libtool libtool-bin autoconf automake pkg-config tar ca-certificates \
  && apt clean

WORKDIR /nvim-build

RUN curl -L https://github.com/neovim/neovim/archive/refs/tags/v0.10.0.tar.gz -o neovim.tar.gz && \
    tar -xzf neovim.tar.gz && rm neovim.tar.gz

WORKDIR /nvim-build/neovim-0.10.0

RUN make CMAKE_BUILD_TYPE=Release CMAKE_INSTALL_PREFIX=/nvim-arm64 -j$(nproc) && \
    make install

WORKDIR /nvim-build
RUN mkdir -p /nvim-arm64/share/nvim && cp -r neovim-0.10.0/runtime /nvim-arm64/share/nvim

RUN tar -czf nvim-arm64.tar.gz nvim-arm64 && sha256sum nvim-arm64.tar.gz > sha256.txt

CMD echo "✅ Build complete"

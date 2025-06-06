FROM ubuntu:22.04

# Install dependencies
RUN apt update && apt install -y \
  git curl ninja-build gettext cmake unzip build-essential \
  libtool libtool-bin autoconf automake pkg-config \
  python3-pip nodejs npm

# Clone Neovim
RUN git clone https://github.com/neovim/neovim.git /neovim \
  && cd /neovim && git checkout stable

# Build Neovim
RUN cd /neovim && make CMAKE_BUILD_TYPE=Release \
  CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=/nvim-arm64" \
  && make install

# Package result
RUN cd / && tar -czvf nvim-arm64.tar.gz nvim-arm64 \
  && sha256sum nvim-arm64.tar.gz > sha256.txt

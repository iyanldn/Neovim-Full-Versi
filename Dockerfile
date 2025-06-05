FROM ubuntu:22.04

# ⏱️ Metadata
LABEL maintainer="iyanldn"
LABEL version="0.10.0"
LABEL description="Neovim ARM64 Builder"

# ✅ Install deps
RUN apt update && apt install -y \
  git ninja-build gettext cmake unzip curl \
  build-essential libtool libtool-bin autoconf \
  automake pkg-config tar coreutils \
  && apt clean

# 📂 Workspace
WORKDIR /build

# 📥 Download & Extract Neovim
RUN curl -L https://github.com/neovim/neovim/archive/refs/tags/v0.10.0.tar.gz -o neovim.tar.gz && \
    tar -xzf neovim.tar.gz && \
    mv neovim-0.10.0 neovim

# ⚙️ Build
WORKDIR /build/neovim
RUN make CMAKE_BUILD_TYPE=Release CMAKE_INSTALL_PREFIX=/nvim-arm64 -j2 && make install

# 📁 Copy runtime
RUN mkdir -p /nvim-arm64/share/nvim && cp -r runtime /nvim-arm64/share/nvim

# 📦 Archive
WORKDIR /
RUN tar -czf nvim-arm64.tar.gz nvim-arm64 && sha256sum nvim-arm64.tar.gz > sha256.txt

CMD echo "✅ Build complete"

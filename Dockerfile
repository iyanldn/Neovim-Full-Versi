FROM ubuntu:22.04

RUN apt update && apt install -y \
    curl git unzip wget ripgrep fd-find neovim python3-pip nodejs npm     && pip3 install neovim     && npm install -g neovim

COPY . /root/.config/nvim

WORKDIR /root

CMD [ "nvim" ]

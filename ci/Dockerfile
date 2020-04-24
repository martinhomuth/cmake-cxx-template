FROM ubuntu:eoan-20200207

RUN apt-get update \
 && apt-get install -y sudo locales vim emacs \
    build-essential cmake clang-format clang-tidy \
    libgtest-dev libgmock-dev \
    pkgconf libarchive-dev libssl-dev libjansson-dev \
    git-core doxygen graphviz gcovr \
 && rm -rf /var/lib/apt/lists/*

ARG UID=1000
ARG GID=1000
ARG USER=ci

RUN locale-gen en_US.UTF-8 \
 && groupadd -g $GID -o $USER \
 && useradd -m -u $UID -g $GID -o -s /bin/bash $USER \
 && echo "$USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER $USER
ENV LC_ALL=en_US.UTF-8

CMD /bin/bash

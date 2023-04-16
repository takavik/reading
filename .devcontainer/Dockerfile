FROM mcr.microsoft.com/devcontainers/base:debian

RUN apt update 
RUN apt install -y gcc gdb
RUN apt install -y libglib2.0-0 libfontconfig1 libcairo2 libpango1.0-0 libjpeg62 libgtk2.0-0 xvfb
RUN apt install -y gdb-multiarch qemu-system-misc gcc-riscv64-linux-gnu binutils-riscv64-linux-gnu 
RUN wget https://download.racket-lang.org/installers/8.8/racket-8.8-x86_64-linux-cs.sh && \
    echo | sh racket-8.8-x86_64-linux-cs.sh --unix-style --create-dir && \
    echo a | raco pkg install --installation racket-langserver fmt relation-lib

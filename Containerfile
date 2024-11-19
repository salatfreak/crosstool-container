# base image with dependencies
FROM docker.io/debian:12.8-slim AS base

# install dependencies
RUN apt-get update && apt-get install -y \
  wget xz-utils build-essential flex texinfo unzip \
  help2man file gawk libtool-bin bison libncurses-dev \
  && rm -rf /var/lib/apt/lists/*

# image for building crosstool-ng and custom strip binary
FROM base AS build

# software versions
ARG CT_VERSION="1.26.0"
ARG BU_VERSION="2.43.1"

# download and extract sources
RUN wget -qO- https://github.com/crosstool-ng/crosstool-ng/releases/download/crosstool-ng-${CT_VERSION}/crosstool-ng-${CT_VERSION}.tar.xz \
  | tar -xJ

RUN wget -qO- https://ftp.gnu.org/gnu/binutils/binutils-${BU_VERSION}.tar.xz \
  | tar -xJ

# configure, build, and install crosstool
RUN \
  cd crosstool-ng-${CT_VERSION} && \
  ./configure --prefix=/usr/local && \
  make && make install

# configure, build, and install strip from binutils
RUN \
  cd binutils-${BU_VERSION} && \
  for lib in libsframe libiberty zlib; do \
    cd $lib && ./configure && make && cd ..; \
  done && \
  cd bfd && \
  ./configure --enable-targets=arm-elf,avr-elf,mips-elf,ppc-elf,riscv-elf && \
  make && cd .. && \
  cd binutils && ./configure && make strip-new && \
  cp strip-new /usr/local/bin/strip

# image for distribution
FROM base

# copy installation from build image
COPY --from=build /usr/local /usr/local

# set up environment
USER 1000:1000
WORKDIR /build
ENTRYPOINT ["ct-ng"]

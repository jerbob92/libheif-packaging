ARG UBUNTU_VERSION="20.04"
FROM ubuntu:${UBUNTU_VERSION}

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Amsterdam
RUN apt update && apt install software-properties-common build-essential git sudo cmake curl libssl-dev pipx python3-venv libbrotli-dev pkg-config libjpeg-dev libpng-dev libtiff-dev zlib1g-dev automake libtool -y
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"
RUN pipx install cmake
ENV PATH="/root/.local/bin:${PATH}"
ARG LIBHEIF_VERSION="v1.18.2"
RUN git clone --depth 1 -b $LIBHEIF_VERSION https://github.com/strukturag/libheif.git
WORKDIR /libheif
RUN echo "APT::Get::Assume-Yes \"true\";" > /etc/apt/apt.conf.d/90forceyes
ARG WITH_GRAPHICS=1
ARG WITH_RAV1E=0
ENV WITH_RAV1E=$WITH_RAV1E
ARG WITH_DAV1D=0
ENV WITH_DAV1D=$WITH_DAV1D
ARG UBUNTU_VERSION="20.04"
ENV UBUNTU_VERSION=$UBUNTU_VERSION
# For Ubuntu < 24.04, we add the strukturag PPA for aom, libx265 and libde265. From 24.04 onwards the default repositories contain uptodate packages.
RUN if [ "$UBUNTU_VERSION" = "20.04" ] || [ "$UBUNTU_VERSION" = "22.04" ]; then \
    add-apt-repository -y ppa:strukturag/libde265 && \
    add-apt-repository -y ppa:strukturag/libheif; \
  fi; \
  apt update && \
  apt install libaom-dev libx265-dev libde265-0 libde265-dev -y
RUN ./scripts/install-ci-linux.sh
# Added this here so that the install script doesn't install the libheif PPA for Ubuntu 24.04
ENV WITH_AOM=1
ENV WITH_X265=1
ENV WITH_LIBDE265=1
RUN ./scripts/prepare-ci.sh
COPY build.sh ./scripts/build.sh
CMD ["./scripts/build.sh"]

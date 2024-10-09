ARG UBUNTU_VERSION="20.04"
FROM ubuntu:${UBUNTU_VERSION}

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Amsterdam
RUN apt update && apt install software-properties-common build-essential git sudo cmake curl libssl-dev pip libbrotli-dev pkg-config libjpeg-dev libpng-dev libtiff-dev zlib1g-dev -y
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"
RUN pip install --upgrade cmake
ARG LIBHEIF_VERSION="v1.18.2"
RUN git clone --depth 1 -b $LIBHEIF_VERSION https://github.com/strukturag/libheif.git
WORKDIR /libheif
RUN echo "APT::Get::Assume-Yes \"true\";" > /etc/apt/apt.conf.d/90forceyes
ARG WITH_GRAPHICS=0
ENV WITH_GRAPHICS=$WITH_GRAPHICS
ENV WITH_X265=1
ENV WITH_AOM=1
ARG WITH_RAV1E=0
ENV WITH_RAV1E=$WITH_RAV1E
ARG WITH_DAV1D=0
ENV WITH_DAV1D=$WITH_DAV1D
ENV WITH_LIBDE265=1
RUN ./scripts/install-ci-linux.sh
RUN ./scripts/prepare-ci.sh
COPY build.sh ./scripts/build.sh
ARG UBUNTU_VERSION="20.04"
ENV UBUNTU_VERSION=$UBUNTU_VERSION
CMD ["./scripts/build.sh"]

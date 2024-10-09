# Libheif packaging for Ubuntu

This repository is able to compile libheif for Ubuntu 20.04 and Ubuntu 22.04.

Build args:

- `UBUNTU_VERSION` = `20.04` (default) or `22.04`
- `WITH_GRAPHICS` = `0` (default) or `1`
- `LIBHEIF_VERSION` = any valid tag on libheif (default `v1.18.2`)
- `WITH_RAV1E` = `0` (default) or `1`
- `WITH_DAV1D` = `0` (default) or `1`

## Building

```bash
mkdir out
docker run -v ./out:/out -it $(docker build -q .)
```

The resulting build (and deb file) will be in the `dist/out` folder.

## Usage

To use/install the deb file, you will need to do the following:

```bash
sudo apt update && sudo apt install software-properties-common
sudo add-apt-repository ppa:strukturag/libde265
sudo add-apt-repository ppa:strukturag/libheif
sudo apt update && sudo apt install -y libde265-0 libde265-dev \
  libaom-dev libaom3 \
  libx265-179 libx265-dev \
  zlib1g-dev libbrotli-dev \
  libtiff-dev libpng-dev libjpeg-dev

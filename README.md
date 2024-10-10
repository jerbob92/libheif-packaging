# Libheif packaging for Ubuntu

This repository is able to compile libheif for Ubuntu 20.04, 22.04 and 24.04.

Build args:

- `UBUNTU_VERSION` = `20.04` (default), `22.04` or `24.04`
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

Ubuntu 20.04 and 22.04 only:

```bash
sudo apt update && sudo apt install software-properties-common
sudo add-apt-repository ppa:strukturag/libde265
sudo add-apt-repository ppa:strukturag/libheif
```

Then on all versions:

```bash
sudo apt update && sudo apt install -y libde265-dev libaom-dev libx265-dev zlib1g-dev libbrotli-dev libpng-dev libjpeg-dev libtiff-dev --no-install-recommends
```

## Components

Compared to the PPA, this is an all-containing deb file, which means it contains the tools, dev headers and plugins all in one deb file.

Included:

 - Tools (heif-dec, heif-enc, heif-info, heif-test, heif-thumbnailer)
 - gdk-pixbuf loader
 - development headers and pkg-config file
 - aom plugin (encoding and decoding)
 - libde265 plugin (decoding)
 - libx265 plugin (encoding)
 - rav1e plugin (encoding), only when enabled in build, not in pre-built release deb files
 - dav1d plugin (decoding), only when enabled in build, not in pre-built release deb files

# Libheif packaging for Ubuntu

This repository is able to compile libheif for Ubuntu 20.04 and Ubuntu 22.04.

Build args:

- `UBUNTU_VERSION` = `20.04` (default) or `22.04`
- `WITH_GRAPHICS` = `0` (default) or `1`
- `LIBHEIF_VERSION` = any valid tag on libheif (default `v1.18.2`)
- `WITH_RAV1E` = `0` (default) or `1`
- `WITH_DAV1D` = `0` (default) or `1`

## Usage

```bash
mkdir out
docker run -v ./out:/out -it $(docker build -q .)
```

The resulting build (and deb file) will be in the `dist/out` folder.


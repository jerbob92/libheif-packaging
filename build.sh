#!/bin/bash
set -e
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
BUILD_ROOT=$ROOT/..
CURRENT_OS=linux

PKG_CONFIG_PATH=
if [ "$WITH_LIBDE265" = "2" ]; then
    PKG_CONFIG_PATH="$PKG_CONFIG_PATH:$BUILD_ROOT/libde265/dist/lib/pkgconfig/"
fi

if [ "$WITH_RAV1E" = "1" ]; then
    PKG_CONFIG_PATH="$PKG_CONFIG_PATH:$BUILD_ROOT/third-party/rav1e/dist/lib/x86_64-linux-gnu/pkgconfig/"
fi

if [ "$WITH_DAV1D" = "1" ]; then
    PKG_CONFIG_PATH="$PKG_CONFIG_PATH:$BUILD_ROOT/third-party/dav1d/dist/lib/x86_64-linux-gnu/pkgconfig/"
fi

if [ ! -z "$PKG_CONFIG_PATH" ]; then
    export PKG_CONFIG_PATH="$PKG_CONFIG_PATH"
fi

WITH_AVIF_DECODER=
if [ ! -z "$WITH_AOM" ] || [ ! -z "$WITH_DAV1D" ]; then
    WITH_AVIF_DECODER=1
fi
WITH_HEIF_DECODER=
if [ ! -z "$WITH_LIBDE265" ] ; then
    WITH_HEIF_DECODER=1
fi
WITH_AVIF_ENCODER=
WITH_HEIF_ENCODER=
# Need decoded images before encoding.
if [ ! -z "$WITH_AVIF_DECODER" ]; then
    if [ ! -z "$WITH_RAV1E" ]; then
        WITH_AVIF_ENCODER=1
    fi
fi
if [ ! -z "$WITH_HEIF_DECODER" ]; then
    if [ ! -z "$WITH_X265" ] ; then
        WITH_HEIF_ENCODER=1
    fi
fi

echo "Preparing cmake build files ..."

CMAKE_OPTIONS=" --preset=release"

#echo "install prefix: ${BUILD_ROOT}/dist"
#CMAKE_OPTIONS="$CMAKE_OPTIONS -DCMAKE_INSTALL_PREFIX=/out/dist"

# Disable plugins
CMAKE_OPTIONS="$CMAKE_OPTIONS -DWITH_JPEG_DECODER_PLUGIN=OFF -DWITH_JPEG_ENCODER_PLUGIN=OFF -DWITH_LIBSHARPYUV=OFF -DWITH_KVAZAAR=OFF -DWITH_FFMPEG_DECODER=OFF -DWITH_OPENJPH_ENCODER=OFF -DWITH_OpenJPEG_DECODER=OFF -DWITH_OpenJPEG_ENCODER=OFF -DWITH_SvtEnc=OFF"

# turn on warnings-as-errors
CMAKE_OPTIONS="$CMAKE_OPTIONS -DCMAKE_COMPILE_WARNING_AS_ERROR=1"

# Default for 22.04 or higher
PACKAGE_DEPENDS="libde265-0 (>= 1.0.7), libx265-199 (>= 3.5), libaom3 (>= 3.2.0), libc6 (>= 2.34), libgcc-s1 (>= 3.3.1), libstdc++6 (>= 11), zlib1g (>= 1:1.1.4), libbrotli-dev, libjpeg8 (>= 8c)"

if [ "$UBUNTU_VERSION" = "20.04" ]; then
    PACKAGE_DEPENDS="libde265-0 (>= 1.0.7), libx265-179 (>= 3.2), libaom3 (>= 3.3.0), libc6 (>= 2.14), libgcc-s1 (>= 3.0), libstdc++6 (>= 5.2), zlib1g (>= 1:1.1.4), libbrotli-dev, libjpeg8 (>= 8c)"
fi

echo "Building libheif ..."
rm -Rf /out/dist
mkdir -p /out/dist
cd /out/dist
cmake /libheif $CMAKE_OPTIONS
cmake --build .
cpack -D CPACK_DEBIAN_PACKAGE_DEPENDS="${PACKAGE_DEPENDS}" -D CPACK_DEBIAN_PACKAGE_SECTION="libs" -D CPACK_PACKAGE_CONTACT="jeroen@klippa.com" -D CPACK_DEBIAN_PACKAGE_MAINTAINER="Jeroen Bobbeldijk <jeroen@klippa.com>" -D CPACK_DEBIAN_PACKAGE_CONFLICTS="heif-gdk-pixbuf, heif-thumbnailer, libheif-examples, libheif-plugin-aomdec, libheif-plugin-aomenc, libheif-plugin-libde265, libheif1, libheif-dev, libheif-plugin-dav1d, libheif-plugin-ffmpegdec, libheif-plugin-j2kdec, libheif-plugin-j2kenc, libheif-plugin-jpegdec, libheif-plugin-jpegenc, libheif-plugin-rav1e, libheif-plugin-svtenc, libheif-plugin-x265" -G DEB
#make -j $(nproc)

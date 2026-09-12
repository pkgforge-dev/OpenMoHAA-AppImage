#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
    cmake              \
    hicolor-icon-theme \
    libmad             \
    openal             \
    openjpeg2          \
    sdl2-compat

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano libdecor-mini

echo "Building OpenMoHAA..."
echo "---------------------------------------------------------------"
REPO="https://github.com/openmoh/openmohaa"
VERSION="$(git ls-remote "$REPO" HEAD | cut -c 1-9 | head -1)"
git clone --depth 1 "$REPO" ./openmohaa
echo "$VERSION" > ~/version

mkdir -p ./AppDir/bin
cmake -S ./openmohaa -B build \ 
    -D CMAKE_INSTALL_PREFIX=/usr/ \
    -D USE_SYSTEM_LIBS=1 \
    -D CMAKE_BUILD_TYPE=Release
cmake --build build -j$(nproc)
cmake --install build

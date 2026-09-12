#!/bin/sh

set -eu

ARCH=$(uname -m)
export ARCH
export OUTPATH=./dist
export ADD_HOOKS="self-updater.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=https://raw.githubusercontent.com/openmoh/openmohaa/a2f340195975f4f042e28a60b62561dd9a0b2700/misc/openmohaa.svg
export DESKTOP=https://raw.githubusercontent.com/openmoh/openmohaa/refs/heads/main/misc/linux/org.openmoh.openmohaa.desktop.in
export STARTUPWMCLASS=openmohaa
export DEPLOY_OPENGL=1

# Deploy dependencies
quick-sharun ./AppDir/bin/* /usr/lib/libopenal.so*
#echo 'SHARUN_WORKING_DIR=${SHARUN_DIR}/bin' >> ./AppDir/.env
# this app has problems with other locales breaking physics
echo 'LC_ALL=C.UTF-8' >> ./AppDir/.env

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app for 12 seconds, if the test fails due to the app
# having issues running in the CI use --simple-test instead
quick-sharun --simple-test ./dist/*.AppImage

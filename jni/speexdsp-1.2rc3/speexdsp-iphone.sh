#!/bin/sh

VERSION="1.2rc3"
SDKVERSION=`xcrun --sdk iphoneos --show-sdk-version`
LIB="speexdsp"

DEVELOPER=`xcode-select -print-path`
ARCHS="i386 x86_64 armv7 armv7s arm64"
CURRENTPATH=`pwd`
OS_CORE_VERSION=`uname -r`
BUILD="x86_64-apple-darwin${OS_CORE_VERSION}"
OLD_PATH=$PATH
DEPLOYMENT_TARGET="6.0"

# cd ${LIB}-${VERSION}
for ARCH in ${ARCHS}
do
    if [ "$ARCH" = "i386" -o "$ARCH" = "x86_64" ]
    then
        PLATFORM="iPhoneSimulator"
        CFLAGS="$CFLAGS -mios-simulator-version-min=$DEPLOYMENT_TARGET"

        if [ "$ARCH" = "x86_64" ]
        then
            HOST=""
        else
            HOST="i386-apple-darwin${OS_CORE_VERSION}"
        fi
    else
        PLATFORM="iPhoneOS"
        HOST="${ARCH}-apple-darwin${OS_CORE_VERSION}"
        CFLAGS="$CFLAGS -mios-version-min=$DEPLOYMENT_TARGET -fembed-bitcode"

        if [ "$ARCH" = "arm64" ]
        then
            EXPORT="GASPP_FIX_XCODE5=1"
            HOST="aarch64-apple-darwin${OS_CORE_VERSION}"
        fi
    fi
    SDK="${DEVELOPER}/Platforms/${PLATFORM}.platform/Developer/SDKs/${PLATFORM}${SDKVERSION}.sdk"
    # SDK="${DEVELOPER}/Platforms/${PLATFORM}.platform/Developer/SDKs/${PLATFORM}.sdk"
#    export CC="clang -arch ${ARCH} -isysroot ${SDK}"
    export CC="clang"
    export CFLAGS="-arch ${ARCH} -isysroot ${SDK}"
    export CXXFLAGS="$CFLAGS"
    export LDFLAGS="$CFLAGS"
    export LD=$CC
    PREFIX="${CURRENTPATH}/build/${LIB}/${ARCH}"
    mkdir -p ${PREFIX}
    echo "Please stand by..."
    # ./configure --prefix=$PREFIX --host=${HOST} -build=${BUILD} --with-ogg-libraries=${CURRENTPATH}/build/libogg/Fat/lib/ -with-ogg-includes=${CURRENTPATH}/build/libogg/Fat/include
    ./configure --prefix=$PREFIX --host=${HOST} -build=${BUILD}
    make clean
    make && make install
    echo "======== CHECK ARCH ========"
    lipo -info ${PREFIX}/lib/lib${LIB}.a
    echo "======== CHECK DONE ========"
done
echo "== We just need static library == "
echo " == Copy headers to fat folder from i386 folder AND clean files in lib =="
cp -r ${CURRENTPATH}/build/${LIB}/i386/ ${CURRENTPATH}/build/${LIB}/Fat
rm -rf ${CURRENTPATH}/build/${LIB}/Fat/lib/*
echo "Build library - lib${LIB}.a"
lipo -create ${CURRENTPATH}/build/${LIB}/i386/lib/lib${LIB}.a ${CURRENTPATH}/build/${LIB}/x86_64/lib/lib${LIB}.a ${CURRENTPATH}/build/${LIB}/armv7/lib/lib${LIB}.a ${CURRENTPATH}/build/${LIB}/armv7s/lib/lib${LIB}.a ${CURRENTPATH}/build/${LIB}/arm64/lib/lib${LIB}.a -output ${CURRENTPATH}/build/${LIB}/Fat/lib/lib${LIB}.a
echo "======== CHECK FAT ARCH ========"
lipo -info ${CURRENTPATH}/build/${LIB}/Fat/lib/lib${LIB}.a
echo "======== CHECK DONE ========"
echo "== Done =="
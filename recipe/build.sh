#!/bin/bash
set -e -x

# Get meson to find pkg-config when cross compiling
export PKG_CONFIG="${BUILD_PREFIX}/bin/pkg-config"

# Set PREFIX explicitly for installation
export PREFIX_PATH="${PREFIX}"

meson setup builddir \
    ${MESON_ARGS} \
    -Dasm=enabled \
    -Dx11=enabled \
    -Degl=true \
    -Dglx=enabled \
    -Dgles1=true \
    -Dgles2=true \
    -Dtls=true \
    -Ddispatch-tls=true \
    -Dheaders=true \
    --prefix=${PREFIX_PATH}

ninja -v -C builddir
ninja -C builddir install

# Verify libraries were built and manually copy if needed
mkdir -p ${PREFIX}/lib
for lib in libGLX.so libOpenGL.so libGL.so libEGL.so libGLESv1_CM.so libGLESv2.so libGLdispatch.so; do
    find builddir -name "${lib}*" -exec ls -la {} \;
    find builddir -name "${lib}.*" -exec cp -av {} ${PREFIX}/lib/ \;
done

# Verify libraries exist in PREFIX/lib
ls -la ${PREFIX}/lib/lib*.so*

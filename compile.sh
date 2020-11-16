#!/bin/bash

set -e

run_compilation() {
    INSTALL_DIR="$(pwd)/install"

    export PATH="${INSTALL_DIR}/bin":$PATH

    echo
    echo "--------------------------------------------------------------------"
    echo
    echo "FLTK compilation"
    echo
    echo "--------------------------------------------------------------------"
    echo

    cd fltk

    patch -p1 < ../patches/fltk-1.3.patch

    mkdir build

    cd build

    cmake -DCMAKE_INSTALL_PREFIX="${INSTALL_DIR}" \
          -DOPTION_BUILD_SHARED_LIBS=on   \
          -DOPTION_USE_SYSTEM_LIBJPEG=off \
          -DOPTION_USE_SYSTEM_LIBPNG=off  \
          -DOPTION_USE_SYSTEM_ZLIB=off ..
    make

    make install

    echo
    echo "--------------------------------------------------------------------"
    echo
    echo "JAM compilation"
    echo
    echo "--------------------------------------------------------------------"
    echo

    cd ../../jam

    make

    ./jam0 -sBINDIR="${INSTALL_DIR}/bin" install

    echo
    echo "--------------------------------------------------------------------"
    echo
    echo "EDElib compilation"
    echo
    echo "--------------------------------------------------------------------"
    echo

    cd ../edelib

    patch -p1 < ../patches/edelib.patch

    ./autogen.sh

    ./configure --with-fltk-path="${INSTALL_DIR}" \
                --enable-debug \
                --prefix="${INSTALL_DIR}"
    jam

    jam install

    echo
    echo "--------------------------------------------------------------------"
    echo
    echo "EDE compilation"
    echo
    echo "--------------------------------------------------------------------"
    echo

    cd ../ede

    patch -p1 < ../patches/ede.patch

    ./autogen.sh

    ./configure --with-fltk-path="${INSTALL_DIR}" \
                --with-edelib-path="${INSTALL_DIR}" \
                --enable-debug \
                --prefix="${INSTALL_DIR}"

    jam -sBUILD_ICON_THEMES=1

    jam -sBUILD_ICON_THEMES=1 install
}

run_compilation |& tee build.logs

# flede
The Fast Light Easy Desktop Environment

Fork of the Equinox Desktop Environment

Build instructions:

1) build fltk-1.3
""
   cd fltk
   patch -p1 < ../patches/fltk-1.3.patch
   mkdir build
   cd build
   ccmake ..  # enable shared libraries and configure install path to /opt/ede
   make
   sudo make install
""
2) build jam
""
   cd jam
   make
   cp bin.${YOUROS}/jam /usr/local/bin
""
3) build edelib
""
   cd edelib
   patch -p1 < ../patches/edelib.patch
   ./autogen.sh
   ./configure --with-fltk-path=/opt/ede --enable-debug --prefix=/opt/ede
   jam
   sudo jam install
""
4) build ede
""
   cd ede
   patch -p1 < ../patches/ede.patch
   ./configure --with-fltk-path=/opt/ede --with-edelib-path=/opt/ede --enable-debug --prefix=/opt/ede
   jam -sBUILD_ICON_THEMES=1
   sudo jam -sBUILD_ICON_THEMES=1 install
""

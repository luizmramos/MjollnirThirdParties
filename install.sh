#!/bin/bash

set -e

if [ "$(id -u)" != "0" ]; then
	echo "Run this script with sudo."
	exit 1
fi

echo "==== Dependencies ===="
add-apt-repository ppa:ubuntu-toolchain-r/test
apt-get update
apt-get -y install gcc-4.7 g++-4.7
update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.7 60 --slave /usr/bin/g++ g++ /usr/bin/g++-4.7
update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.6 40 --slave /usr/bin/g++ g++ /usr/bin/g++-4.6

apt-get -y install make cmake automake autoconf bison flex libevent-dev libboost1.48-dev libssl-dev mono-devel mono-gmcs openjdk-7-jdk pkg-config qt4-dev-tools zlibc zlib1g zlib1g-dev

# Ant must come after openjdk-7-jdk, otherwise it installs java 6
apt-get -y install ant

echo "==== Cleaning ===="
rm -rf include
rm -rf lib
mkdir -p include
mkdir -p lib

echo "==== gflags ===="
cd gflags-2.1.1
rm -f CMakeCache.txt
cmake .
make
cp -r include/* ../include
cp lib/* ../lib
cd ..

echo "==== gtest ===="
cd gtest-1.7.0
rm -f CMakeCache.txt
#cmake .
autoconf
automake
./configure
make
cp -r include/* ../include
cp lib/* ../lib
cp libgtest.a ../lib || cp lib/.libs/libgtest.a ../lib
cd ..

echo "==== thrift ===="
cd thrift-0.9.1
cp -f /usr/share/aclocal/pkg.m4 aclocal
autoconf
touch NEWS README AUTHORS ChangeLog
automake --add-missing
./configure
make
make install
cd lib/java
ant
cd ../..
cp -r lib/py/build/lib.linux-x86_64-2.7/thrift ../lib/
cp lib/csharp/Thrift.dll ../lib/
cp lib/java/build/*.jar ../lib/
cp lib/java/build/lib/* ../lib/
cd ..
cp /usr/local/lib/libthrift.a lib/
cp -r /usr/local/include/thrift include/


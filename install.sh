#!/bin/bash
if [ "$(id -u)" != "0" ]; then
	echo "Run this script with sudo."
	exit 1
fi
apt-get install libevent-dev libboost1.46-dev libboost-dev zlibc zlib1g zlib1g-dev	
rm -rf include
rm -rf lib
mkdir -p include
mkdir -p lib
cd gflags-2.1.1
rm CMakeCache.txt
cmake .
./configure
make
cp -r include/* ../include
cp lib/* ../lib
cd ..
cd gtest-1.7.0
rm CMakeCache.txt
cmake .
./configure
make
cp -r include/* ../include
cp lib/* ../lib
cp libgtest.a ../lib
cd ..
cd thrift-0.9.1
./configure
make
make install
cp -r lib/py/build/lib.linux-x86_64-2.7/thrift ../lib/
cp lib/csharp/Thrift.dll ../lib/
cd ..
cp /usr/local/lib/libthrift.a lib/
cp -r /usr/local/include/thrift include/


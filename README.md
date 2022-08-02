# breakpad_script

![](img/img.png)

## google breakpad version
https://github.com/google/breakpad/tree/v2022.07.12
* tag: v2022.07.12
* commit id: 335e61656fa6034fabc3431a91e5800ba6fc3dc9

## Links
* https://github.com/google/breakpad
* https://chromium.googlesource.com/breakpad/breakpad

## shell compile
```shell
export CPPFLAGS="-D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64"
export CFLAGS="-D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64"
./configure --host=arm-linux-gnueabihf --prefix=`pwd`/output
```

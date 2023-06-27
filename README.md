# ctcbuild

A GCC cross toolchain builder script, with a special focus on Ada on
ARM Cortex-M devices.

[GCC documentation](https://gcc.gnu.org/install/prerequisites.html) states:
> In order to build a cross compiler, it is strongly recommended to install
> the new compiler as native first, and then use it to build the cross
> compiler. Other native compiler versions may work but this is not guaranteed
> and will typically fail with hard to understand compilation errors during
> the build.

Basically what this script tries to automate is the following recipe:

1. Build native GCC and binutils (as and ld)
2. Build native libgcc, libstdc++ and libada (for compiling cross-GNAT)
3. Install native toolchain
4. Build stage1 cross GCC and binutils (as and ld)
5. Install stage1 GCC and binutils
6. Build and install newlib
7. Build stage2 cross GCC with newlib sysroot
8. Build gdb

Example usage: `./ctcbuild conf/13.1-arm-none-eabi.rm.sh`

This is what the directory tree typically looks like after the complete
process of building a cross-toolchain is finished.
```
repo/
tarballs/
builds/
  {CONFIG_ID}/
    sources/
      binutils-2.40/
      gcc-13.1.0/
      gdb-13.2/
      gmp-6.2.1/
      isl-0.24/
      mpc-1.3.1/
      mpfr-4.2.0/
      newlib-4.3.0.20230120/
    build/
      {HOST}/
        gcc-13.1.0/
      {TARGET}/
        stage1/
          gcc-13.1.0/
        stage2/
          newlib-4.3.0.20230120/
          gcc-13.1.0/
    install/
      {HOST}/
        bin/
        lib/
        ...
      {TARGET}/
        stage1/
          bin/
          ...
        stage2/
          bin/
          ...
```


## Configure Options

For starters have a look at the following ressources:

Linaro ABE manifests for the ARM GCC toolchain:
- [arm-gnu-toolchain-arm-none-eabi-abe-manifest.txt](https://armkeil.blob.core.windows.net/developer/Files/downloads/gnu/12.2.mpacbti-rel1/manifest/arm-gnu-toolchain-arm-none-eabi-abe-manifest.txt)
- [arm-gnu-toolchain-arm-none-eabi-nano-abe-manifest.txt](https://armkeil.blob.core.windows.net/developer/Files/downloads/gnu/12.2.mpacbti-rel1/manifest/arm-gnu-toolchain-arm-none-eabi-nano-abe-manifest.txt)

[GCC configure documentation](https://gcc.gnu.org/install/configure.html)

The following sections describe the configure options outlines in the
ABE manifests. In contrast to ABE this script uses a combined tree
build as described in the GCC documentation.

### GCC

| Option                    | Stage 1   | Stage 2   |
|---                        |---        |---        |
| `--with-mpc=${local_builds}/destdir/${host}`  | x | x |
| `--with-mpfr=${local_builds}/destdir/${host}` | x | x |
| `--with-gmp=${local_builds}/destdir/${host}`  | x | x |
| `--disable-libatomic`       | x         | -         |
| `--disable-libsanitizer`    | x         | -         |
| `--disable-libssp`          | x         | -         |
| `--disable-libgomp`         | x         | -         |
| `--disable-libmudflap`      | x         | -         |
| `--disable-libquadmath`     | x         | -         |
| `--disable-shared`          | x         | x         |
| `--disable-nls`             | x         | x         |
| `--disable-threads`         | x         | x         |
| `--disable-tls`             | x         | x         |
| `--enable-checking=release` | x         | x         |
| `--enable-languages=c`      | x         | -         |
| `--enable-languages=c,c++`  | -         | x         |
| `--without-cloog`           | x         | -         |
| `--without-isl`             | x         | -         |
| `--with-newlib`             | x         | x         |
| `--without-headers`         | x         | -         |
| `--with-gnu-as`             | x         | x         |
| `--with-gnu-ld`             | x         | x         |
| `--with-multilib-list=aprofile,rmprofile` | x | x    |
| `--with-sysroot=${local_builds}/sysroot-arm-none-eabi`| x | - |
| `--with-build-sysroot=${sysroots}` | -  | x         |
| `--with-sysroot=${local_builds}/destdir/${host}/arm-none-eabi` | - | x |

### GMP
`--enable-cxx --enable-fft`

### MPFR
`--with-gmp=${local_builds}/destdir/${host}`

### MPC
`-with-gmp=${local_builds}/destdir/${host} --with-mpfr=${local_builds}/destdir/${host}`

### NEWLIB
| Option                                | Newlib    | Newlin-Nano   |
| ---                                   | ---       | ---           |
| `--disable-newlib-supplied-syscalls`  | x         | x             |
| `--enable-newlib-reent-check-verify`  | x         | x             |
| `--enable-newlib-retargetable-locking`| x         | x             |
| `--enable-newlib-io-long-long`        | x         | -             |
| `--enable-newlib-io-c99-formats`      | x         | -             |
| `--enable-newlib-mb`                  | x         | -             |
| `--enable-newlib-register-fini`       | x         | -             |
| `--disable-newlib-fseek-optimization` | -         | x             |
| `--disable-newlib-fvwrite-in-streamio`| -         | x             |
| `--disable-newlib-unbuf-stream-opt`   | -         | x             |
| `--disable-newlib-wide-orient`        | -         | x             |
| `--enable-lite-exit`                  | -         | x             |
| `--enable-newlib-global-atexit`       | -         | x             |
| `--enable-newlib-nano-formatted-io`   | -         | x             |
| `--enable-newlib-nano-malloc`         | -         | x             |
| `--enable-newlib-reent-small`         | -         | x             |

### binutils
`--enable-initfini-array --disable-nls --without-x --disable-gdbtk --without-tcl --without-tk --enable-plugins --disable-gdb --without-gdb --with-sysroot=${sysroots}`

### gdb
`--with-gnu-ld --enable-plugins --enable-tui --with-pkgversion=Linaro_GDB-2019.12 --disable-gas --disable-binutils --disable-ld --disable-gold --disable-gprof --with-python=yes`


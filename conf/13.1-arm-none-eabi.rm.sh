#----------------------------------------------------------------------------
# Unique configuration id
#----------------------------------------------------------------------------
CONFIG_ID="arm-none-eabi-rm-13.1"

#----------------------------------------------------------------------------
# Host and target architectures
#----------------------------------------------------------------------------
HOST="x86_64-pc-linux-gnu"
TARGET="arm-none-eabi"

#----------------------------------------------------------------------------
# Versions / Archives / URLs
#----------------------------------------------------------------------------
# GNU binutils archive and base url
BINUTILS_ARC="binutils-2.40.tar.xz"
BINUTILS_BASE_URL="https://ftp.gnu.org/gnu/binutils"
# GDB archive and base url
GDB_ARC="gdb-13.2.tar.xz"
GDB_BASE_URL="https://ftp.gnu.org/gnu/gdb"
# GCC archive and base url
GCC_ARC="gcc-13.1.0.tar.xz"
GCC_BASE_URL="https://ftp.gwdg.de/pub/misc/gcc/releases/gcc-13.1.0"
# Newlib archive and base url
NEWLIB_ARC="newlib-4.3.0.20230120.tar.gz"
NEWLIB_BASE_URL="https://sourceware.org/pub/newlib"
# GMP archive and base url
GMP_ARC="gmp-6.2.1.tar.lz"
GMP_BASE_URL="https://gmplib.org/download/gmp"
# MPC archive and base url
MPC_ARC="mpc-1.3.1.tar.gz"
MPC_BASE_URL="https://ftp.gnu.org/gnu/mpc"
# MPFR archive and base url
MPFR_ARC="mpfr-4.2.0.tar.xz"
MPFR_BASE_URL="https://ftp.gnu.org/gnu/mpfr"
# ISL (graphite) archive and base url
ISL_ARC="isl-0.24.tar.bz2"
ISL_BASE_URL="https://gcc.gnu.org/pub/gcc/infrastructure"

#----------------------------------------------------------------------------
# Directories (relative paths)
# ---------------------------------------------------------------------------
# Specifies the location the sources are downloaded to
REPO_DIR="./repo"
# Directory for finished tarballs
TARBALL_DIR="./tarballs"
# Directory for unpacking sources and build trees
BUILD_DIR="./builds"

#----------------------------------------------------------------------------
# Configure options
#----------------------------------------------------------------------------
# Config options for native / intermediate GCC
CONFIG_NATIVE="--disable-nls --enable-languages=c,c++,ada --disable-bootstrap"
# Config options for newlib
CONFIG_NEWLIB="--disable-newlib-supplied-syscalls --enable-newlib-reent-check-verify\
 --enable-newlib-retargetable-locking --disable-newlib-fseek-optimization\
 --disable-newlib-fvwrite-in-streamio --disable--newlib-unbuf-stream-opt\
 --disable-newlib-wide-orient --enable-lite-exit --enable-newlib-global-atexit\
 --enable-newlib-nano-formatted-io --enable-newlib-nano-malloc\
 --enable-newlib-reent-small"
# Config options for stage1 cross compiler
CONFIG_STAGE1="--disable-libatomic --disable-libsanitizer --disable-libssp\
 --disable-libgomp --disable-libmudflap --disable-libquadmath\
 --disable-shared --disable-nls --disable-threads --disable-tls\
 --enable-checking=release --enable-languages=c --without-cloog --without-isl\
 --with-newlib --without-headers --with-gnu-as --with-gnu-ld\
 --with-multilib-list=rmprofile \
 --with-sysroot=$(realpath -m "${BUILD_DIR}/sysroot-arm-none-eabi")"
# Config options for stage2 cross compiler
CONFIG_STAGE2="--disable-shared --disable-nls --disable-threads --disable-tls\
 --enable-checking=release --enable-languages=c,ada --with-newlib\
 --with-gnu-as --with-gnu-ld --with-multilib-list=rmprofile"
# Config for gdb build
CONFIG_GDB="--with-gnu-ld --enable-plugins --enable-tui --disable-gas\
 --disable-binutils --disable-ld --disable-gold --disable-gprof\
 --with-python=yes"

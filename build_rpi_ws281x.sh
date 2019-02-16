#!/bin/bash

# ---------------------------------------------------------------------------------------------------------------------
# Compiles shared libraries required for interfacing with Raspberry Pi GPIO hardware from Java, using JNI.
# ---------------------------------------------------------------------------------------------------------------------
# Author(s):    limpygnome <limpygnome@gmail.com>, mbelling <matthew.bellinger@gmail.com>
# ---------------------------------------------------------------------------------------------------------------------

# *********************************************************************************************************************
# Configuration
# *********************************************************************************************************************


# Relative dir names for input/output
BASE_DIR="$(dirname "$0")/"
OUTPUT="${BASE_DIR}/build"

NATIVE_SRC="${OUTPUT}/ws281x"
NATIVE_OUT="${NATIVE_SRC}/output"
NATIVE_LIB_NAME="ws281x.so"
LIB_BASE_NAME="libws281x"
WRAPPER_LIB_NAME="${LIB_BASE_NAME}.so"


# *********************************************************************************************************************
# Functions
# *********************************************************************************************************************

function compileSrc
{
    SRC="${1}"
    OUT="${2}"

    gcc -shared -fPIC -w -o "${OUT}" -c "${SRC}" -I./
}

function programInstalled
(
    CMD="${1}"
    EXPECTED="${2}"
    ERROR="${3}"
    SUCCESS="${4}"

    OUTPUT=$(eval ${CMD} || echo "fail")
    if [[ "${OUTPUT}" != *"${EXPECTED}"* ]]; then
        echo "${ERROR}"
        exit 1
    else
        echo "${SUCCESS}"
    fi
)

# *********************************************************************************************************************
# Main
# *********************************************************************************************************************

echo "NeoPixel ws281x Library Compiler"
echo "****************************************************"

# Check dependencies installed
set -e
programInstalled "gcc --version" "free software" "Error - GCC is not installed, cannot continue!" "Check - GCC installed..."
programInstalled "git --version" "git version" "Error - git is not installed, cannot continue!" "Check - git installed..."
set +e

# Clean workspace
echo "Deleting build directory to start clean..."
rm -rf build

# Retrieve rpi_ws281x repository
echo "Cloning rpi_ws281x repository..."
git clone https://github.com/jgarff/rpi_ws281x.git ${NATIVE_SRC}

# # At the time of this writing this repository does not tag versions, so checking out at a specific commit so we build a consistent library
# echo "Checking out specific revision..."
# pushd ${NATIVE_SRC}
# git checkout master
# popd

# Create all the required dirs
echo "Creating required dirs..."
mkdir -p "${NATIVE_OUT}"
mkdir -p "${OUTPUT}/nativeLib"

# Compile library objects
echo "Compiling ws281x library objects..."

compileSrc "${NATIVE_SRC}/ws2811.c"        "${NATIVE_OUT}/ws2811.o"
compileSrc "${NATIVE_SRC}/pwm.c"           "${NATIVE_OUT}/pwm.o"
compileSrc "${NATIVE_SRC}/pcm.c"           "${NATIVE_OUT}/pcm.o"
compileSrc "${NATIVE_SRC}/dma.c"           "${NATIVE_OUT}/dma.o"
compileSrc "${NATIVE_SRC}/rpihw.c"         "${NATIVE_OUT}/rpihw.o"
compileSrc "${NATIVE_SRC}/mailbox.c"       "${NATIVE_OUT}/mailbox.o"


# Compile library
echo "Compiling ws281x library..."
gcc -shared -o "${OUTPUT}/${NATIVE_LIB_NAME}" "${NATIVE_OUT}/ws2811.o" "${NATIVE_OUT}/pwm.o" "${NATIVE_OUT}/pcm.o" "${NATIVE_OUT}/dma.o" "${NATIVE_OUT}/rpihw.o" "${NATIVE_OUT}/mailbox.o"

cp "Makefile.template" "${NATIVE_SRC}/Makefile"
cd $NATIVE_SRC && make
sudo make install
echo "Done!"

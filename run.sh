#!/usr/bin/env bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
CMAKE_INSTALL_PREFIX=${SCRIPT_DIR}/install
CMAKE_PREFIX_PATH=${SCRIPT_DIR}/install
CMAKE_MODULE_PATH=${SCRIPT_DIR}/cmake

CMAKE_COMMON_OPTIONS="-DCMAKE_VERBOSE_MAKEFILE=ON -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX} -DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH} -DCMAKE_MODULE_PATH=${CMAKE_MODULE_PATH}"



function run_build() {
  CURRENT_PROJECT_NAME=$1
  CMAKE_TARGET=$2

  CURRENT_PROJECT_DIR=${SCRIPT_DIR}/${CURRENT_PROJECT_NAME}
  rm -rf ${CURRENT_PROJECT_DIR}/build
  rm -rf ${CURRENT_PROJECT_NAME}_cmake_*.log

  cmake \
    -DCMAKE_BUILD_TYPE=Debug \
    -G Ninja \
    ${CMAKE_COMMON_OPTIONS} \
    -S ${CURRENT_PROJECT_DIR} \
    -B ${CURRENT_PROJECT_DIR}/build \
    2>&1 > ${CURRENT_PROJECT_NAME}_cmake_config.log

  cmake \
    --build ${CURRENT_PROJECT_DIR}/build \
    --target ${CMAKE_TARGET} \
    -j 22 \
    2>&1 > ${CURRENT_PROJECT_NAME}_cmake_build.log
}

rm -rf ${CMAKE_INSTALL_PREFIX}

run_build internal-project install

run_build external-project all
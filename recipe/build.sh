#!/bin/sh

set -ex

# --- shiboken6_generator (must run before shiboken6 / PySide6) ---
echo "Building: shiboken6_generator"

cmake -LAH -G "Ninja" ${CMAKE_ARGS} \
  -DCMAKE_PREFIX_PATH=${PREFIX} \
  -DCMAKE_INSTALL_PREFIX=${PREFIX} \
  -DCMAKE_UNITY_BUILD=ON -DCMAKE_UNITY_BUILD_BATCH_SIZE=32 \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_RPATH=${PREFIX}/lib \
  -DBUILD_TESTS=OFF \
  -DPython_EXECUTABLE=${PYTHON} \
  -B build_shiboken_gen -S sources/shiboken6_generator
cmake --build build_shiboken_gen --target install

echo "Done: shiboken6_generator"

# https://github.com/conda/conda-build/issues/5563
export SP_DIR=$PREFIX/lib/python`python -c "import sysconfig; print(sysconfig.get_config_var('LDVERSION'))"`/site-packages

# --- shiboken6 ---
echo "Building: shiboken6"

cmake -LAH -G "Ninja" ${CMAKE_ARGS} \
  -DCMAKE_PREFIX_PATH=${PREFIX} \
  -DCMAKE_INSTALL_PREFIX=${PREFIX} \
  -DCMAKE_UNITY_BUILD=ON \
  -DCMAKE_UNITY_BUILD_BATCH_SIZE=32 \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_RPATH=${PREFIX}/lib \
  -DBUILD_TESTS=OFF \
  -DFORCE_LIMITED_API=OFF \
  -DPython_EXECUTABLE=${PYTHON} \
  -B build_shiboken -S sources/shiboken6
cmake --build build_shiboken --target install

mkdir ${SP_DIR}/shiboken6-${PKG_VERSION}.dist-info
cp ${RECIPE_DIR}/METADATA.shiboken6.in ${SP_DIR}/shiboken6-${PKG_VERSION}.dist-info/METADATA
cp ${RECIPE_DIR}/INSTALLER.in ${SP_DIR}/shiboken6-${PKG_VERSION}.dist-info/INSTALLER
echo "Version: ${PKG_VERSION}" >> ${SP_DIR}/shiboken6-${PKG_VERSION}.dist-info/METADATA

echo "Done: shiboken6"

# --- PySide6 ---
echo "Building: pyside6"

cmake -LAH -G "Ninja" ${CMAKE_ARGS} \
  -DCMAKE_PREFIX_PATH=${PREFIX} \
  -DCMAKE_INSTALL_PREFIX=${PREFIX} \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_RPATH="${PREFIX}/lib" \
  -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON \
  -DCMAKE_MACOSX_RPATH=ON \
  -DCMAKE_UNITY_BUILD=ON \
  -DCMAKE_UNITY_BUILD_BATCH_SIZE=32 \
  -DBUILD_TESTS=OFF \
  -DPython_EXECUTABLE=${PYTHON} \
  -B build_pyside -S sources/pyside6
cmake --build build_pyside --target install

mkdir ${SP_DIR}/PySide6-${PKG_VERSION}.dist-info
cp ${RECIPE_DIR}/METADATA.pyside6.in ${SP_DIR}/PySide6-${PKG_VERSION}.dist-info/METADATA
cp ${RECIPE_DIR}/INSTALLER.in ${SP_DIR}/PySide6-${PKG_VERSION}.dist-info/INSTALLER
echo "Version: ${PKG_VERSION}" >> ${SP_DIR}/PySide6-${PKG_VERSION}.dist-info/METADATA
cat ${SP_DIR}/PySide6-${PKG_VERSION}.dist-info/METADATA

echo "Done: pyside6"

# --- pyside-tools ---
echo "Building: pyside-tools"

cmake -LAH -G "Ninja" ${CMAKE_ARGS} \
  -DCMAKE_PREFIX_PATH=${PREFIX} \
  -DCMAKE_INSTALL_PREFIX=${PREFIX} \
  -DCMAKE_BUILD_TYPE=Release \
  -DNO_QT_TOOLS=yes \
  -DPython_EXECUTABLE=${PYTHON} \
  -B build_tools -S sources/pyside-tools
cmake --build build_tools --target install

# Move pyside_tool.py to the right location
mkdir -p "${SP_DIR}"/PySide6/scripts
touch "${SP_DIR}"/PySide6/scripts/__init__.py
mv ${PREFIX}/bin/pyside_tool.py "${SP_DIR}"/PySide6/scripts/pyside_tool.py

echo "Done: pyside-tools"

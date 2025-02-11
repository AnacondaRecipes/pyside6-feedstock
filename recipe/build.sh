#!/bin/sh

echo "Building: shiboken6"

pushd sources/shiboken6

mkdir build && cd build

cmake -LAH -G "Ninja" ${CMAKE_ARGS} \
  -DCMAKE_PREFIX_PATH=${PREFIX} \
  -DCMAKE_INSTALL_PREFIX=${PREFIX} \
  -DCMAKE_UNITY_BUILD=ON \
  -DCMAKE_UNITY_BUILD_BATCH_SIZE=32 \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_RPATH=${PREFIX}/lib \
  -DBUILD_TESTS=OFF \
  -DPython_EXECUTABLE=${PYTHON} \
  -DNUMPY_INCLUDE_DIR=${SP_DIR}/numpy/core/include \
  ..
cmake --build . --target install
popd

mkdir ${SP_DIR}/shiboken6-${PKG_VERSION}.dist-info
cp ${RECIPE_DIR}/METADATA.shiboken6.in ${SP_DIR}/shiboken6-${PKG_VERSION}.dist-info/METADATA
cp ${RECIPE_DIR}/INSTALLER.in ${SP_DIR}/shiboken6-${PKG_VERSION}.dist-info/INSTALLER
echo "Version: ${PKG_VERSION}" >> ${SP_DIR}/shiboken6-${PKG_VERSION}.dist-info/METADATA

echo "Done: shiboken6"
echo "Building: pyside6"

if [[ "${target_platform}" == linux-* ]]; then
  # Hack to help the gn build tool find alsa during build. We can't add ${BUILD_PREFIX}/${HOST}/sysroot/lib64 to the
  # LD_LIBRARY_PATH below because it causes segfaults in many system applications.
  ln -s ../../lib64/libasound.so.2 ${BUILD_PREFIX}/${HOST}/sysroot/usr/lib64/libasound.so.2

  # Add runtime path of libEGL.so.1 for generate_pyi.py
  export LD_LIBRARY_PATH="${BUILD_PREFIX}/${HOST}/sysroot/usr/lib64:${LD_LIBRARY_PATH}"
fi

pushd sources/pyside6
mkdir build && cd build

cmake -LAH -G "Ninja" ${CMAKE_ARGS} \
  -DCMAKE_PREFIX_PATH=${PREFIX} \
  -DCMAKE_INSTALL_PREFIX=${PREFIX} \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_RPATH="${PREFIX}/lib" \
  -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON \
  -DCMAKE_MACOSX_RPATH=ON \
  -DCMAKE_UNITY_BUILD=ON \
  -DCMAKE_UNITY_BUILD_BATCH_SIZE=32 \
  -D_qt5Core_install_prefix=${PREFIX} \
  -DBUILD_TESTS=ON \
  -DPython_EXECUTABLE=${PYTHON} \
  -DNUMPY_INCLUDE_DIR=${SP_DIR}/numpy/core/include \
  ..
cmake --build . --target install

mkdir ${SP_DIR}/PySide6-${PKG_VERSION}.dist-info
cp ${RECIPE_DIR}/METADATA.pyside6.in ${SP_DIR}/PySide6-${PKG_VERSION}.dist-info/METADATA
cp ${RECIPE_DIR}/INSTALLER.in ${SP_DIR}/PySide6-${PKG_VERSION}.dist-info/INSTALLER
echo "Version: ${PKG_VERSION}" >> ${SP_DIR}/PySide6-${PKG_VERSION}.dist-info/METADATA
cat ${SP_DIR}/PySide6-${PKG_VERSION}.dist-info/METADATA

popd

echo "Done: pyside6"
echo "Building: pyside-tools"

pushd sources/pyside-tools
mkdir build && cd build

cmake -LAH -G "Ninja" ${CMAKE_ARGS} \
  -DCMAKE_PREFIX_PATH=${PREFIX} \
  -DCMAKE_INSTALL_PREFIX=${PREFIX} \
  -DCMAKE_BUILD_TYPE=Release \
  -DPython_EXECUTABLE=${PYTHON} \
  ..
cmake --build . --target install

# Move pyside_tool.py to the right location
mkdir -p "${SP_DIR}"/PySide6/scripts
touch "${SP_DIR}"/PySide6/scripts/__init__.py
mv ${PREFIX}/bin/pyside_tool.py "${SP_DIR}"/PySide6/scripts/pyside_tool.py

echo "Done: pyside-tools"

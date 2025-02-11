#! /usr/bin/env bash

if [[ "${target_platform}" == linux-* ]]; then
  # Hack to help the gn build tool find alsa during build. We can't add ${PREFIX}/${BUILD}/sysroot/lib64 to the
  # LD_LIBRARY_PATH below because it causes segfaults in many system applications.
  ln -s ../../lib64/libasound.so.2 ${PREFIX}/${BUILD/conda_cos7/conda}/sysroot/usr/lib64/libasound.so.2

  # Add runtime path of libEGL.so.1 so Qt libraries can find it as they're loaded in.
  # This must be done before the python interpreter starts up.
  export LD_LIBRARY_PATH="${PREFIX}/${BUILD/conda_cos7/conda}/sysroot/usr/lib64:${LD_LIBRARY_PATH}"
fi

test -f ${PREFIX}/bin/pyside6-rcc || (echo "FATAL: Failed to find pyside6-rcc" && exit 1)
test -f ${PREFIX}/bin/pyside6-uic || (echo "FATAL: Failed to find pyside6-uic" && exit 2)
test -f ${PREFIX}/bin/shiboken6 || (echo "FATAL: Failed to find shiboken6" && exit 3)
test -f ${PREFIX}/include/PySide6/pyside.h || (echo "FATAL: Failed to find PySide6/pyside.h" && exit 4)
test -f ${PREFIX}/include/shiboken6/shiboken.h || (echo "FATAL: Failed to find shiboken6/shiboken.h" && exit 5)
test -f ${PREFIX}/lib/libpyside6.abi3${SHLIB_EXT} || (echo "FATAL: Failed to find libpyside6.abi3${SHLIB_EXT}" && exit 6)
test -f ${PREFIX}/lib/libshiboken6.abi3${SHLIB_EXT} || (echo "FATAL: Failed to find libshiboken6.abi3${SHLIB_EXT}" && exit 7)
test -f ${PREFIX}/lib/cmake/PySide6/PySide6Config.cmake || (echo "FATAL: Failed to find PySide6/PySide6Config.cmake" && exit 8)
test -f ${PREFIX}/lib/pkgconfig/pyside6.pc || (echo "FATAL: Failed to find pyside6.pc" && exit 9)
test -f ${PREFIX}/lib/pkgconfig/shiboken6.pc || (echo "FATAL: Failed to find shiboken6.pc" && exit 10)

${PYTHON} ${RECIPE_DIR}/check_imports.py

shiboken6 --help
pyside6-rcc -help
pyside6-uic -help

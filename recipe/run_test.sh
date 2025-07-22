#! /usr/bin/env bash

test -f ${PREFIX}/bin/pyside6-rcc || (echo "FATAL: Failed to find pyside6-rcc" && exit 1)
test -f ${PREFIX}/bin/pyside6-uic || (echo "FATAL: Failed to find pyside6-uic" && exit 2)
test -f ${PREFIX}/bin/shiboken6 || (echo "FATAL: Failed to find shiboken6" && exit 3)
test -f ${PREFIX}/include/PySide6/pyside.h || (echo "FATAL: Failed to find PySide6/pyside.h" && exit 4)
test -f ${PREFIX}/include/shiboken6/shiboken.h || (echo "FATAL: Failed to find shiboken6/shiboken.h" && exit 5)
test -f ${PREFIX}/lib/cmake/PySide6/PySide6Config.cmake || (echo "FATAL: Failed to find PySide6/PySide6Config.cmake" && exit 6)
test -f ${PREFIX}/lib/pkgconfig/pyside6.pc || (echo "FATAL: Failed to find pyside6.pc" && exit 7)
test -f ${PREFIX}/lib/pkgconfig/shiboken6.pc || (echo "FATAL: Failed to find shiboken6.pc" && exit 8)

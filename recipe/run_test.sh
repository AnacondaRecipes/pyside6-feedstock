#! /usr/bin/env bash

test -f ${PREFIX}/bin/pyside6-rcc || (echo "FATAL: Failed to find pyside6-rcc" && exit 1)
test -f ${PREFIX}/bin/pyside6-uic || (echo "FATAL: Failed to find pyside6-uic" && exit 2)
test -f ${PREFIX}/bin/shiboken6 || (echo "FATAL: Failed to find shiboken6" && exit 3)
test -f ${PREFIX}/PySide6/include/pyside.h || (echo "FATAL: Failed to find PySide6/pyside.h" && exit 4)
test -f ${PREFIX}/shiboken6/include/shiboken.h || (echo "FATAL: Failed to find shiboken6/shiboken.h" && exit 5)
test -f ${PREFIX}/lib/cmake/PySide6/PySide6Config.cmake || (echo "FATAL: Failed to find PySide6/PySide6Config.cmake" && exit 6)
test -f ${PREFIX}/lib/pkgconfig/pyside6.pc || (echo "FATAL: Failed to find pyside6.pc" && exit 7)
test -f ${PREFIX}/lib/pkgconfig/shiboken6.pc || (echo "FATAL: Failed to find shiboken6.pc" && exit 8)
test -f ${PREFIX}/lib/qt6/uic || (echo "FATAL: Failed to find uic (qtbase-devel)" && exit 9)
test -f ${PREFIX}/lib/qt6/rcc || (echo "FATAL: Failed to find rcc (qtbase-devel)" && exit 10)

pyside6-uic -help

cat > test.ui <<'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<ui version="4.0">
    <class>MainWindow</class>
    <widget class="QMainWindow" name="MainWindow">
        <widget class="QWidget" name="centralwidget">
            <layout class="QVBoxLayout" name="verticalLayout">
                <item><widget class="QPushButton" name="pushButton"><property name="text"><string>OK</string></property></widget></item>
            </layout>
        </widget>
    </widget>
    <resources/>
    <connections/>
</ui>
EOF

pyside6-uic test.ui -o test_ui.py
test -s test_ui.py || (echo "FATAL: test_ui.py empty" && exit 11)

:: Use `python --version` instead of %PY_VER% because sometimes PY_VER is not the version used to build the package.
for /f "tokens=2" %%i in ('%PYTHON% --version') do set python_version_string=%%i
set py_ver=%python_version_string:~0,4%
set py_ver=%py_ver:.=%

if not exist %PREFIX%\\Scripts\\pyside6-rcc.exe (echo "FATAL: Failed to find %PREFIX%\\Scripts\\pyside6-rcc.exe" && exit 1)
if not exist %PREFIX%\\Scripts\\pyside6-uic.exe (echo "FATAL: Failed to find %PREFIX%\\Scripts\\pyside6-uic.exe" && exit 2)
if not exist %LIBRARY_BIN%\\shiboken6.exe (echo "FATAL: Failed to find %LIBRARY_BIN%\\shiboken6.exe" && exit 3)
if not exist %LIBRARY_BIN%\\shiboken6.cp%py_ver%-win_amd64.dll (echo "FATAL: Failed to find %LIBRARY_BIN%\\shiboken6.cp%py_ver%-win_amd64.dll" && exit 4)
if not exist %LIBRARY_BIN%\\pyside6.cp%py_ver%-win_amd64.dll (echo "FATAL: Failed to find %LIBRARY_BIN%\\pyside6.cp%py_ver%-win_amd64.dll" && exit 5)
if not exist %LIBRARY_INC%\\PySide6\\pyside.h (echo "FATAL: Failed to find %LIBRARY_INC%\\PySide6\\pyside.h" && exit 6)
if not exist %LIBRARY_INC%\\shiboken6\\shiboken.h (echo "FATAL: Failed to find %LIBRARY_INC%\\shiboken6\\shiboken.h" && exit 7)
if not exist %LIBRARY_LIB%\\shiboken6.cp%py_ver%-win_amd64.lib (echo "FATAL: Failed to find %LIBRARY_LIB%\\shiboken6.cp%py_ver%-win_amd64.lib" && exit 8)
if not exist %LIBRARY_LIB%\\pyside6.cp%py_ver%-win_amd64.lib (echo "FATAL: Failed to find %LIBRARY_LIB%\\pyside6.cp%py_ver%-win_amd64.lib" && exit 9)
if not exist %LIBRARY_LIB%\\cmake\\PySide6\\PySide6Config.cmake (echo "FATAL: Failed to find %LIBRARY_LIB%\\cmake\\PySide6\\PySide6Config.cmake" && exit 10)
if not exist %LIBRARY_LIB%\\pkgconfig\\pyside6.pc (echo "FATAL: Failed to find %LIBRARY_LIB%\\pkgconfig\\pyside6.pc" && exit 11)
if not exist %LIBRARY_LIB%\\pkgconfig\\shiboken6.pc (echo "FATAL: Failed to find %LIBRARY_LIB%\\pkgconfig\\shiboken6.pc" && exit 12)

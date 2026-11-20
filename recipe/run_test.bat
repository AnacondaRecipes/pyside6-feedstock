:: Use `python --version` instead of %PY_VER% because sometimes PY_VER is not the version used to build the package.
for /f "tokens=2" %%i in ('%PYTHON% --version') do set python_version_string=%%i
set py_ver=%python_version_string:~0,4%
set py_ver=%py_ver:.=%
for /f %%i in ('%PYTHON% -c "import sysconfig; print(sysconfig.get_platform().replace('-', '_'))"') do set py_platform=%%i

if not exist %PREFIX%\\Scripts\\pyside6-rcc.exe (echo "FATAL: Failed to find %PREFIX%\\Scripts\\pyside6-rcc.exe" && exit 1)
if not exist %PREFIX%\\Scripts\\pyside6-uic.exe (echo "FATAL: Failed to find %PREFIX%\\Scripts\\pyside6-uic.exe" && exit 2)
if not exist %LIBRARY_BIN%\\shiboken6.exe (echo "FATAL: Failed to find %LIBRARY_BIN%\\shiboken6.exe" && exit 3)
if not exist %LIBRARY_BIN%\\shiboken6.cp%py_ver%-%py_platform%.dll (echo "FATAL: Failed to find %LIBRARY_BIN%\\shiboken6.cp%py_ver%-%py_platform%.dll" && exit 4)
if not exist %LIBRARY_BIN%\\pyside6.cp%py_ver%-%py_platform%.dll (echo "FATAL: Failed to find %LIBRARY_BIN%\\pyside6.cp%py_ver%-%py_platform%.dll" && exit 5)
if not exist %PREFIX%\\Library\\PySide6\\include\\pyside.h (echo "FATAL: Failed to find %PREFIX%\\Library\\PySide6\\include\\pyside.h" && exit 6)
if not exist %PREFIX%\\Library\\shiboken6\\include\\shiboken.h (echo "FATAL: Failed to find %PREFIX%\\Library\\shiboken6\\include\\shiboken.h" && exit 7)
if not exist %LIBRARY_LIB%\\shiboken6.cp%py_ver%-%py_platform%.lib (echo "FATAL: Failed to find %LIBRARY_LIB%\\shiboken6.cp%py_ver%-%py_platform%.lib" && exit 8)
if not exist %LIBRARY_LIB%\\pyside6.cp%py_ver%-%py_platform%.lib (echo "FATAL: Failed to find %LIBRARY_LIB%\\pyside6.cp%py_ver%-%py_platform%.lib" && exit 9)
if not exist %LIBRARY_LIB%\\cmake\\PySide6\\PySide6Config.cmake (echo "FATAL: Failed to find %LIBRARY_LIB%\\cmake\\PySide6\\PySide6Config.cmake" && exit 10)
if not exist %LIBRARY_LIB%\\pkgconfig\\pyside6.pc (echo "FATAL: Failed to find %LIBRARY_LIB%\\pkgconfig\\pyside6.pc" && exit 11)
if not exist %LIBRARY_LIB%\\pkgconfig\\shiboken6.pc (echo "FATAL: Failed to find %LIBRARY_LIB%\\pkgconfig\\shiboken6.pc" && exit 12)

if not exist %PREFIX%\\Library\\lib\\qt6\\uic.exe (echo "FATAL: Failed to find uic.exe (qtbase-devel)" && exit 13)
if not exist %PREFIX%\\Library\\lib\\qt6\\rcc.exe (echo "FATAL: Failed to find rcc.exe (qtbase-devel)" && exit 14)

pyside6-uic -help
if errorlevel 1 exit 1

echo ^<?xml version="1.0" encoding="UTF-8"?^> > test.ui
echo ^<ui version="4.0"^> >> test.ui
echo     ^<class^>MainWindow^</class^> >> test.ui
echo     ^<widget class="QMainWindow" name="MainWindow"^> >> test.ui
echo         ^<widget class="QWidget" name="centralwidget"^> >> test.ui
echo             ^<layout class="QVBoxLayout" name="verticalLayout"^> >> test.ui
echo                 ^<item^>^<widget class="QPushButton" name="pushButton"^>^<property name="text"^>^<string^>OK^</string^>^</property^>^</widget^>^</item^> >> test.ui
echo             ^</layout^> >> test.ui
echo         ^</widget^> >> test.ui
echo     ^</widget^> >> test.ui
echo     ^<resources/^> >> test.ui
echo     ^<connections/^> >> test.ui
echo ^</ui^> >> test.ui

pyside6-uic test.ui -o test_ui.py
if errorlevel 1 exit 1
if not exist test_ui.py (echo "FATAL: did not generate test_ui.py" && exit 15)
for %%F in (test_ui.py) do if %%~zF==0 (echo "FATAL: test_ui.py empty" && exit 16)

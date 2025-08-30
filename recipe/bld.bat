set LLVM_INSTALL_DIR=%LIBRARY_PREFIX%

echo Building: shiboken6

cd %SRC_DIR%\sources\shiboken6

cmake -LAH -G "Ninja"                               ^
    -DCMAKE_PREFIX_PATH="%LIBRARY_PREFIX%"          ^
    -DCMAKE_INSTALL_PREFIX="%LIBRARY_PREFIX%"       ^
    -DCMAKE_UNITY_BUILD=ON                          ^
    -DCMAKE_UNITY_BUILD_BATCH_SIZE=32               ^
    -DPYTHON_SITE_PACKAGES="%SP_DIR:\=/%"           ^
    -DCMAKE_BUILD_TYPE=Release                      ^
    -DFORCE_LIMITED_API=OFF                         ^
    -DBUILD_TESTS=OFF                               ^
    -DPython_EXECUTABLE="%PYTHON%"                  ^
    .
if errorlevel 1 exit 1

cmake --build . --target install
if errorlevel 1 exit 1

mkdir %SP_DIR%\shiboken6-%PKG_VERSION%.dist-info
copy %RECIPE_DIR%\METADATA.shiboken6.in %SP_DIR%\shiboken6-%PKG_VERSION%.dist-info\METADATA
copy %RECIPE_DIR%\INSTALLER.in %SP_DIR%\shiboken6-%PKG_VERSION%.dist-info\INSTALLER
echo Version: %PKG_VERSION% >> %SP_DIR%\shiboken6-%PKG_VERSION%.dist-info\METADATA

echo Done: shiboken6
echo Building: pyside6

cd %SRC_DIR%\sources\pyside6

cmake -LAH -G "Ninja"                               ^
    -DCMAKE_PREFIX_PATH="%LIBRARY_PREFIX%"          ^
    -DCMAKE_INSTALL_PREFIX="%LIBRARY_PREFIX%"       ^
    -DCMAKE_UNITY_BUILD=ON                          ^
    -DCMAKE_UNITY_BUILD_BATCH_SIZE=32               ^
    -DPYTHON_SITE_PACKAGES="%SP_DIR:\=/%"           ^
    -DCMAKE_BUILD_TYPE=Release                      ^
    -DPython_EXECUTABLE="%PYTHON%"                  ^
    -DFORCE_LIMITED_API=OFF                         ^
    .
if errorlevel 1 exit 1

cmake --build . --target install
if errorlevel 1 exit 1

mkdir %SP_DIR%\PySide6-%PKG_VERSION%.dist-info
copy %RECIPE_DIR%\METADATA.pyside6.in %SP_DIR%\PySide6-%PKG_VERSION%.dist-info\METADATA
copy %RECIPE_DIR%\INSTALLER.in %SP_DIR%\PySide6-%PKG_VERSION%.dist-info\INSTALLER
echo Version: %PKG_VERSION% >> %SP_DIR%\PySide6-%PKG_VERSION%.dist-info\METADATA
type %SP_DIR%\PySide6-%PKG_VERSION%.dist-info\METADATA

echo Done: pyside6
echo Building: pyside-tools

cd %SRC_DIR%\sources\pyside-tools
mkdir build && cd build

cmake -LAH -G"Ninja"                                ^
    -DCMAKE_PREFIX_PATH="%LIBRARY_PREFIX%"          ^
    -DCMAKE_INSTALL_PREFIX="%LIBRARY_PREFIX%"       ^
    -DCMAKE_BUILD_TYPE=Release                      ^
    -DPython_EXECUTABLE="%PYTHON%"                  ^
    ..
if errorlevel 1 exit 1

cmake --build . --target install
if errorlevel 1 exit 1

:: Move pyside_tool.py to the right location
mkdir %SP_DIR%\PySide6\scripts
type nul > %SP_DIR%\PySide6\scripts\__init__.py
move %LIBRARY_PREFIX%\bin\pyside_tool.py %SP_DIR%\PySide6\scripts\pyside_tool.py

echo Done: pyside-tools

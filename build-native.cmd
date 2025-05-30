@setlocal
@echo off

set SCRIPT_PATH=%~dp0
set BUILD_CONFIG=Release
set BUILD_ARCH=x64
set BUILD_CMAKE_GENERATOR_PLATFORM=x64

goto :ArgLoop
:ArgLoop
if [%1] == [] goto Build
if /i [%1] == [Release] (set BUILD_CONFIG=Release&& shift & goto ArgLoop)
if /i [%1] == [Debug] (set BUILD_CONFIG=Debug&& shift & goto ArgLoop)
if /i [%1] == [x64] (set BUILD_ARCH=x64&& shift & goto ArgLoop)
if /i [%1] == [x86] (set BUILD_ARCH=x86&& set BUILD_CMAKE_GENERATOR_PLATFORM=Win32&&shift & goto ArgLoop)
shift
goto ArgLoop

:Build
pushd %SCRIPT_PATH%

If NOT exist ".\build\%BUILD_ARCH%" (
  mkdir build\%BUILD_ARCH%
)
pushd build\%BUILD_ARCH%
cmake -DCMAKE_GENERATOR_PLATFORM=%BUILD_CMAKE_GENERATOR_PLATFORM% ..\.. "-DCMAKE_TOOLCHAIN_FILE=C:/vcpkg/scripts/buildsystems/vcpkg.cmake"

echo Calling cmake --build . --config %BUILD_CONFIG%
cmake --build . --config %BUILD_CONFIG%
popd
popd

:Success
exit /b 0


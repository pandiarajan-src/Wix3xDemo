@ECHO off
REM All the Default environment variable can be set here 
REM Mostly they are PC specific

REM Define & Identify path
SET ROOT_DRIVE=%~d0
SET PROJ_ROOT_DIR=%CD%
SET BUILD_DIR=%PROJ_ROOT_DIR%\Build
SET BUILD_BIN_DIR=%PROJ_ROOT_DIR%\Build\Bin
SET BUILD_OBJ_DIR=%PROJ_ROOT_DIR%\Build\IntermediateFiles
SET BUILD_REL_DIR=%PROJ_ROOT_DIR%\Build\Release

REM Visual studio path
SET VISUAL_STUDIO_ROOT="C:\Program Files (x86)\Microsoft Visual Studio\2019\Community"
SET VISUAL_STUDIO_IDE_PATH=%VISUAL_STUDIO_ROOT%\Common7\IDE
SET MSBUILDLOC=C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\MSBuild\Current\Bin
SET SDK10BIN_TOOLS="C:\Program Files (x86)\Microsoft SDKs\Windows\v10.0A\bin\NETFX 4.8 Tools"
SET WIXPATH=C:\Program Files (x86)\WiX Toolset v3.11\bin

ECHO "Solution Folder             : %PROJ_ROOT_DIR%"
ECHO "Visual Studio Folder        : %VISUAL_STUDIO_IDE_PATH%"
ECHO "MSBuild Folder              : %MSBUILDLOC%"

@ECHO off

cd /d %~dp0

REM Setup project and DDK folder locations and start the IDE
CALL ENV.BAT

REM Launch the IDE
ECHO "Going to launch Visual Studio exe"
START "Launch IDE" %VISUAL_STUDIO_IDE_PATH%\devenv.exe "%PROJ_ROOT_DIR%\src\Wix3xDemoApps.sln"

Echo "Run IDE Done"

:EXIT

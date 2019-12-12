@ECHO off

REM of the batch file, %~d0 is the drive letter only, and %~dp0 is the drive letter and path.)
cd /d %~dp0

REM Setup project and DDK folder locations and start the IDE
CALL ENV.BAT

SET BUILD_STATUS=0
SET ReleaseConfig=Release

:loop
IF NOT "%1"=="" (
	IF "%1"=="-Debug" (
	        SET ReleaseConfig=Debug
	)
	IF "%1"=="-help" (
	    echo "Usage: Build.bat <options>"
		echo "options are following:"
		echo "-help            To show this help message"
		echo "-Debug           Do Debug build"
		echo "-Release         Do Release build"
		echo --------------------------------------------------------------------------------
		GOTO :END
	)
    SHIFT
    GOTO :loop	
)

ECHO "Build Config                : %ReleaseConfig%"

REM Create build and Release directory
IF NOT EXIST %BUILD_BIN_DIR% mkdir %BUILD_BIN_DIR%
IF NOT EXIST %BUILD_OBJ_DIR% mkdir %BUILD_OBJ_DIR%
IF NOT EXIST %BUILD_REL_DIR% mkdir %BUILD_REL_DIR%
IF NOT EXIST %BUILD_REL_DIR%\runtimes mkdir %BUILD_REL_DIR%\runtimes

ECHO =================================Build Start================================
ECHO Apps are building: It does not include WIX project build, it just builds dll/exe required for MSI package

@"%MSBUILDLOC%\MSBuild.exe" "%PROJ_ROOT_DIR%\src\Wix3xDemoApps.sln" /t:Clean,Build /p:Configuration=%ReleaseConfig% 
IF NOT %ERRORLEVEL%==0 GOTO BUILDERROR

:COPY

@COPY %PROJ_ROOT_DIR%\src\wix3xdemodb.db %BUILD_REL_DIR% /Y
@COPY %BUILD_BIN_DIR%\%ReleaseConfig%\netcoreapp3.0\*.dll %BUILD_REL_DIR% /Y
@COPY %BUILD_BIN_DIR%\%ReleaseConfig%\netcoreapp3.0\*.exe %BUILD_REL_DIR% /Y
@COPY %BUILD_BIN_DIR%\%ReleaseConfig%\netcoreapp3.0\*.json %BUILD_REL_DIR% /Y
xcopy /e /v %BUILD_BIN_DIR%\%ReleaseConfig%\netcoreapp3.0\runtimes %BUILD_REL_DIR%\runtimes\

ECHO Installer is building: 
@"%MSBUILDLOC%\MSBuild.exe" "%PROJ_ROOT_DIR%\src\Wix3xDemoInstaller\Wix3xDemoInstaller.wixproj" /t:Clean,Build /p:Configuration=%ReleaseConfig% 
IF NOT %ERRORLEVEL%==0 GOTO BUILDERROR

ECHO =================================Build End=============================================

GOTO END

:BUILDERROR
REM Build error has occured, hence setting the build status to fail.
ECHO Build error has occured!!!
SET BUILD_STATUS=1

:END


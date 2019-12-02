@ECHO off
REM ECHO Merging multiple lanague MSI files into single MSI files

REM Setup project and DDK folder locations and start the IDE
CALL ..\..\Default.BAT

SET MSIPlatform=%1
SET MSIConfig=%2

SET MSIWixObjFilePath=%BUILD_OBJ_DIR%\%MSIConfig%\Wix3xDemoInstaller
SET MSIProjectPath=%PROJ_ROOT_DIR%\src\Wix3xDemoInstaller
SET MSIEnglishPath=%BUILD_REL_DIR%\Installer\%MSIConfig%\en-US
SET MSIReleasePath=%BUILD_REL_DIR%\Installer\%MSIConfig%
SET MSIFinalReleasePath=%BUILD_REL_DIR%\FinalInstaller
SET MSIFileName=Wix3XDemo_%MSIConfig%_Installer
SET MSILocalizationPath=Localization
SET MSIEULAPath=%MSIProjectPath%\EULA
SET MSISUPPORTLANG=1033
SET WINVBSPATH=C:\Program Files (x86)\Windows Kits\10\bin\10.0.18362.0\x64

CD %MSIProjectPath%

ECHO "==========================================================================================================================================="

ECHO "===For en-US 1033==="

@"%WIXPATH%\light.exe" -out "%MSIEnglishPath%\%MSIFileName%_en-US.msi" -cultures:en-US -ext "%WIXPATH%\WixUtilExtension.dll" -ext "%WIXPATH%\WixUIExtension.dll" -ext "%WIXPATH%\WixNetFxExtension.dll" -loc "%MSILocalizationPath%\en-US.wxl" -wixprojectfile "%MSIProjectPath%\Wix3xDemoInstaller.wixproj" -fv -sice:ICE91 -sw1076 -dWixUILicenseRtf="%MSIEULAPath%\CommonEULA-en-US.rtf" %MSIWixObjFilePath%\ApplicationFiles.wixobj %MSIWixObjFilePath%\MSRedist.wixobj %MSIWixObjFilePath%\Product.wixobj %MSIWixObjFilePath%\ShortCut_Registry.wixobj 

REM Update Banner Title and subtitle font and color
@C:\Windows\System32\cscript.exe "%MSIProjectPath%\CustomWix.js" "%MSIEnglishPath%\%MSIFileName%_en-US.msi" en-US

ECHO "Copying english file to dest file"
@COPY "%MSIEnglishPath%\%MSIFileName%_en-US.msi" "%MSIReleasePath%\%MSIFileName%_MUI.msi"

CALL TranslationTransform.bat de-DE 1031
CALL TranslationTransform.bat fi-FI 1035
CALL TranslationTransform.bat fr-FR 1036
CALL TranslationTransform.bat ru-RU 1049
CALL TranslationTransform.bat zh-CN 2052

ECHO "Update Package language codes"
ECHO %MSISUPPORTLANG%
@C:\Windows\System32\cscript.exe "%WINVBSPATH%\wilangid.vbs" "%MSIReleasePath%\%MSIFileName%_MUI.msi" Package %MSISUPPORTLANG%

IF EXIST %MSIFinalReleasePath% GOTO WIXFINALBUILDDIREXISTS
md %MSIFinalReleasePath%
:WIXFINALBUILDDIREXISTS

@COPY "%MSIReleasePath%\%MSIFileName%_MUI.msi" "%MSIFinalReleasePath%\%MSIFileName%.msi"

:END
ECHO "End"
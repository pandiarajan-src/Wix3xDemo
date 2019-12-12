@ECHO off
REM TranslationTransform.bat

set MSICultureCode=%1
set MSILangCode=%2

SET MSISUPPORTLANG=%MSISUPPORTLANG%,%MSILangCode%

ECHO "==========For %MSICultureCode% %MSILangCode%=========="

REM Use Light.exe to get MSI file
@"%WIXPATH%\light.exe" -out "%MSIEnglishPath%\%MSIFileName%_%MSICultureCode%.msi" -cultures:%MSICultureCode%,en-US -ext "%WIXPATH%\WixUtilExtension.dll" -ext "%WIXPATH%\WixUIExtension.dll" -ext "%WIXPATH%\WixNetFxExtension.dll" -loc "%MSILocalizationPath%\%MSICultureCode%.wxl" -wixprojectfile "%MSIProjectPath%\Wix3xDemoInstaller.wixproj" -fv -sice:ICE91 -sw1076 -dWixUILicenseRtf="%MSIEULAPath%\CommonEULA-%MSICultureCode%.rtf" %MSIWixObjFilePath%\ApplicationFiles.wixobj %MSIWixObjFilePath%\Product.wixobj %MSIWixObjFilePath%\MSRedist.wixobj %MSIWixObjFilePath%\ShortCut_Registry.wixobj 

REM Use Torch.exe to generate culture specific transform file MST
@"%WIXPATH%\torch.exe" -p -t language "%MSIEnglishPath%\%MSIFileName%_en-US.msi" "%MSIEnglishPath%\%MSIFileName%_%MSICultureCode%.msi" -out "%MSIEnglishPath%\%MSICultureCode%.mst"

REM Use WiSubStg.vbs to Merge culture transfrom files into one"
@C:\Windows\System32\cscript.exe "%WINVBSPATH%\WiSubStg.vbs" "%MSIReleasePath%\%MSIFileName%_MUI.msi" "%MSIEnglishPath%\%MSICultureCode%.mst" %MSILangCode%
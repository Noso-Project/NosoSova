@echo off
echo Create release NosoSova

@echo off
title Create release NosoSova

rem empty

@echo off
echo  Create directories
cd ..
mkdir Release >nul
del /Q /F Release\*.* >nul
echo Build NosoSova
call flutter clean >nul
call flutter build windows
echo NosoSova build success,

xcopy build\windows\x64\runner\Release Release\NosoSova  /E /I /Y >nul

echo Task finished, result as Release
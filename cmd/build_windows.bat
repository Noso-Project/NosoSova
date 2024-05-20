@echo off
echo Create release NosoSova + SovaRpc

@echo off
title Create release NosoSova + SovaRpc

rem empty

@echo off
echo  Create directories
cd ..
mkdir Release >nul
del /Q /F Release\*.* >nul
echo Build NosoSova
call flutter clean >nul
call flutter build windows
echo NosoSova build success, start build SovaRPC

@echo off
cd sovarpc
echo Build SovaRPC
call flutter clean >nul
call flutter build windows
cd ..
echo SovaRPC build success


xcopy build\windows\x64\runner\Release Release\NosoSova  /E /I /Y >nul
xcopy sovarpc\build\windows\x64\runner\Release Release\SovaRPC /E /I /Y >nul

echo Task finished, result as Release
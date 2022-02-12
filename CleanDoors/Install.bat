@echo off
title Установка патча
@if not exist grasses.pck goto :notfoundreqfiles
@if not exist newgrasses.pck goto :notfoundpatchfiles
@if not exist oldgrasses.pck goto :notfoundpatchfiles
@if not exist sPCK.exe goto :notfoundpatchfiles
@if not exist UnInstall.bat goto :notfoundpatchfiles
@goto :install
:notfoundreqfiles
echo Не найден файл grasses.pck!
echo.
echo Все файлы из архива нужно распаковать в
echo \Perfect World\element\
echo.
echo.
pause
exit
:notfoundpatchfiles
echo Не найдены необходимые файлы для установки патча!
echo.
echo Все файлы из архива нужно распаковать в
echo \Perfect World\element\
echo.
echo.
pause
exit
:install
md workdir
copy newgrasses.pck workdir\newgrasses.pck
sPCK -x workdir\newgrasses.pck
copy grasses.pck workdir\grasses.pck
sPCK -x workdir\grasses.pck
xcopy "workdir\newgrasses.pck.files" workdir\grasses.pck.files\*.* /S /Y
sPCK -c workdir\grasses.pck.files
copy workdir\grasses.pck grasses.pck
del newgrasses.pck /Q
rmdir workdir /S /Q
cls
echo Установка патча завершена
echo.
echo Перезагрузите игру если она запущена
echo чтобы изменения пришли в силу.
echo.
pause
del Install.bat /Q
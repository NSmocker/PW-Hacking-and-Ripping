@echo off
title Удаление патча
@if not exist grasses.pck goto :notfoundreqfiles
@if not exist oldgrasses.pck goto :notfoundpatchfiles
@if not exist sPCK.exe goto :notfoundpatchfiles
@goto :uninstall
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
:uninstall
md workdir
copy oldgrasses.pck workdir\oldgrasses.pck
sPCK -x workdir\oldgrasses.pck
copy grasses.pck workdir\grasses.pck
sPCK -x workdir\grasses.pck
xcopy "workdir\oldgrasses.pck.files" workdir\grasses.pck.files\*.* /S /Y
sPCK -c workdir\grasses.pck.files
copy workdir\grasses.pck grasses.pck
del oldgrasses.pck /Q
del sPCK.exe /Q
rmdir workdir /S /Q
cls
echo Установка патча завершена
echo.
echo Перезагрузите игру если она запущена
echo чтобы изменения пришли в силу.
echo.
pause
del Uninstall.bat /Q
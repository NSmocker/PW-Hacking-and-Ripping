@echo off
title �������� ����
@if not exist grasses.pck goto :notfoundreqfiles
@if not exist oldgrasses.pck goto :notfoundpatchfiles
@if not exist sPCK.exe goto :notfoundpatchfiles
@goto :uninstall
:notfoundreqfiles
echo �� ������ 䠩� grasses.pck!
echo.
echo �� 䠩�� �� ��娢� �㦭� �ᯠ������ �
echo \Perfect World\element\
echo.
echo.
pause
exit
:notfoundpatchfiles
echo �� ������� ����室��� 䠩�� ��� ��⠭���� ����!
echo.
echo �� 䠩�� �� ��娢� �㦭� �ᯠ������ �
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
echo ��⠭���� ���� �����襭�
echo.
echo ��१���㧨� ���� �᫨ ��� ����饭�
echo �⮡� ��������� ��諨 � ᨫ�.
echo.
pause
del Uninstall.bat /Q
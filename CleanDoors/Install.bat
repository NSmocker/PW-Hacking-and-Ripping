@echo off
title ��⠭���� ����
@if not exist grasses.pck goto :notfoundreqfiles
@if not exist newgrasses.pck goto :notfoundpatchfiles
@if not exist oldgrasses.pck goto :notfoundpatchfiles
@if not exist sPCK.exe goto :notfoundpatchfiles
@if not exist UnInstall.bat goto :notfoundpatchfiles
@goto :install
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
echo ��⠭���� ���� �����襭�
echo.
echo ��१���㧨� ���� �᫨ ��� ����饭�
echo �⮡� ��������� ��諨 � ᨫ�.
echo.
pause
del Install.bat /Q
echo off

:::::::::::::::::::::::::::::::::::::::::::::::
:::					    :::
::: set MASMPATH and MASMLIBPATH below 	    :::
:::					    :::
:::::::::::::::::::::::::::::::::::::::::::::::

:: make sure you add the path to ml.exe and link.exe
:: if you are using windows machine, it is normally C:\masm32\bin
:: if you are using wine on Mac, it may be under your virtual C drive. 
:: one way to check that is to run cmd.exe (on Mac, run "wine cmd.exe")
:: go to the directory contains ml.exe and link.exe
:: and type "echo %cd%" to get the full path

set MASMPATH=C:\masm32\bin

:: make sure you add the path to libraries: user32.lib, kernel32.lib, gdi32.lib, masm32.lib
:: those libraries normally live in C:\masm32\lib on windows
:: if using wine on Mac, same trick as above.

set MASMLIBPATH=C:\masm32\lib



set MASMINCPATH=C:\masm32\include

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::
::: DO NOT NEED TO MODIFY ANYTHING BELOW
:::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

set path=%path%;%MASMPATH%

ml  /I%MASMINCPATH% /c  /coff  /Cp stars.asm

if %errorlevel% neq 0 goto :error

ml  /I%MASMINCPATH% /c  /coff  /Cp lines.asm

if %errorlevel% neq 0 goto :error

ml  /I%MASMINCPATH% /c  /coff  /Cp trig.asm

if %errorlevel% neq 0 goto :error

ml  /I%MASMINCPATH% /c  /coff  /Cp blit.asm

if %errorlevel% neq 0 goto :error

ml  /I%MASMINCPATH% /c  /coff  /Cp game.asm

if %errorlevel% neq 0 goto :error

ml /I%MASMINCPATH% /c /coff /Cp ironman.asm

if %errorlevel% neq 0 goto :error

ml /I%MASMINCPATH% /c /coff /Cp thanos.asm

if %errorlevel% neq 0 goto :error

ml /I%MASMINCPATH% /c /coff /Cp gauntlet.asm

if %errorlevel% neq 0 goto :error

ml /I%MASMINCPATH% /c /coff /Cp red.asm

if %errorlevel% neq 0 goto :error

ml /I%MASMINCPATH% /c /coff /Cp orange.asm

if %errorlevel% neq 0 goto :error

ml /I%MASMINCPATH% /c /coff /Cp yellow.asm

if %errorlevel% neq 0 goto :error

ml /I%MASMINCPATH% /c /coff /Cp green.asm

if %errorlevel% neq 0 goto :error

ml /I%MASMINCPATH% /c /coff /Cp blue.asm

if %errorlevel% neq 0 goto :error

ml /I%MASMINCPATH% /c /coff /Cp purple.asm

if %errorlevel% neq 0 goto :error

ml /I%MASMINCPATH% /c /coff /Cp captainamerica.asm

if %errorlevel% neq 0 goto :error

ml /I%MASMINCPATH% /c /coff /Cp thor.asm

if %errorlevel% neq 0 goto :error

ml /I%MASMINCPATH% /c /coff /Cp spiderman.asm

if %errorlevel% neq 0 goto :error

ml /I%MASMINCPATH% /c /coff /Cp groot.asm

if %errorlevel% neq 0 goto :error

ml /I%MASMINCPATH% /c /coff /Cp antman.asm

if %errorlevel% neq 0 goto :error

link /SUBSYSTEM:WINDOWS  /LIBPATH:%MASMLIBPATH% game.obj blit.obj trig.obj lines.obj stars.obj ironman.obj thanos.obj gauntlet.obj red.obj orange.obj yellow.obj green.obj blue.obj purple.obj captainamerica.obj thor.obj spiderman.obj groot.obj antman.obj libgame.obj

if %errorlevel% neq 0 goto :error

pause
	echo Executable built succesfully.

goto :EOF

:error
echo Failed with error #%errorlevel%
pause


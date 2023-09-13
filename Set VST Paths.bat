ECHO OFF
color 0F
cls
net session >nul 2>&1
if %errorLevel% == 0 (
    GOTO MENU
) else (
	echo +===============================================+
	echo Set VST paths tool                              .
	echo +===============================================+
    echo Script is not running with                      .
	echo administrative privileges                       .
	echo Please start the script as admin, as it needs   .
	echo to write to the registry                        .
	echo +===============================================+
	echo Press any key to exit                           .
	echo +===============================================+
	pause >nul
	GOTO EXIT
)
pause

:MENU
color 0F
cls
echo +===============================================+
echo Set VST paths tool                              .
echo +===============================================+
echo Current 32bit Path:
for /f "tokens=2*" %%a in ('reg query "HKLM\SOFTWARE\WOW6432Node\VST" /v VSTPluginsPath') do @echo     %%b
echo Current 64bit Path:
for /f "tokens=2*" %%a in ('reg query "HKEY_LOCAL_MACHINE\SOFTWARE\VST" /v VSTPluginsPath') do @echo     %%b
echo +===============================================+
echo Select option:                                  .
echo +===============================================+
echo 01. Reload paths                                .
echo 02. Set 32bit path                              .
echo 03. Set 64bit path                              .
echo 04. Export current paths to (Desktop)           .
echo 05. EXIT                                        .
echo +===============================================+
set /p MENU_OPTION="OPTION: "

IF %MENU_OPTION%==1  GOTO MENU
IF %MENU_OPTION%==01 GOTO MENU
IF %MENU_OPTION%==2  GOTO SEL32
IF %MENU_OPTION%==02 GOTO SEL32
IF %MENU_OPTION%==3  GOTO SEL64
IF %MENU_OPTION%==03 GOTO SEL64
IF %MENU_OPTION%==4  GOTO EXPORTCURRENT
IF %MENU_OPTION%==04 GOTO EXPORTCURRENT
IF %MENU_OPTION%==5 GOTO EXIT
IF %MENU_OPTION%==e GOTO EXIT
IF %MENU_OPTION%==false GOTO WRONGOPTION

:WRONGOPTION
echo +===============================================+
echo The option "%MENU_OPTION%" does not exist.
echo +===============================================+
echo Press any key to return                         .
echo +===============================================+
pause >nul
GOTO MENU

:SEL32
cls
echo +===============================================+
echo 02. Set 32bit path                              .
echo +===============================================+
echo Please enter the path you want to set:          .
set SET32PATH=
set /p SET32PATH="PATH: "
cls
echo +===============================================+
echo Please enter the path you want to set:          .
echo +===============================================+
echo PATH: [31m%SET32PATH%[0m
echo +===============================================+
echo Are you sure that this is the right path?       .
echo Do you want to proceed? (Y/N)
choice /c YN /n /m "Enter Y or N:"
if errorlevel 2 (
    GOTO MENU
) else (
	cls
	reg add "HKLM\SOFTWARE\WOW6432Node\VST" /t REG_SZ /v VSTPluginsPath /d "%SET32PATH%" /f
	echo +===============================================+
	echo 02. Set 32bit path                 .
	echo +===============================================+
	echo The 32bit path is now updated to:
	for /f "tokens=2*" %%a in ('reg query "HKLM\SOFTWARE\WOW6432Node\VST" /v VSTPluginsPath') do @echo %%b	
	echo +===============================================+
	echo Press any key to return to menu                 .
	echo +===============================================+
	pause >nul
	GOTO MENU
	
)

:SEL64
cls
echo +===============================================+
echo 03. Set 64bit path                              .
echo +===============================================+
echo Please enter the path you want to set:          .
set SET64PATH=
set /p SET64PATH="PATH: "
cls
echo +===============================================+
echo Please enter the path you want to set:          .
echo +===============================================+
echo PATH: [31m%SET64PATH%[0m
echo +===============================================+
echo Are you sure that this is the right path?       .
echo Do you want to proceed? (Y/N)
choice /c YN /n /m "Enter Y or N:"
if errorlevel 2 (
    GOTO MENU
) else (
	cls
	color 0F
	reg add "HKEY_LOCAL_MACHINE\SOFTWARE\VST" /t REG_SZ /v VSTPluginsPath /d "%SET64PATH%" /f
	echo +===============================================+
	echo 02. Set 64bit path                 .
	echo +===============================================+
	echo The 64bit path is now updated to:
	for /f "tokens=2*" %%a in ('reg query "HKEY_LOCAL_MACHINE\SOFTWARE\VST" /v VSTPluginsPath') do @echo %%b	
	echo +===============================================+
	echo Press any key to return to menu                 .
	echo +===============================================+
	pause >nul
	GOTO MENU
	
)

:EXPORTCURRENT
cls
echo +===============================================+
echo 04. Export current paths to (Desktop)           .
echo +===============================================+
echo Are you sure?                                   .
echo Do you want to proceed? (Y/N)
choice /c YN /n /m "Enter Y or N:"
if errorlevel 2 (
    GOTO MENU
) else (
	Reg Export "HKEY_LOCAL_MACHINE\SOFTWARE\VST" "%USERPROFILE%\Desktop\VST 64bit Backup.reg"
	Reg Export "HKLM\SOFTWARE\WOW6432Node\VST" "%USERPROFILE%\Desktop\VST 32bit Backup.reg"
	cls
	color 0F
	echo +===============================================+
	echo 04. Export current paths to file                .
	echo +===============================================+
	echo "VST 32bit Backup.reg" and                      .
	echo "VST 64bit Backup.reg" are exported to          .
	echo the Desktop, please move them to where ever you .
	echo want them to be.                                .
	echo +===============================================+
	echo Press any key to return to menu                 .
	echo +===============================================+
	pause >nul
	GOTO MENU
	
)

:EXIT
exit

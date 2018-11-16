@ECHO OFF
REM ***** CONFIGURE YOUR GIT FOLDER HERE *****
SET mpath=D:\git
REM *****      END OF CONFIGURATION      *****
SETLOCAL ENABLEDELAYEDEXPANSION

REM list folders
:PROJMENU
cd /d "%mpath%"
SET /a count=0
FOR /F "tokens=* USEBACKQ" %%F IN (`dir /a:d /b`) DO (
  SET /a count=!count!+1
  SET array[!count!]=%%F
)

call :strLen count len1
call :strLen mpath len2
set /a totlen=%len1%+%len2%
set strtest=
FOR /l %%v in (1,1,%totlen%) DO (
  SET strtest=!strtest!อ
)

echo ษอออออออออออออออออออออออออออออออออออออ%strtest%ป
echo บ You have %count% projects available under %mpath% บ
echo ศอออออออออออออออออออออออออออออออออออออ%strtest%ผ
FOR /l %%v in (1,1,%count%) DO (
  echo %%v - !array[%%v]!
)
echo ----------------------------------------
echo 96 - Status all projects
echo 97 - Pull all projects
echo 98 - Create new project
echo 99 - Global configuration (username and email)
echo 0 - Exit
echo ----------------------------------------
set /p projnum=Enter the project you wish to manage : 
if %projnum%==96 (
  cls
  GOTO STATUSALL
)
if %projnum%==97 (
  cls
  GOTO PULLALL
)
if %projnum%==98 (
  cls
  GOTO NEWPROJ
)
if %projnum%==99 GOTO GLOBCONF
if %projnum%==0 GOTO EOF

:ACTIONMENU
if %projnum% GTR 0 (
	if %projnum% LEQ %count% (
		call :strLen mpath len1
		call :strLen array[%projnum%] len2
		set /a totlen=%len1%+%len2%
		set strtest=
		FOR /l %%v in (1,1,%totlen%) DO (
		  SET strtest=!strtest!อ
		)
	) else (
		cls
		GOTO PROJMENU
	)
) else (
	cls
	GOTO PROJMENU
)

echo ษออออออออออออออออออออออ%strtest%ป
echo บ Selected project : %mpath%\!array[%projnum%]! บ
echo ศออออออออออออออออออออออ%strtest%ผ
echo 1 - pull
echo 2 - push
echo 3 - status
echo 4 - checkout
echo ----------------------------------------
echo 5 - Select another project
echo 0 - Exit
echo ----------------------------------------
set /p actionnum=Enter the action you want to do : 
if %actionnum%==1 GOTO PULL
if %actionnum%==2 GOTO PUSH
if %actionnum%==3 GOTO STATUS
if %actionnum%==4 GOTO CHECKOUT
if %actionnum%==5 (
  CLS
  GOTO PROJMENU
)
if %actionnum%==0 GOTO EOF
cls
GOTO ACTIONMENU

:NEWPROJ
cd /d "%mpath%"
set /p projname=Enter new project's name : 
if exist %projname% (
  echo directory already exists !
  GOTO PROJMENU
)
mkdir "%projname%"
cd "%projname%"
set /p projurl=Enter new project's URL : 
set /p alreadyExist=Is it new (0) or existing (1) : 
if %alreadyExist% == 1 (
  echo ## initializing...
  git init
  echo ## adding origin...
  git remote add origin %projurl%
  echo ## pulling project...
  git pull origin master
  echo ## setting default branch...
  git branch --set-upstream-to=origin/master master
) else (
  echo ## initializing...
  git init
  echo ## creating readme...
  echo ## README >> README.md
  echo todo >> README.md
  echo ## adding file to git...
  git add README.md
  echo ## commit modifications...
  git commit -m "first commit"
  echo ## adding origin...
  git remote add origin %projurl%
  echo ## pushing modifications...
  git push -u origin master
  echo ## setting default branch...
  git branch --set-upstream-to=origin/master master
)
GOTO PROJMENU

:PULL
cd "%mpath%\!array[%projnum%]!"
git pull
GOTO ACTIONMENU

:PULLALL
FOR /l %%v in (1,1,%count%) DO (
  cd "%mpath%\!array[%%v]!"
  echo.
  echo ## Pulling project !array[%%v]!...
  git pull
)
GOTO PROJMENU

:PUSH
cd "%mpath%\!array[%projnum%]!"
set /p input=Enter the commit message : 
echo ## adding files to git...
git add *
echo ## commit modifications...
git commit -m "%input%"
echo ## pushing modifications...
git push
GOTO ACTIONMENU

:STATUS
cd "%mpath%\!array[%projnum%]!"
git status
GOTO ACTIONMENU

:STATUSALL
FOR /l %%v in (1,1,%count%) DO (
  cd "%mpath%\!array[%%v]!"
  echo.
  echo ## Status of project !array[%%v]!...
  git status
)
GOTO PROJMENU

:CHECKOUT
cd "%mpath%\!array[%projnum%]!"
set /p input=Enter the file to checkout : 
git checkout %input%
GOTO ACTIONMENU

:GLOBCONF
set /p username=Enter the global name  : 
set /p useremail=Enter the global email : 
git config --global user.name "%username%"
git config --global user.email %useremail%
GOTO PROJMENU

:strLen

:strLen_Loop
   if not "!%1:~%len%!"=="" set /A len+=1 & goto :strLen_Loop
(set %2=%len%)
goto :eof

:EOF

ENDLOCAL

REM Notepad: +-+ ++ฆ +-+ - ฆ
REM cmd.exe: ฺยฟ รลด ภมู ฤ ณ

REM Notepad: +-+ ฆ+ฆ +-+ - ฆ
REM cmd.exe: ษหป ฬฮน ศสผ อ บ
@ECHO OFF
REM ***** CONFIGURE YOUR GIT FOLDER HERE *****
SET mpath=D:\git
REM *****      END OF CONFIGURATION      *****
SETLOCAL ENABLEDELAYEDEXPANSION

REM list folders
:PROJMENU
cd /d "%mpath%"
SET count=0
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
echo 98 - Create new project
echo 99 - Global configuration (username and email)
echo 0 - Exit
echo ----------------------------------------
set /p projnum=Enter the project you wish to manage : 
if %projnum%==98 (
  cls
  GOTO NEWPROJ
)
if %projnum%==99 GOTO GLOBCONF
if %projnum%==0 GOTO EOF
cls

:ACTIONMENU
call :strLen mpath len1
call :strLen array[%projnum%] len2
set /a totlen=%len1%+%len2%
set strtest=
FOR /l %%v in (1,1,%totlen%) DO (
  SET strtest=!strtest!อ
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
  git init
  git remote add origin %projurl%
  git pull origin master
  git branch --set-upstream-to=origin/master master
) else (
  git init
  echo ## README >> README.md
  echo todo >> README.md
  git add README.md
  git commit -m "first commit"
  git remote add origin %projurl%
  git push -u origin master
  git branch --set-upstream-to=origin/master master
)
GOTO PROJMENU

:PULL
cd "%mpath%\!array[%projnum%]!"
git pull
GOTO ACTIONMENU

:PUSH
cd "%mpath%\!array[%projnum%]!"
set /p input=Enter the commit message : 
git add *
git commit -m "%input%"
git push
GOTO ACTIONMENU

:STATUS
cd "%mpath%\!array[%projnum%]!"
git status
GOTO ACTIONMENU

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
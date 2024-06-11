@echo off

:: Finds the parent directory of the current directory.
for %%a in ("..") do (
	set parent=%%~fa
)

set name=FighterTester

set path=%path%;%CD%\_Tool
set file=%name%.swf
set output=%parent%\swf_output\%file%
set source=%CD%\#%name%\bin-release-temp\%file%

if exist "%output%" (
	echo Deleting file "%output%" ...
	del "%output%" /q
)

:: Check the source file
if not exist "%source%" (
	echo Source "%source%" does not exist ...
	goto :ERROR
)

:: Call the tool [ABCMerge] to optimize the file.
echo Optimization in progress...
echo SOURCE: [%source%]
echo OUTPUT: [%output%]
ABCMerge "%source%" >ABCMerge.log

set error=%errorlevel%
if not %error% == 0 (
	echo Error, exit code is %error%.
	goto :ERROR
)

move "%source%" "%output%" >nul
ren "%source%.bak" %file%

goto :END

:: If an error occurs, prompt and exit.
:ERROR
pause >nul
:END
exit
@echo off

if "%1" == "" goto error_Usage
set QTDIR=%1
if not exist %QTDIR% goto error_QTDIR_not_found

if "%2" == "" (
	set QTLIBDIR=lib
)

if exist %QTDIR%\%QTLIBDIR% (
set QTLIBDIR=%QTDIR%\%QTLIBDIR%
) else if not exist %QTLIBDIR% (
goto error_QTLIBDIR_not_found
)

set QTBINDIR=%QTDIR%\bin
if not exist %QTBINDIR% goto error_QTBINDIR_not_found

set UNXUTILSDIR=%~dp0unxutils
if not exist %UNXUTILSDIR% goto error_unxutils_not_found

@echo Fixing Qt paths...
set QTBINDIR=%QTDIR%\bin

set PATH=%QTBINDIR%;%PATH%
@echo Added %QTBINDIR% to PATH.

@rem Use sed to replace QTDIR in qt.conf.template with the absolute Qt
@rem   installation path, escaped with double backslashes.
copy %~dp0qt.conf.template %~dp0qt.conf
set QTDIR_ESCAPED_SLASHES=%QTDIR:\=\\\\%
set QTLIBDIR_ESCAPED_SLASHES=%QTLIBDIR:\=\\\\%
call %UNXUTILSDIR%\add-to-path
sed -i "s'QTDIR'%QTDIR_ESCAPED_SLASHES%'g" %~dp0qt.conf
sed -i "s'QTLIBDIR'%QTLIBDIR_ESCAPED_SLASHES%'g" %~dp0qt.conf

@rem Place qt.conf alongside qmake.
move %~dp0qt.conf %QTBINDIR%

@echo QTDIR is set to %QTDIR%
@echo.
@echo qt.conf written to %QTBINDIR%
@type %QTBINDIR%\qt.conf
@echo.

@goto end

:error_Usage
@echo Usage: %0 path\to\qt-base-directory [path\to\qt-libraries]
set ERRORLEV=1
@goto end

:error_QTDIR_not_found
@echo ERROR: Qt directory '%QTDIR%' does not exist.
set ERRORLEV=2
@goto end

:error_QTLIBDIR_not_found
@echo ERROR: Qt libraries directory '%QTLIBDIR%' does not exist.
set ERRORLEV=2
@goto end

:error_QTBINDIR_not_found
@echo ERROR: Qt binaries directory '%QTBINDIR%' does not exist.
set ERRORLEV=2
@goto end

:error_unxutils_not_found
@echo ERROR: 'unxutils' directory does not exist.
set ERRORLEV=3
@goto end

:end

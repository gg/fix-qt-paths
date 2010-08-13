@echo off

if "%1" == "" goto error_Usage

set QTDIR=%1
if not exist %QTDIR% goto error_QTDIR_not_found

set QTBINDIR=%QTDIR%\bin
if not exist %QTBINDIR% goto error_QTBINDIR_not_found

set SCRIPT_DIR=%~dp0

@rem Ensure that QTDIR and QTBINDIR have absolute paths.
cd %QTDIR%
set QTDIR=%CD%
set QTBINDIR=%QTDIR%\bin

set PATH=%QTBINDIR%;%PATH%
@echo Added %QTBINDIR% to PATH.

@rem The paths specified in qt.conf must be escaped (double backslashes).
set QTDIR_ESCAPED_SLASHES=%QTDIR:\=\\\\%

@rem Use sed to replace QTDIR in qt.conf.template with the absolute Qt
@rem   installation path with forward slashes.
@rem sed is part of UnxUtils, a collection of ports of common GNU utilities
@rem   to native Win32.
@rem For more about UnxUtils, see: http://unxutils.sourceforge.net
cp %SCRIPT_DIR%\qt.conf.template %SCRIPT_DIR%\qt.conf
%SCRIPT_DIR%\UnxUtils\sed -i "s'QTDIR'%QTDIR_ESCAPED_SLASHES%'g" %SCRIPT_DIR%\qt.conf

@rem Place qt.conf alongside qmake.
move %SCRIPT_DIR%\qt.conf %QTBINDIR%

@echo QTDIR is set to %QTDIR%
@echo.
@echo qt.conf written to %QTBINDIR%
@type %QTBINDIR%\qt.conf

@goto end


:error_Usage
@echo Usage: %0 path\to\qt-base-directory
set ERRORLEV=1
@goto end

:error_QTDIR_not_found
@echo ERROR: Qt directory '%QTDIR%' does not exist.
set ERRORLEV=2
@goto end

:error_QTBINDIR_not_found
@echo ERROR: Qt binaries directory '%QTBINDIR%' does not exist.
set ERRORLEV=2
@goto end

:end
cd %SCRIPT_DIR%

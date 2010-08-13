Usage: fix_qt_paths path\to\qt


The goal of this script is to allow for portable Qt installations.

When Qt is compiled, the Qt installation path is hard-coded into qmake.
The problem is when the Qt installation path changes, qmake will no
longer work without recompilation.

fix_qt_paths provides a work-around to this problem by placing a
qt.conf file in Qt's \bin directory (where qmake resides). qt.conf specifies
paths to the Qt installation that _override_ the hard-coded paths in
qmake. See http://doc.trolltech.com/4.6/qt-conf.html for details.

For convenience, fix_qt_paths also temporarily sets the QTDIR
environment variable to the Qt installation path, and temporarily adds
the Qt \bin directory to PATH. This allows for seamless integration with
build scripts.

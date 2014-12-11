# SQLite database

OPT="$OPT:/opt/sqlite/current/bin"

SQLITE_LD_LIBRARY_PATH="/opt/sqlite/current/lib"
SQLITE_LD_RUN_PATH="/opt/sqlite/current/lib"
SQLITE_LDFLAGS="-L/opt/sqlite/current/lib"

LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$SQLITE_LD_FLAGS"
LD_RUN_PATH="$LD_RUN_PATH:$SQLITE_LD_RUN_PATH"
LDFLAGS="$LDFLAGS $SQLITE_LDFLAGS"

# Library Settings
#
# You can specify the full pathname of the library,
# or use the `-LLIBDIR' flag during linking and do
# at least one of the following:
#
#   * add LIBDIR to the `LD_LIBRARY_PATH' environment variable during execution
#   * add LIBDIR to the `LD_RUN_PATH' environment variable during linking
#   * use the `-Wl,--rpath -Wl,LIBDIR' linker flag
#   * have your system administrator add LIBDIR to `/etc/ld.so.conf'
#
# We include all of them we use in all the settings we've encountered;
# you may want to tune this for your particular system or need.
#
# From http://www.eyrie.org/~eagle/notes/rpath.html
#
# Here's a brief primer on the way that this works on Solaris and Linux.
# The search paths for libraries come from three sources:
#
#   * the environment variable LD_LIBRARY_PATH (if set)
#   * any rpath encoded in the binary (more on this later)
#   * the system default search paths.
#
# The sources are searched in this order, and the first matching library is used.
#
# From http://www.netbsd.org/docs/pkgsrc/configuring.html
#
# If you want to pass flags to the linker, both in the configure step and the build step,
# you can do this in two ways: either set LDFLAGS or LIBS. The difference between the two
# is that LIBS will be appended to the command line, while LDFLAGS come earlier.
#
# From http://xahlee.org/UnixResource_dir/_/ldpath.html
#
# Some good examples of how LD_LIBRARY_PATH is used:
#
#   * When upgrading shared libraries, you can test out a library before replacing it.
#     In a similar vein, in case your upgrade program depends on shared libraries and
#     may freak out if you replace a shared library out from under it, you can use
#     LD_LIBRARY_PATH to point to a directory with copy of a shared libraries and
#     then you can replace the system copy without worry. You can even undo things
#     should things fail by moving the copy back.
#
#   * X11 uses LD_LIBRARY_PATH during its build process. X11 distributes its fonts
#     in “bdf” format, and during the build process it needs to “compile” the bdf
#     files into “pcf” files. LD_LIBRARY_PATH is used to point the the build lib
#     directory so it can run bdftopcf during the build stage before the shared
#     libraries are installed.
#
#   * Perl can be installed with most of its core code as a shared library.
#     This is handy if you embed Perl in other programs -- you can compile them
#     so they use the shared library and so you'll save memory at run time.
#     However Perl uses Perl scripts at various points in the build and install.
#     The 'perl' binary won't run until its shared libraries are installed,
#     unless LD_LIBRARY_PATH is used to bootstrap the process.

LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/opt/gmp/current/lib:/opt/subversion/current/lib:/opt/yaml/current/lib:/lib32:/usr/lib32:/usr/local/pgsql/lib"
LD_RUN_PATH="$LD_RUN_PATH:/opt/gmp/current/lib:/opt/subversion/current/lib:/opt/yaml/current/lib"
LDFLAGS="$LDFLAGS -L/opt/gmp/current/lib -L/opt/subversion/current/lib -L/opt/yaml/current/lib"

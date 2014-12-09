# JRuby Java Runtime

JRUBY_HOME=/opt/ruby/jruby/current

# Options:
#
#   * --1.9: run in Ruby 1.9 mode (vs. older 1.8 or newer experimental 2.0)
#
# Options for the JVM:
#
#   * -J-Xms: the memory allocation pool starting size.
#
#   * -J-Xmx: the memory allocation pool maximum size.
#
#   * -J-XX:ThreadStackSize=2048 (a.k.a. -J-Xss2048k): increase the
#     available memory for the stack; default on many systems is 1024.
#
#   * -J-XX:+CMSClassUnloadingEnabled and -J-XX:+UseConcMarkSweepGC:
#     The JVM keeps classes forever; the classes stay in PermGen forever.
#     If you're running a Ruby script that defines classes at runtime,
#     and on a server, the result is a memory that is never reclaimed.
#     Enable CMSClassUnloadingEnabled and UseConcMarkSweepGC to tell
#     the GC to sweep PermGen to remove classes which are no longer used.
#     Thanks to Aaron Digulla on StackOverflow for this explanation.
#
#   * -J-XX:+TieredCompilation and -J-XX:TieredStopAtLevel=1:
#     Tiered compilation, introduced in Java SE 7, brings client startup
#     speeds to the server VM. Normally, a server VM uses the interpreter
#     to collect profiling information about methods that is fed into the
#     compiler. In the tiered scheme, in addition to the interpreter,
#     the client compiler is used to generate compiled versions of methods
#     that collect profiling information about themselves.
#
# Options for Java 7 and earlier:
#
#   * -J-XX:MaxPermSize=256m: retired and ignored in Java 8.
#
#   * -Xcompile.invokedynamic=true: improve JRuby's performance on VMs
#    that support it; this is the default when running on OpenJDK 8 builds.
#    Java 7 brings with it an important new feature called invokedynamic,
#    which greatly improves JRuby's performance on VMs that support it.
#    However, current released versions of OpenJDK 7 sometimes error out or
#    fail to optimize code as well as they should. The use of invokedynamic
#    is off by default on Java 7, and on by default on Java 8.
#
# Options that we don't use here yet do use for faster testing:
#
#   * -J-noverify: Do not verify bytecodes
#
#   * -Xcompile.mode=OFF: Do not use Just In-Time Compilation.
#
JRUBY_OPTS="--1.9 -J-Xms1024m -J-Xmx1024m -J-XX:ThreadStackSize=2048 -J-XX:+CMSClassUnloadingEnabled -J-XX:+UseConcMarkSweepGC -J-XX:+TieredCompilation -J-XX:TieredStopAtLevel=1"

JRUBY_LD_LIBRARY_PATH="/opt/ruby/jruby/current/lib"
JRUBY_LD_RUN_PATH="/opt/ruby/jruby/current/lib"
JRUBY_LDFLAGS="-L/opt/jruby/current/lib"

# Append
LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$JRUBY_LD_LIBRARY_PATH"
LD_RUN_PATH="$LD_RUN_PATH:$JRUBY_LD_RUN_PATH"
LDFLAGS="$LDFLAGS $JRUBY_LDFLAGS"

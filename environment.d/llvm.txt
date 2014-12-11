# LLVM compiler

LLVM_MODULES="core jit native"
LLVM_LDFLAGS="-L/usr/local/opt/llvm/lib"
LLVM_CPPFLAGS="-I/usr/local/opt/llvm/include"

# Append
CPPFLAGS="$CPPFLAGS $LLVM_CPPFLAGS"
LDFLAGS="$LDFLAGS $LLVM_LDFLAGS"

#!/bin/bash

# set -e

make
.build/debug/llswift $@

echo "out.ll"
cat out.ll

echo "------------"
echo "lli run"
clang+llvm-4.0.0-x86_64-apple-darwin/bin/lli out.ll

echo "------------"
echo "generate binary"
clang+llvm-4.0.0-x86_64-apple-darwin/bin/clang out.ll

echo "------------"
echo "run a.out"
./a.out

echo "done"

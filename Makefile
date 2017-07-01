BUILD_DIR=.build/debug
LLVM_ROOT=clang+llvm-4.0.0-x86_64-apple-darwin

.PHONY: all clean build test xcodegen setup_llvm

all: build

clean:
	swift package clean

build:
	swift build

test: build
	swift test

xcodegen:
	swift package generate-xcodeproj --enable-code-coverage

setup_llvm:
	wget http://releases.llvm.org/4.0.0/clang+llvm-4.0.0-x86_64-apple-darwin.tar.xz
	tar zxvf clang+llvm-4.0.0-x86_64-apple-darwin.tar.xz

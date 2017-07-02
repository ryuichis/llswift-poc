#!/bin/bash

set -e

make
.build/debug/llswift $@

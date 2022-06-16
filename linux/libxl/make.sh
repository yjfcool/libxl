#!/bin/bash

source ../script_common.sh
source ../script_compile.sh

############################################################
#########################  执行编译 #########################
compile_cmake=2    ## 0:config-compile, 1:cmake-compile, 2:copy-compile
arr_dep_libs=("inc" "lib" "lib64")
make_params=""
so_key_find=""
so_key_replace=""

build "$compile_cmake" "${arr_dep_libs[*]}" "$make_params" "$so_key_find" "$so_key_replace"

#!/bin/bash
PROJECT_NAME="${1:-new-project}"
mkdir "$PROJECT_NAME"
cp -r ~/.config/nvim/cpp_cmake_template "$PROJECT_NAME/$PROJECT_NAME"
sed -i "s/cppExample/$PROJECT_NAME/g" "$PROJECT_NAME/$PROJECT_NAME/CMakeLists.txt"

cd "$PROJECT_NAME/$PROJECT_NAME"
nvim +trust +q --headless .nvim.lua

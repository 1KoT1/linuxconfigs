cmake_minimum_required(VERSION 3.10)

project(cppExample LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

#find_package(Poco 1.7.2 REQUIRED Foundation)

#if(not defined examplelib_source_dir)
#	add_subdirectory(../../core ${cmake_binary_dir}/examplelib exclude_from_all)
#endif(not defined examplelib_source_dir)

add_executable(cppExample
	src/main.cpp
	)

target_include_directories(cppExample PUBLIC
	include
	)

target_link_libraries(cppExample PUBLIC
	#	Poco::Foundation
	#	exampleLib
	)

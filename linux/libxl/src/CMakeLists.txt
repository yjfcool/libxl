﻿cmake_minimum_required(VERSION 3.8.0)
project(libxl_cracked)

macro(group_src_by_dir SRC_LIST)
    foreach(SRC_PATH ${${SRC_LIST}})
        string(REGEX REPLACE ${CMAKE_CURRENT_SOURCE_DIR}\(.*\) \\1 RELATIVE_PATH ${SRC_PATH})
        #message(STATUS ${RELATIVE_PATH})
        string(REGEX REPLACE "(/..)*/(.+)/.+/..*" \\2 GROUP_NAME ${RELATIVE_PATH})
        #message(STATUS ${GROUP_NAME})
        if(NOT RELATIVE_PATH STREQUAL GROUP_NAME)
            string(REPLACE "/" "\\" GROUP_NAME ${GROUP_NAME})
            source_group(${GROUP_NAME} FILES ${SRC_PATH})
        else()
            source_group("" FILES ${SRC_PATH})
        endif()
    endforeach(SRC_PATH)
endmacro(group_src_by_dir)

macro(group_inc_by_dir INC_LIST)
	foreach(INC_PATH ${${INC_LIST}})
		#message(STATUS ${CMAKE_CURRENT_SOURCE_DIR})
		string(REGEX REPLACE ${CMAKE_CURRENT_SOURCE_DIR}\(.+\) \\1 INC_RELATIVE_PATH ${INC_PATH})
        #message(STATUS ${INC_RELATIVE_PATH})
		string(REGEX REPLACE "(/..)*/(.+)/.+.h" \\2 GROUP_NAME ${INC_RELATIVE_PATH})
        #message(STATUS ${GROUP_NAME})
		if(NOT INC_RELATIVE_PATH STREQUAL GROUP_NAME)
            string(REPLACE "/" "\\" GROUP_NAME ${GROUP_NAME})
            source_group(${GROUP_NAME} FILES ${INC_PATH})
        else()
            source_group("" FILES ${INC_PATH})
        endif()
	endforeach(INC_PATH)
endmacro(group_inc_by_dir)

set_property(GLOBAL PROPERTY USE_FOLDERS ON)
set(CMAKE_CONFIGURATION_TYPES "Debug;Release" CACHE STRING "list of supported configurations." FORCE)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG ${PROJECT_SOURCE_DIR}/../bin)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELEASE ${PROJECT_SOURCE_DIR}/../bin)
if(WIN32)
    include_directories( ${PROJECT_SOURCE_DIR}/../inc/win32)
    link_directories( ${PROJECT_SOURCE_DIR}/../lib)
    link_libraries(libxl)
    add_compile_options(/W4 /WX)
elseif(UNIX)
    include_directories( ${PROJECT_SOURCE_DIR}/../inc/linux)
    link_directories( ${PROJECT_SOURCE_DIR}/../lib64)
    add_compile_options(-Wall -Werror -std=c++11)
    link_libraries(xl)
endif(WIN32)

file(GLOB_RECURSE src_files "${PROJECT_SOURCE_DIR}/*.cpp" "${PROJECT_SOURCE_DIR}/*.h")
file(GLOB_RECURSE inc_files "${PROJECT_SOURCE_DIR}/../inc/*.h")
set(source_files ${src_files} ${inc_files})
if(WIN32)
	group_src_by_dir(src_files)
	group_inc_by_dir(inc_files)
endif(WIN32)

add_executable(${PROJECT_NAME} main.cpp) #${source_files}
set_target_properties(${PROJECT_NAME} PROPERTIES DEBUG_POSTFIX "_d")
set_target_properties(${PROJECT_NAME} PROPERTIES RELEASE_POSTFIX "")

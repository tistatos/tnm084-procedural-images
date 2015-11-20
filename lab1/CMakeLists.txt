# project name is not mandatory but should be used
#------------------------------------------------------------------

SET(APP_NAME lab1)
project(${APP_NAME})

# states the minimum version required
#------------------------------------------------------------------
cmake_minimum_required(VERSION 2.8)

# include the directory itself as a path to include directories
# a directory is a file system cataloging structure which
# contains references to other computer files
#------------------------------------------------------------------
set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake)
SET(CMAKE_CXX_FLAGS "-std=c++11")
# set the output path to /bin
#------------------------------------------------------------------
set(EXECUTABLE_OUTPUT_PATH ${PROJECT_SOURCE_DIR}/bin)
set(CMAKE_BINARY_DIR ${PROJECT_SOURCE_DIR}/bin)
set(lab1_BINARY_DIR ${PROJECT_SOURCE_DIR}/bin)

# create a variable called .._SOURCES containing all .c files
#------------------------------------------------------------------
file(GLOB APP_SOURCES *.c)

# create an executable file from sources, create it first,
# then link the libraries
#------------------------------------------------------------------
add_executable(${APP_NAME} ${APP_SOURCES})

find_package(OpenGL REQUIRED)
find_package(PkgConfig REQUIRED)
pkg_search_module(GLFW REQUIRED glfw3)
# get variable GLFW_INCLUDE_DIRS when searching module it contains
# paths to directories to the header files we want to include
#------------------------------------------------------------------
include_directories(${GLFW_INCLUDE_DIRS})
include_directories(${PROJECT_SOURCE_DIR}/include)

# GLFW_STATIC_LIBRARIES is also retrived when running search module
# it contains all the external libraries that are needed
#------------------------------------------------------------------
target_link_libraries(${APP_NAME} ${GLFW_STATIC_LIBRARIES})

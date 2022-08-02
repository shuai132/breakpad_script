cmake_minimum_required(VERSION 3.1)

project(breakpad)

add_library(${PROJECT_NAME} INTERFACE)
target_include_directories(${PROJECT_NAME} INTERFACE breakpad/include/breakpad)
target_link_directories(${PROJECT_NAME} INTERFACE breakpad/lib)
target_link_libraries(${PROJECT_NAME} INTERFACE breakpad_client pthread)

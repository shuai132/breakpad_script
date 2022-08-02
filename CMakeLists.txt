cmake_minimum_required(VERSION 3.1)

project(breakpad)

if (NOT PLATFORM_NAME)
    message(FATAL_ERROR "need set PLATFORM_NAME")
endif ()

add_library(${PROJECT_NAME} INTERFACE)
target_include_directories(${PROJECT_NAME} INTERFACE prebuild/${PLATFORM_NAME}/include/breakpad)
target_link_directories(${PROJECT_NAME} INTERFACE prebuild/${PLATFORM_NAME}/libs)
target_link_libraries(${PROJECT_NAME} INTERFACE breakpad_client pthread)

add_custom_target(build_breakpad
        COMMAND bash build_breakpad.sh
        ${CMAKE_CURRENT_LIST_DIR}/breakpad
        ${CMAKE_CURRENT_LIST_DIR}/output
        ${CMAKE_C_COMPILER}
        ${CMAKE_CXX_COMPILER}
        ${CMAKE_C_FLAGS}
        ${CMAKE_CXX_FLAGS}
        prebuild/${PLATFORM_NAME}
        WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}
        )

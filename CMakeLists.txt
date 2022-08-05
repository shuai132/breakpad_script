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
        COMMAND
        export SOURCE_DIR=${CMAKE_CURRENT_LIST_DIR}/breakpad
        export OUTPUT_DIR=${CMAKE_CURRENT_LIST_DIR}/output
        export C_COMPILER=${CMAKE_C_COMPILER}
        export CXX_COMPILER=${CMAKE_CXX_COMPILER}
        export C_FLAGS=${CMAKE_C_FLAGS}
        export CXX_FLAGS=${CMAKE_CXX_FLAGS}
        export INSTALL_DIR=${CMAKE_CURRENT_LIST_DIR}/prebuild/${PLATFORM_NAME}
        && bash build_breakpad.sh
        WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}
        )

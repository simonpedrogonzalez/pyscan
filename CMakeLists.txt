cmake_minimum_required(VERSION 3.5)
project(pyscan LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)
set(PYBIND11_FINDPYTHON ON)
if (NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Release)
endif()

#Need this for GSL
set(CMAKE_CXX_STANDARD_REQUIRED YES)
set(CMAKE_CXX_FLAGS_DEBUG "-fPIC -Wall -Wextra -g -O1 -fno-omit-frame-pointer")
set(CMAKE_CXX_FLAGS_RELEASE "-fPIC -w -O2 -march=native -DNDEBUG") #work for intel chip
set(CMAKE_C_FLAGS_DEBUG "-fPIC -Wall -Wextra -g -O1 -fno-omit-frame-pointer")
set(CMAKE_C_FLAGS_RELEASE "-fPIC -w -O2 -march=native -DNDEBUG") #work for intel chip

# Dependencies
# find_package(Python3 REQUIRED COMPONENTS Interpreter Development)
find_package(pybind11 CONFIG REQUIRED)
find_package(Boost REQUIRED)
find_package(CGAL REQUIRED)
find_package(GSL REQUIRED)

# Add pybind11 from the thirdpary directory I DONT WANT IT VENDORED
# add_subdirectory(thirdparty/pybind11)

# Build the thirdparty libraries
add_subdirectory(thirdparty/discrepancy)
add_subdirectory(thirdparty/kernel/ANN)
add_subdirectory(thirdparty/kernel/coreset)

# Core sources
file(GLOB_RECURSE CPP_SRC CONFIGURE_DEPENDS src/cpp/lib/*.cpp)

# Compile the core sources
add_library(core_obj OBJECT ${CPP_SRC})

# Include all the header files
# and propagate them
target_include_directories(core_obj PUBLIC
    ${CMAKE_SOURCE_DIR}/src/cpp/lib/include
    ${CMAKE_SOURCE_DIR}/thirdparty/discrepancy/include
    ${CMAKE_SOURCE_DIR}/thirdparty/kernel/ANN/include
    ${CMAKE_SOURCE_DIR}/thirdparty/kernel/coreset/include
)

# Compile the bindings module using the core object files
pybind11_add_module(libpyscan MODULE
    $<TARGET_OBJECTS:core_obj>
    src/cpp/bindings/libpyscan.cpp
)

set_target_properties(libpyscan PROPERTIES
    BUILD_RPATH "$ORIGIN"
    INSTALL_RPATH "$ORIGIN"
)

# i dont need this
# target_include_directories(libpyscan PRIVATE
#     ${CMAKE_SOURCE_DIR}/src/cpp/lib/include
# )

# I do need this
target_include_directories(ann PUBLIC
    ${CMAKE_SOURCE_DIR}/thirdparty/kernel/ANN/include
)
add_dependencies(libpyscan ann)

# Link libraries
target_link_libraries(libpyscan PRIVATE
    core_obj # I added this
    discrepancy
    ann
    appext
    CGAL::CGAL
    GSL::gsl
    GSL::gslcblas
)
# target_link_libraries(libpyscan PRIVATE ann)

set_target_properties(libpyscan PROPERTIES
    BUILD_RPATH "$ORIGIN"
    INSTALL_RPATH "$ORIGIN"
)

set_target_properties(ann PROPERTIES
    BUILD_RPATH "$ORIGIN"
    INSTALL_RPATH "$ORIGIN"
)

# Install Python module and dependencies into the `pyscan/` package dir
install(TARGETS libpyscan LIBRARY DESTINATION pyscan COMPONENT default)
install(FILES
    $<TARGET_FILE:discrepancy>
    $<TARGET_FILE:ann>
    $<TARGET_FILE:appext>
    DESTINATION pyscan
    COMPONENT default
)

option(PYSCAN_BUILD_TESTS "Build tests" OFF)
if(PYSCAN_BUILD_TESTS)

set(THIRDPARTY_LIBRARIES
    discrepancy
    ann
    appext
    CGAL::CGAL
    GSL::gsl
    GSL::gslcblas
)
    
include(CTest)
    enable_testing()

    include(FetchContent)
    FetchContent_Declare(
        googletest
        URL https://github.com/google/googletest/archive/release-1.12.1.zip
    )
    set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)
    FetchContent_MakeAvailable(googletest)

    set(TEST_NAMES
        DiskScan_unittest
        FunctionApprox_unittest
        Halfplane_unittest
        Testing_unittest
        Point_unittest
        RectangleScan_unittest
        trajectory_unittest
    )

    foreach(TEST ${TEST_NAMES})
        add_executable(${TEST} test/${TEST}.cpp $<TARGET_OBJECTS:core_obj>)
        target_link_libraries(${TEST} PRIVATE gtest_main ${THIRDPARTY_LIBRARIES})
        target_include_directories(${TEST} PRIVATE ${CMAKE_SOURCE_DIR}/src/cpp/lib/include)
        add_test(NAME ${TEST} COMMAND ${TEST})
    endforeach()
endif()
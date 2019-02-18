# Install script for directory: /home/mmacd/bin/Reapr_1.0.18/third_party/cmake/Utilities

# Set the install prefix
IF(NOT DEFINED CMAKE_INSTALL_PREFIX)
  SET(CMAKE_INSTALL_PREFIX "/usr/local")
ENDIF(NOT DEFINED CMAKE_INSTALL_PREFIX)
STRING(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
IF(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  IF(BUILD_TYPE)
    STRING(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  ELSE(BUILD_TYPE)
    SET(CMAKE_INSTALL_CONFIG_NAME "")
  ENDIF(BUILD_TYPE)
  MESSAGE(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
ENDIF(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)

# Set the component getting installed.
IF(NOT CMAKE_INSTALL_COMPONENT)
  IF(COMPONENT)
    MESSAGE(STATUS "Install component: \"${COMPONENT}\"")
    SET(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  ELSE(COMPONENT)
    SET(CMAKE_INSTALL_COMPONENT)
  ENDIF(COMPONENT)
ENDIF(NOT CMAKE_INSTALL_COMPONENT)

# Install shared libraries without execute permission?
IF(NOT DEFINED CMAKE_INSTALL_SO_NO_EXE)
  SET(CMAKE_INSTALL_SO_NO_EXE "0")
ENDIF(NOT DEFINED CMAKE_INSTALL_SO_NO_EXE)

IF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/man/man1" TYPE FILE FILES
    "/home/mmacd/bin/Reapr_1.0.18/third_party/cmake/Docs/cmake.1"
    "/home/mmacd/bin/Reapr_1.0.18/third_party/cmake/Docs/cmakecommands.1"
    "/home/mmacd/bin/Reapr_1.0.18/third_party/cmake/Docs/cmakecompat.1"
    "/home/mmacd/bin/Reapr_1.0.18/third_party/cmake/Docs/cmakeprops.1"
    "/home/mmacd/bin/Reapr_1.0.18/third_party/cmake/Docs/cmakepolicies.1"
    "/home/mmacd/bin/Reapr_1.0.18/third_party/cmake/Docs/cmakevars.1"
    "/home/mmacd/bin/Reapr_1.0.18/third_party/cmake/Docs/cmakemodules.1"
    "/home/mmacd/bin/Reapr_1.0.18/third_party/cmake/Docs/ctest.1"
    "/home/mmacd/bin/Reapr_1.0.18/third_party/cmake/Docs/cpack.1"
    "/home/mmacd/bin/Reapr_1.0.18/third_party/cmake/Docs/ccmake.1"
    )
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")

IF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/doc/cmake-2.8" TYPE FILE FILES
    "/home/mmacd/bin/Reapr_1.0.18/third_party/cmake/Docs/cmake.html"
    "/home/mmacd/bin/Reapr_1.0.18/third_party/cmake/Docs/cmake-policies.html"
    "/home/mmacd/bin/Reapr_1.0.18/third_party/cmake/Docs/cmake-properties.html"
    "/home/mmacd/bin/Reapr_1.0.18/third_party/cmake/Docs/cmake-variables.html"
    "/home/mmacd/bin/Reapr_1.0.18/third_party/cmake/Docs/cmake-modules.html"
    "/home/mmacd/bin/Reapr_1.0.18/third_party/cmake/Docs/cmake-commands.html"
    "/home/mmacd/bin/Reapr_1.0.18/third_party/cmake/Docs/cmake-compatcommands.html"
    "/home/mmacd/bin/Reapr_1.0.18/third_party/cmake/Docs/ctest.html"
    "/home/mmacd/bin/Reapr_1.0.18/third_party/cmake/Docs/cpack.html"
    "/home/mmacd/bin/Reapr_1.0.18/third_party/cmake/Docs/ccmake.html"
    "/home/mmacd/bin/Reapr_1.0.18/third_party/cmake/Docs/cmake.txt"
    "/home/mmacd/bin/Reapr_1.0.18/third_party/cmake/Docs/cmake.docbook"
    "/home/mmacd/bin/Reapr_1.0.18/third_party/cmake/Docs/cmake-policies.txt"
    "/home/mmacd/bin/Reapr_1.0.18/third_party/cmake/Docs/cmake-properties.txt"
    "/home/mmacd/bin/Reapr_1.0.18/third_party/cmake/Docs/cmake-variables.txt"
    "/home/mmacd/bin/Reapr_1.0.18/third_party/cmake/Docs/cmake-modules.txt"
    "/home/mmacd/bin/Reapr_1.0.18/third_party/cmake/Docs/cmake-commands.txt"
    "/home/mmacd/bin/Reapr_1.0.18/third_party/cmake/Docs/cmake-compatcommands.txt"
    "/home/mmacd/bin/Reapr_1.0.18/third_party/cmake/Docs/ctest.txt"
    "/home/mmacd/bin/Reapr_1.0.18/third_party/cmake/Docs/ctest.docbook"
    "/home/mmacd/bin/Reapr_1.0.18/third_party/cmake/Docs/cpack.txt"
    "/home/mmacd/bin/Reapr_1.0.18/third_party/cmake/Docs/cpack.docbook"
    "/home/mmacd/bin/Reapr_1.0.18/third_party/cmake/Docs/ccmake.txt"
    "/home/mmacd/bin/Reapr_1.0.18/third_party/cmake/Docs/ccmake.docbook"
    )
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")

IF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/aclocal" TYPE FILE FILES "/home/mmacd/bin/Reapr_1.0.18/third_party/cmake/Utilities/cmake.m4")
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")

IF(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for each subdirectory.
  INCLUDE("/home/mmacd/bin/Reapr_1.0.18/third_party/cmake/Utilities/Doxygen/cmake_install.cmake")
  INCLUDE("/home/mmacd/bin/Reapr_1.0.18/third_party/cmake/Utilities/KWStyle/cmake_install.cmake")

ENDIF(NOT CMAKE_INSTALL_LOCAL_ONLY)


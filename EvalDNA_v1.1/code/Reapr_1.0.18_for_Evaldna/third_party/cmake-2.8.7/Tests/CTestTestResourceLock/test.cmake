CMAKE_MINIMUM_REQUIRED(VERSION 2.1)

# Settings:
SET(CTEST_DASHBOARD_ROOT                "/home/mmacd/bin/Reapr_1.0.18/third_party/cmake/Tests/CTestTest")
SET(CTEST_SITE                          "biomix.dbi.udel.edu")
SET(CTEST_BUILD_NAME                    "CTestTest-Linux-g++-ResourceLock")

SET(CTEST_SOURCE_DIRECTORY              "/home/mmacd/bin/Reapr_1.0.18/third_party/cmake/Tests/CTestTestResourceLock")
SET(CTEST_BINARY_DIRECTORY              "/home/mmacd/bin/Reapr_1.0.18/third_party/cmake/Tests/CTestTestResourceLock")
SET(CTEST_CVS_COMMAND                   "/usr/bin/cvs")
SET(CTEST_CMAKE_GENERATOR               "Unix Makefiles")
SET(CTEST_BUILD_CONFIGURATION           "$ENV{CMAKE_CONFIG_TYPE}")
SET(CTEST_COVERAGE_COMMAND              "/usr/bin/gcov")
SET(CTEST_NOTES_FILES                   "${CTEST_SCRIPT_DIRECTORY}/${CTEST_SCRIPT_NAME}")

CTEST_START(Experimental)
CTEST_CONFIGURE(BUILD "${CTEST_BINARY_DIRECTORY}" RETURN_VALUE res)
CTEST_BUILD(BUILD "${CTEST_BINARY_DIRECTORY}" RETURN_VALUE res)
CTEST_TEST(BUILD "${CTEST_BINARY_DIRECTORY}" RETURN_VALUE res PARALLEL_LEVEL 4)

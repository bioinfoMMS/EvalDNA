# CMake generated Testfile for 
# Source directory: /home/mmacd/bin/Reapr_1.0.18/third_party/cmake/Utilities
# Build directory: /home/mmacd/bin/Reapr_1.0.18/third_party/cmake/Utilities
# 
# This file includes the relevent testing commands required for 
# testing this directory and lists subdirectories to be tested as well.
ADD_TEST(CMake.HTML "/home/mmacd/bin/Reapr_1.0.18/third_party/cmake/bin/cmake" "-E" "chdir" "/home/mmacd/bin/Reapr_1.0.18/third_party/cmake/Utilities/xml" "/usr/bin/xmllint" "--valid" "--noout" "--nonet" "--path" "." "/home/mmacd/bin/Reapr_1.0.18/third_party/cmake/Docs/cmake.html" "/home/mmacd/bin/Reapr_1.0.18/third_party/cmake/Docs/cmake-policies.html" "/home/mmacd/bin/Reapr_1.0.18/third_party/cmake/Docs/cmake-properties.html" "/home/mmacd/bin/Reapr_1.0.18/third_party/cmake/Docs/cmake-variables.html" "/home/mmacd/bin/Reapr_1.0.18/third_party/cmake/Docs/cmake-modules.html" "/home/mmacd/bin/Reapr_1.0.18/third_party/cmake/Docs/cmake-commands.html" "/home/mmacd/bin/Reapr_1.0.18/third_party/cmake/Docs/cmake-compatcommands.html" "/home/mmacd/bin/Reapr_1.0.18/third_party/cmake/Docs/ctest.html" "/home/mmacd/bin/Reapr_1.0.18/third_party/cmake/Docs/cpack.html" "/home/mmacd/bin/Reapr_1.0.18/third_party/cmake/Docs/ccmake.html")
SUBDIRS(Doxygen)
SUBDIRS(KWStyle)

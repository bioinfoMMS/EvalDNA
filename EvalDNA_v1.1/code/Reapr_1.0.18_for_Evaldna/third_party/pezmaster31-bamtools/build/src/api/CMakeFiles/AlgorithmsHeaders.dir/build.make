# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 2.8

#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:

# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list

# Suppress display of executed commands.
$(VERBOSE).SILENT:

# A target that is always out of date.
cmake_force:
.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /home/mmacd/bin/Reapr_1.0.18/third_party/cmake-2.8.7/bin/cmake

# The command to remove a file.
RM = /home/mmacd/bin/Reapr_1.0.18/third_party/cmake-2.8.7/bin/cmake -E remove -f

# The program to use to edit the cache.
CMAKE_EDIT_COMMAND = /home/mmacd/bin/Reapr_1.0.18/third_party/cmake-2.8.7/bin/ccmake

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /home/mmacd/bin/Reapr_1.0.18/third_party/bamtools

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/mmacd/bin/Reapr_1.0.18/third_party/bamtools/build

# Utility rule file for AlgorithmsHeaders.

# Include the progress variables for this target.
include src/api/CMakeFiles/AlgorithmsHeaders.dir/progress.make

src/api/CMakeFiles/AlgorithmsHeaders:
	$(CMAKE_COMMAND) -E cmake_progress_report /home/mmacd/bin/Reapr_1.0.18/third_party/bamtools/build/CMakeFiles $(CMAKE_PROGRESS_1)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --blue --bold "Exporting AlgorithmsHeaders"

AlgorithmsHeaders: src/api/CMakeFiles/AlgorithmsHeaders
AlgorithmsHeaders: src/api/CMakeFiles/AlgorithmsHeaders.dir/build.make
	cd /home/mmacd/bin/Reapr_1.0.18/third_party/bamtools/build/src/api && /home/mmacd/bin/Reapr_1.0.18/third_party/cmake-2.8.7/bin/cmake -E copy_if_different /home/mmacd/bin/Reapr_1.0.18/third_party/bamtools/src/api/algorithms/Sort.h /home/mmacd/bin/Reapr_1.0.18/third_party/bamtools/include/api/algorithms/Sort.h
.PHONY : AlgorithmsHeaders

# Rule to build all files generated by this target.
src/api/CMakeFiles/AlgorithmsHeaders.dir/build: AlgorithmsHeaders
.PHONY : src/api/CMakeFiles/AlgorithmsHeaders.dir/build

src/api/CMakeFiles/AlgorithmsHeaders.dir/clean:
	cd /home/mmacd/bin/Reapr_1.0.18/third_party/bamtools/build/src/api && $(CMAKE_COMMAND) -P CMakeFiles/AlgorithmsHeaders.dir/cmake_clean.cmake
.PHONY : src/api/CMakeFiles/AlgorithmsHeaders.dir/clean

src/api/CMakeFiles/AlgorithmsHeaders.dir/depend:
	cd /home/mmacd/bin/Reapr_1.0.18/third_party/bamtools/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/mmacd/bin/Reapr_1.0.18/third_party/bamtools /home/mmacd/bin/Reapr_1.0.18/third_party/bamtools/src/api /home/mmacd/bin/Reapr_1.0.18/third_party/bamtools/build /home/mmacd/bin/Reapr_1.0.18/third_party/bamtools/build/src/api /home/mmacd/bin/Reapr_1.0.18/third_party/bamtools/build/src/api/CMakeFiles/AlgorithmsHeaders.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : src/api/CMakeFiles/AlgorithmsHeaders.dir/depend

# create the binary directory
make_directory("/home/mmacd/bin/Reapr_1.0.18/third_party/cmake/Tests/DoubleProject")

# remove the CMakeCache.txt file from the source dir
# if there is one, so that in-source cmake tests
# still pass
message("Remove: /home/mmacd/bin/Reapr_1.0.18/third_party/cmake/Tests/DoubleProject/CMakeCache.txt")
file(REMOVE "/home/mmacd/bin/Reapr_1.0.18/third_party/cmake/Tests/DoubleProject/CMakeCache.txt")

# run cmake in the binary directory 
message("running: ${CMAKE_COMMAND}")
execute_process(COMMAND "${CMAKE_COMMAND}"
  "/home/mmacd/bin/Reapr_1.0.18/third_party/cmake/Tests/DoubleProject"  
  "-GUnix Makefiles"
  WORKING_DIRECTORY "/home/mmacd/bin/Reapr_1.0.18/third_party/cmake/Tests/DoubleProject"
  RESULT_VARIABLE RESULT)
if(RESULT)
  message(FATAL_ERROR "Error running cmake command")
endif(RESULT)

# Now use the --build option to build the project
message("running: ${CMAKE_COMMAND} --build")
execute_process(COMMAND "${CMAKE_COMMAND}" 
  --build "/home/mmacd/bin/Reapr_1.0.18/third_party/cmake/Tests/DoubleProject" --config Debug
  RESULT_VARIABLE RESULT)
if(RESULT)
  message(FATAL_ERROR "Error running cmake --build")
endif(RESULT)

# check for configuration types
set(CMAKE_CONFIGURATION_TYPES )
# run the executable out of the Debug directory if there 
# are configuration types
if(CMAKE_CONFIGURATION_TYPES)
  set(RUN_TEST "/home/mmacd/bin/Reapr_1.0.18/third_party/cmake/Tests/DoubleProject/Debug/just_silly")
else(CMAKE_CONFIGURATION_TYPES)
  set(RUN_TEST "/home/mmacd/bin/Reapr_1.0.18/third_party/cmake/Tests/DoubleProject/just_silly")
endif(CMAKE_CONFIGURATION_TYPES)
# run the test results
message("running [${RUN_TEST}]")
execute_process(COMMAND "${RUN_TEST}" RESULT_VARIABLE RESULT)
if(RESULT)
  message(FATAL_ERROR "Error running test just_silly")
endif(RESULT)

# build it again with clean and only just_silly target
execute_process(COMMAND "${CMAKE_COMMAND}" 
  --build "/home/mmacd/bin/Reapr_1.0.18/third_party/cmake/Tests/DoubleProject" --config Debug 
  --clean-first --target just_silly
  RESULT_VARIABLE RESULT)
if(RESULT)
  message(FATAL_ERROR "Error running cmake --build")
endif(RESULT)

# run it again after clean 
execute_process(COMMAND "${RUN_TEST}" RESULT_VARIABLE RESULT)
if(RESULT)
  message(FATAL_ERROR "Error running test just_silly after clean ")
endif(RESULT)

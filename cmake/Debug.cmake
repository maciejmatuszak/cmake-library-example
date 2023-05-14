# Get all propreties that cmake supports
if(NOT CMAKE_PROPERTY_LIST)
  MESSAGE(STATUS "GETTING AVAILABLE PROPERTIES...")
  execute_process(COMMAND cmake --help-property-list OUTPUT_VARIABLE CMAKE_PROPERTY_LIST)

  # Convert command output into a CMake list
  string(REGEX REPLACE ";" "\\\\;" CMAKE_PROPERTY_LIST "${CMAKE_PROPERTY_LIST}")
  string(REGEX REPLACE "\n" ";" CMAKE_PROPERTY_LIST "${CMAKE_PROPERTY_LIST}")
  MESSAGE(STATUS "GETTING AVAILABLE PROPERTIES...DONE")
endif()

function(print_properties)
  message("CMAKE_PROPERTY_LIST = ${CMAKE_PROPERTY_LIST}")
endfunction()

function(dump_target_properties target)
  if(NOT TARGET ${target})
    message(STATUS "There is no target named '${target}'")
    return()
  endif()

  MESSAGE(STATUS "#################### Target Properties START ####################")
  foreach(property ${CMAKE_PROPERTY_LIST})
    string(REPLACE "<CONFIG>" "${CMAKE_BUILD_TYPE}" property ${property})

    # Fix https://stackoverflow.com/questions/32197663/how-can-i-remove-the-the-location-property-may-not-be-read-from-target-error-i
    if(property STREQUAL "LOCATION" OR property MATCHES "^LOCATION_" OR property MATCHES "_LOCATION$" OR property MATCHES ".*_COMPILER_ID_")
      continue()
    endif()

    get_property(was_set TARGET ${target} PROPERTY ${property} SET)
    if(was_set)
      get_target_property(value ${target} ${property})
      message("${target} ${property} = ${value}")
    endif()
  endforeach()
  MESSAGE(STATUS "#################### Target Properties END ####################")
endfunction()

function(dump_cmake_variables)
  get_cmake_property(_variableNames VARIABLES)
  list (SORT _variableNames)
  foreach (_variableName ${_variableNames})
    if(_variableName MATCHES ".*_COMPILER_ID_")
      continue()
    endif()
    message(STATUS "${_variableName}=${${_variableName}}")
  endforeach()
endfunction()
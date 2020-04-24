cmake_minimum_required(VERSION 3.13)

include(project-meta-info.in)
project(${project_name}
  VERSION ${project_version}
  DESCRIPTION ${project_description}
  HOMEPAGE_URL ${project_url}
  LANGUAGES ${project_languages}
)

# set standard compiler options
add_library(project_options INTERFACE)
target_compile_features(project_options INTERFACE cxx_std_17)

# set compiler warning options
add_library(project_warnings INTERFACE)

include(CMakeModules/CompilerWarnings.cmake)
set_project_warnings(project_warnings)

# set dependencies
include(CMakeModules/Dependencies.cmake)

# enable tests
enable_testing()

if (CMAKE_BUILD_TYPE STREQUAL "Debug")
  option(ENABLE_CODE_COVERAGE "Enable the CodeCoverage module" false)
  if (ENABLE_CODE_COVERAGE)
    include(CMakeModules/CodeCoverage.cmake)
    append_coverage_compiler_flags()
  endif()
endif()

# add sources
add_subdirectory(src)

# add static analysis targets
include(CMakeModules/StaticAnalyzers.cmake)

# add documentation generation
find_package(Doxygen)
if(DOXYGEN_FOUND)
  add_custom_target(doc
    COMMAND doxygen ${CMAKE_CURRENT_LIST_DIR}/Doxyfile
  )
else()
  set(DOXYGEN_EXECUTABLE "not found")
endif()

# print summary
if (CMAKE_BUILD_TYPE STREQUAL "Debug")
  message(STATUS "Summary")
  message(STATUS " * Project name     ${PROJECT_NAME}")
  message(STATUS " * Project version  ${PROJECT_VERSION}")
  message(STATUS " * Install prefix   ${CMAKE_INSTALL_PREFIX}")
  message(STATUS "Toolchain")
  message(STATUS " * clang-format     ${CLANG_FORMAT}")
  message(STATUS " * clang-tidy       ${CLANG_TIDY}")
  message(STATUS " * doxygen          ${DOXYGEN_EXECUTABLE}")
  message(STATUS "Settings")
  message(STATUS " * WARNINGS_AS_ERRORS  ${WARNINGS_AS_ERRORS}")
endif()

include(GNUInstallDirs)

set(SOURCE_FILES
)

set(TEST_SOURCE_FILES
  tests/test-template.cpp
)

# Build executable
add_executable(${PROJECT_NAME} ${SOURCE_FILES} main.cpp)
target_link_libraries(${PROJECT_NAME}
  project_options
  project_warnings
  ${PROJECT_DEPENDENCIES}
)

# Build test
add_executable(${PROJECT_NAME}_unit ${SOURCE_FILES} ${TEST_SOURCE_FILES})
target_link_libraries(${PROJECT_NAME}_unit
  project_options
  ${PROJECT_DEPENDENCIES}
  ${TEST_DEPENDENCIES}
)

gtest_discover_tests(${PROJECT_NAME}_unit WORKING_DIRECTORY ${CMAKE_BINARY_DIR})

# use code coverage
if (CMAKE_BUILD_TYPE STREQUAL "Debug" AND ENABLE_CODE_COVERAGE)
  set(COVERAGE_EXCLUDES "${PROJECT_SOURCE_DIR}/src/tests/*")
  setup_target_for_coverage_gcovr_html(
    NAME coverage
    EXECUTABLE ${PROJECT_NAME}_unit
    BASE_DIRECTORY "${PROJECT_SOURCE_DIR}/src"
  )
endif()

# Install
install(TARGETS ${PROJECT_NAME}
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

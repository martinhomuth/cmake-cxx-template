# Project dependencies

find_package(LibArchive REQUIRED)
find_package(OpenSSL REQUIRED)
find_package(PkgConfig REQUIRED)
pkg_search_module(LibJansson REQUIRED jansson)

set(PROJECT_DEPENDENCIES
  ${LibArchive_LIBRARIES}
  ${LibJansson_LIBRARIES}
  OpenSSL::SSL
  pthread
)

# Test dependencies

find_library(GMOCK_LIBRARIES NAMES gmock)
if(NOT GMOCK_LIBRARIES)
  message(FATAL_ERROR "gmock not found")
else()
  message(STATUS "Found GMock: ${GMOCK_LIBRARIES}")
endif()
find_package(GTest REQUIRED)

set(TEST_DEPENDENCIES
  GTest::GTest
  GTest::Main
  ${GMOCK_LIBRARIES}
)

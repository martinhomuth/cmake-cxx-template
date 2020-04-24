# get source files with absolute path
get_target_property(SRC_DIR ${PROJECT_NAME} SOURCE_DIR)
get_target_property(SRC_LIST ${PROJECT_NAME} SOURCES)

set(SOURCE_FILES "")
foreach(SRC IN LISTS SRC_LIST)
  if(NOT IS_ABSOLUTE "${SRC}")
    set(SRC "${SRC_DIR}/${SRC}")
  endif()
  get_filename_component(SRC "${SRC}" ABSOLUTE)
  list(APPEND SOURCE_FILES "${SRC}")
endforeach()

# add clang-tidy target
find_program(CLANG_TIDY clang-tidy)

if(CLANG_TIDY)
  set(CLANG_TIDY_ARGS --quiet)
  if(WARNINGS_AS_ERRORS)
    set(CLANG_TIDY_ARGS ${CLANG_TIDY_ARGS} --warnings-as-errors=*)
  endif()
  add_custom_target(tidy
    COMMAND ${CLANG_TIDY} ${CLANG_TIDY_ARGS} ${SOURCE_FILES} -- -std=c++17
  )
else()
  set(CLANG_TIDY "not found")
endif()

# add clang-format target
find_program(CLANG_FORMAT clang-format)

if(CLANG_FORMAT)
  file(GLOB_RECURSE FORMAT_FILES ${SRC_DIR}/*.cpp ${SRC_DIR}/*.hpp)
  add_custom_target(format
    COMMAND ${CLANG_FORMAT} -i -style=file ${FORMAT_FILES}
  )
else()
  set(CLANG_FORMAT "not found")
endif()

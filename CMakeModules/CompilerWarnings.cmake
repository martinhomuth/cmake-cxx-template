function(set_project_warnings project_name)

  option(WARNINGS_AS_ERRORS "Treat compiler warnings as errors" TRUE)

  set(CLANG_WARNINGS
    -Wall        # enable all default warnings
    -Wextra      # reasonable and standard
    -Wpedantic   # warn if non-standard C++ is used
    -Wconversion # warn on type conversions that may lose data
    -Wshadow     # warn the user if a variable declaration shadows one from a parent context
    -Wnon-virtual-dtor # warn the user if a class with virtual functions has a non-virtual destructor
    -Wold-style-cast # warn for c-style casts
    -Wcast-align # warn for potential performance problem casts
    -Wnull-dereference # warn if a null dereference is detected
    -Wdouble-promotion # warn if float is implicit promoted to double
    -Wformat=2   # warn on security issues around functions that format output (ie printf)
  )

  # check additional warning to enable by `gcc -Wall -Wextra -Wpedantic -Q --help=warning`
  set(GCC_WARNINGS
    ${CLANG_WARNINGS}
    -Wduplicated-cond # warn if if / else chain has duplicated conditions
    -Wduplicated-branches # warn if if / else branches have duplicated code
    -Wlogical-op # warn about logical operations being used where bitwise were probably wanted
    -Wuseless-cast # warn if you perform a cast to the same type
  )

  if(WARNINGS_AS_ERRORS)
    set(CLANG_WARNINGS ${CLANG_WARNINGS} -Werror)
    set(GCC_WARNINGS ${GCC_WARNINGS} -Werror)
  endif()

  if(CMAKE_COMPILER_IS_GNUCXX)
    set(PROJECT_WARNINGS ${GCC_WARNINGS})
  else()
    set(PROJECT_WARNINGS ${CLANG_WARNINGS})
  endif()

  target_compile_options(${project_name} INTERFACE ${PROJECT_WARNINGS})

endfunction()

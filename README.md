
# TODOs

# How to build (also CI)

The project is set to contain the relevant default values when
building the project. A Dockerfile is provided within `ci` as well as
a script to build and execute the docker image.

	cd ci
	./docker-run.sh

From here on the build is identical to the non-docker build.

	mkdir build
	cmake -S . -B build
	make -C build

# Build and Development

The following relevant make targets are created by default, when using
cmake without arguments to generate the Makefiles.

	make <project_name>

The tool itself. Also the default target.

	make <project_name>_unit

All unit tests as a single binary. This binary can only be executed
from the build directory, as relative paths are used in the code.

	make tidy

clang-format execution on *all* source files.

	make format

clang-tidy execution on *all* source and header files.

By default the project builds with warnings as errors
enabled. This can be changed with

	-D WARNINGS_AS_ERRORS=OFF

The project makes use of gcovr (based on gcov) to enable code coverage
of the unit tests. This feature is disabled by default and can only be
enabled in debug builds by using

	-D ENABLE_CODE_COVERAGE=ON

That enables the command

	make coverage

that produces a html-based coverage report in
build/coverage/index.html.

To simply list (and edit) the cmake options of the project, use

	cmake -L <build-directory>

or if installed use the curses based gui

	ccmake <build-directory>

# Development Workflow

# Adapting toolchain.cmake

In order to use the `toolchain.cmake` file to build this project
using your own toolchain, you have to replace the placeholders
`<aarch>`, `<project>` and `<triplet>` with the architecture name,
the project name and the toolchain triplet.

You can then build the project using cmake:

    mkdir build
    cd build
    cmake -DCMAKE_TOOLCHAIN_FILE=../toolchain.cmake
    make


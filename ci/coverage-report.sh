#!/bin/bash

# this script extracts the general coverage information from the
# index.html created by 'make coverage' of the project and produces
# a visually appealing table for the jenkins build as well as
# a local file that can be used in subsequent calls to the script
# do see the changes over time
# e.g.
#                Exec             Total          Coverage
# ------------------------------------------------------------------
# Lines:          333  (-18)       1099    (0)      30.3%(-1.6%)
# Branches:       282  (-17)       2221    (0)      12.7%(-0.8%)
#

file=$1

[ -f $file ] || exit 1

function report() {
	local newLinesExec=$1;shift
	local newLinesTotal=$1;shift
	local newLinesCoverage=$1;shift
	local newBranchesExec=$1;shift
	local newBranchesTotal=$1;shift
	local newBranchesCoverage=$1;shift

	if [ $# -gt 0 ]; then
		local oldLinesExec=$1;shift
		local oldLinesTotal=$1;shift
		local oldLinesCoverage=$1;shift
		local oldBranchesExec=$1;shift
		local oldBranchesTotal=$1;shift
		local oldBranchesCoverage=$1;shift

		diffLinesExec="($(((newLinesExec - oldLinesExec))))"
		diffLinesTotal="($(((newLinesTotal - oldLinesTotal))))"
		diffLinesCoverage="($(awk "BEGIN{print $newLinesCoverage - $oldLinesCoverage}")%)"
		diffBranchesExec="($(((newBranchesExec - oldBranchesExec))))"
		diffBranchesTotal="($(((newBranchesTotal - oldBranchesTotal))))"
		diffBranchesCoverage="($(awk "BEGIN{print $newBranchesCoverage - $oldBranchesCoverage}")%)"
	fi

	printf "               Exec             Total          Coverage\n"
	echo "------------------------------------------------------------------"
	printf "Lines:        %5s%7s      %5s%7s      %5s%7s\n" \
	       "${newLinesExec}" "${diffLinesExec}" "${newLinesTotal}" "${diffLinesTotal}" \
	       "${newLinesCoverage}%" "${diffLinesCoverage}"
	printf "Branches:     %5s%7s      %5s%7s      %5s%7s\n" \
	       "${newBranchesExec}" "${diffBranchesExec}" "${newBranchesTotal}" "${diffBranchesTotal}" \
	       "${newBranchesCoverage}%" "${diffBranchesCoverage}"
}

linesBlock=(
	$(grep "Lines:" -A3 ${file} |                    # get the relevant block
		  sed 's/^\s*<td.*>\(.*\)<\/td>$/\1/g' | # filter html
		  sed 's/ \%//g')                       # remove percent whitespace
)
branchesBlock=(
	$(grep "Branches:" -A3 ${file} |                 # get the relevant block
		  sed 's/^\s*<td.*>\(.*\)<\/td>$/\1/g' | # filter html
		  sed 's/ \%//g')                       # remove percent whitespace
)

currentValues=(${linesBlock[1]} ${linesBlock[2]} ${linesBlock[3]} ${branchesBlock[1]} ${branchesBlock[2]} ${branchesBlock[3]})

if [ -f lastValues.txt ]; then
	oldValues=($(cat lastValues.txt))
	cp lastValues.txt values_$(date +%y%d%m%H%M).txt
fi

report ${currentValues[@]} ${oldValues[@]}

echo ${currentValues[@]} > lastValues.txt



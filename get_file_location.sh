#/bin/bash

# author: Tian Xia
# email: tianxia@tamu.edu
# org:  Infolab@tamu
# date: July 17, 2015

#Copyright [2015] [Tian Xia]

#Licensed under the Apache License, Version 2.0 (the "License");
#you may not use this file except in compliance with the License.
#You may obtain a copy of the License at

#    http://www.apache.org/licenses/LICENSE-2.0

#Unless required by applicable law or agreed to in writing, software
#distributed under the License is distributed on an "AS IS" BASIS,
#WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#See the License for the specific language governing permissions and
#limitations under the License.

## Please specify your testdir (root directory of tweet files)

# The root directory in which your input files are stored. 
search_dir=""

# output file
output_file=file_locations.txt

allFiles() {
	
	for file in $(ls $1)
	do
		if [ -d $1'/'$file ]
		then
			allFiles $1'/'$file
		elif [ -f $1'/'$file ]
		then
			echo $1'/ '$file >> $output_file
		fi
	done
}


allFiles $search_dir

#!/bin/bash

# author: Tian Xia
# email: tianxia@tamu.edu
# org:  Infolab@tamu
# date: Aug 12, 2015
#
# node_run.sh:
# Spliting job file to multiple partitions and
# start parallel task accordingly.
#

## Format: bash deploy.sh [big_location_file] [output directory]

## $1 is the first argument: input of file locations
## $2 is the output directory location
## $3 is the password to master node
## $4 is the scp objective directory in master node: user1@tt.com:~/test/

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


## Compile 
make preprocess

## Determine num of parallel tasks
if [ "$(uname)" == "Darwin" ]; then
    # Do something under Mac OS X platform        
	numofproc="$(sysctl -n hw.ncpu)";
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    # Do something under Linux platform
	numofproc="$(nproc)";
fi

numofproc=$(( $numofproc / 4));

if [ ! -d "locations" ]; then
	mkdir locations;
elif [ "$(ls -A locations)" ]; then
	rm -rf locations
	mkdir locations
fi

## Divide input locaitons equally on each core
## to start parallel multi-tasking jobs in 
## directory locations
linenum=$(wc -l < $1);

if [ $linenum -eq 0 ]; then
	return
fi

perlinenum=$(( $linenum / numofproc));

remainlinenum=$(( $linenum % numofproc));

cp $1 locations/;

cd locations;

filetosplit=$(ls)

if [ $perlinenum -eq 0 ]; then
	split -l 1 $filetosplit
	rm $filetosplit
elif [ $remainlinenum -gt 0 ]; then
	mkdir remainfiles
	head -n $remainlinenum $filetosplit > remainfiles/tmp.txt
	tail -n +$((remainlinenum+1)) $filetosplit > tmp2.txt
	mv tmp2.txt $filetosplit
	cd remainfiles
	split -l 1 tmp.txt
	rm tmp.txt
	cd ..

	split -l $perlinenum $filetosplit

	rm $filetosplit

	tmpfilelist=($(ls remainfiles))
	locfilelist=($(ls -p | grep -v /))

	for (( i = 0; i < $remainlinenum; i++ )); do
		cat remainfiles/${tmpfilelist[$i]} ${locfilelist[$i]} > tmp.txt
		mv tmp.txt ${locfilelist[$i]}
	done

	rm -rf remainfiles

else
	split -l $perlinenum $filetosplit

	rm $filetosplit
fi

cd ..;

for fi in $(ls locations)
do
	### Start job in parallel on each core
	./preprocess $(readlink -f ./locations/$fi) $(readlink -f $2) >> log.txt &
done






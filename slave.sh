#!/bin/bash

# author: Tian Xia
# email: tianxia@tamu.edu
# org:  Infolab@tamu
# date: Aug 11, 2015
#
# slave.sh: Pull job file and 
# start to run job on current node.
#

# $1 is the ssh connecton essential to master node: username@ip:file_loc
# $2 is the password of master node 
# $3 is the index of task file in folder locations


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

sshpass -p $2  scp -r $1 ./

#echo ${pwd} > log.txt
echo $(hostname)

cd ./processtwitter

file_list=($(ls ./locations))

mv ./locations/${file_list[$3]} file_locations.txt

if [ ! -d "data" ]; then
	mkdir data;
elif [ "$(ls -A data)" ]; then
	rm -rf data
	mkdir data
fi

bash node_run.sh file_locations.txt ./data/
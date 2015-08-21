#!/usr/bash

# author: Tian Xia
# email: tianxia@tamu.edu
# org:  Infolab@tamu
# date: Aug 11, 2015
#
# master.sh
# Starting the whole parallel job
# from master node.
#

## master.sh aims at deploying code package to 
## node servers and split file recording files 
## to be processed on shared online disks or 
## your customized file locations you wish.
## bash master.sh input_location_file


## $1 is the input location file



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




### Customized Settings

TASK_LOCATION_FILE=$(readlink -f $1);

SLAVE_PASSWD="1123456";

MASTER_PASSWD="15879796"

SLAVE_USERNAME="root"

# host names of slave nodes: mail or plus 
# in mail.google.com or plus.google.com
hosts=(plus mail);

# domain name
host_affix=google.com;

CURRENT_IP_ADDR=$(ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1');

hosts_size=${#hosts[@]};

### End of Settings


### Unzip compressed file
cd cld2/internal
gzip -d test_shuffle_1000_48_666.utf8.gz 
cd ../../

### Create Job Directory
if [ ! -d "locations" ]; then
	mkdir locations;
elif [ "$(ls -A locations)" ]; then
	rm -rf locations
	mkdir locations
fi


### Create Log Directory
if [ ! -d "log" ]; then
	mkdir log
elif [ "$(ls -A log)" ]; then
	rm -rf log
	mkdir log
fi

### split processing tasks equally on child nodes

line_num=$(wc -l < $TASK_LOCATION_FILE);


if [ $line_num -eq 0 ]; then
	echo "Input file cannot be empty."
	return
fi

per_line_num=$(($line_num / $hosts_size));

remain_line_num=$(($line_num % $hosts_size));

cp $TASK_LOCATION_FILE locations/

cd locations

file_to_split=$(ls)

#echo $((remain_line_num+1))
if [ $per_line_num -eq 0 ]; then
	split -l 1 $file_to_split
	rm $file_to_split
elif [ $remain_line_num -gt 0 ]; then
	mkdir remain_files
	head -n $remain_line_num $file_to_split > remain_files/tmp.txt
	
	tail -n +$((remain_line_num+1)) $file_to_split > tmp2.txt 
	mv tmp2.txt $file_to_split
	cd remain_files
	split -l 1 tmp.txt
	rm tmp.txt
	cd ..
	
	#echo $(wc -l tmp_locations.txt)
	
	#echo $per_line_num
	split -l $per_line_num $file_to_split 
	
	#echo $(ls)
	
	rm $file_to_split
	
	tmp_file_list=($(ls remain_files))
	
	loc_file_list=($(ls -p | grep -v /))
	
	#echo ${loc_file_list[1]}
	
	for ((i=0;i<remain_line_num;i++))
	do
		cat remain_files/${tmp_file_list[$i]} ${loc_file_list[$i]} > tmp.txt
		mv tmp.txt ${loc_file_list[$i]}
	done
	
	rm -rf remain_files

else
	split -l $per_line_num $file_to_split
	
	rm $file_to_split
fi


cd ..

file_list=($(ls locations));

file_num=(${#file_list[@]});


### Dealing with situations that the num of
### jobs (files) unmatch the num of available 
### processing units (servers).

if [ $file_num -lt $hosts_size ]; then
	process_num=$file_num;
else
	process_num=$hosts_size;
fi


### Parallel Job Processing


echo "$(date)" > master.log.txt

for ((i=0;i<process_num;i++))
do
	# Start Job on each salve node.
	 sshpass -p $SLAVE_PASSWD ssh -oStrictHostKeyChecking=no $SLAVE_USERNAME@${hosts[$i]}.$host_affix "bash -s" < slave.sh "$USER@$CURRENT_IP_ADDR:$(pwd) $MASTER_PASSWD $i" &
done





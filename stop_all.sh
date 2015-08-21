#!/bin/bash


# author: Tian Xia
# email: tianxia@tamu.edu
# org:  Infolab@tamu
# date: Aug 17, 2015
#
# stop_all.sh: stop all running task processes 
# in all slave nodes.
#

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



# Customized Settings 

## host names: like  mail plus from mail.google.com 
## or plus.google.com 
hosts=(mail plus);

## domain name: eg. google.com
domain=google.com

## username to log in
username=root

## password for user to log in
passwd=1223444

# End of Customized Settings

for (( i = 0; i < ${#hosts[@]}; i++ )); do
	echo "${hosts[$i]}" 
	sshpass -p $passwd ssh $username@${hosts[$i]}.$domain "killall preprocess"
done
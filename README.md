# twitterprocess
### Introduction ###
**twitterprocess** is a distributed parallel framework for preprocessing json format sample tweets. twitterproces has been tested on Ubunt 12.04 X64.
 * cld2: chrome language detect api
 * boost library
 * rapidjson
 * sshpass
 * linux readlink


 ### Tutorial ###

<h3> preprocess.cpp </h3>
This file processes each json-format file with rapidjson package. Example of rapidjson is given in <b>rapidjson_demo.cpp</b> <br>
The file given extracts contents of tweets in fields: id_str, user_id, tweet_text, hashtags. <br>
Users can configure own specified method w/ users' needs. <br>

<h3> Bash Script Configuration </h3>
The distributed environment is fully driven by bash script with ssh as well as scp. <br>
To customize your own environment settings, modify <b>Customized Settings</b> in each bash file. <br>

<h3> How to run? </h3>
<ul><li>Run "get_file_locations.sh" to get job list of objetive json files to be processed. <br>
</li><li>Run "master.sh" with arguments of job list file generated from the previous step. <br>
</li><li>Run "check_status.sh" to see the size of output data folder and num of finished jobs in each slave node. <br>
</li><li>"stop_all.sh" stops all processes of "preprocess" running on each slave node. <br>
</li><li>"gather_data_from_slaves.sh" downloads all output data from slaves to current folder. <br>
</li><li>"clear_slave_nodes.sh" cleans all data and codes deployed on each slave node. <br>
</ul>




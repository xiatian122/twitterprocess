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
<ul><li>This file processes each json-format file with rapidjson package. Example of rapidjson is given in <b>rapidjson_demo.cpp</b> <br>
</li><li>The file given extracts contents of tweets in fields: id_str, user_id, tweet_text, hashtags. <br>
</li><li>Users can configure own specified method w/ users' needs. <br>
</li></ul>

<h3> Bash Script Configuration </h3>
<ul><li>The distributed environment is fully driven by bash script with ssh as well as scp. <br>
</li><li>To customize your own environment settings, modify <b>Customized Settings</b> in each bash file. <br>
</li></ul>

<h3> How to run? </h3>
<ul><li>Run "get_file_locations.sh" to get job list of objetive json files to be processed. <br>
</li><li>Run "master.sh" with arguments of job list file generated from the previous step. <br>
</li><li>Run "check_status.sh" to see the size of output data folder and num of finished jobs in each slave node. <br>
</li><li>"stop_all.sh" stops all processes of "preprocess" running on each slave node. <br>
</li><li>"gather_data_from_slaves.sh" downloads all output data from slaves to current folder. <br>
</li><li>"clear_slave_nodes.sh" cleans all data and codes deployed on each slave node. <br>
</li></ul>

<h3>Cautions</h3>
<ul><li>The network protocol applied in this project is SSH. Slave nodes will connect to the master node concurrently. 
However, the default configuration of ssh only allows 10 concurrent connection. To modify this, set MaxSessions
and MaxStartups in sshd_config file to be more than num of slave nodes. Further issues may refer to ssh or iptables firewall security settings.<br>
</li><li> The rapidjson package may encounter kernel panic errors, when users mean to retrieve attributes that don't exist in the json format file. To avoid such errors, test if the attribute exists prior to code to crawl is essential but necessary. For example, if you want to retireve hashtags in a tweet like "d[entities][hashtags]", test if "entities -> hashtags" is validate in a sequential order.
</li></ul>


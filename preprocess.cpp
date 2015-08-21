/**
 *  author: Tian Xia
 *  email: tianxia@tamu.edu
 *  org:   Infolab@tamu
 *  date: Aug 11, 2015
 *
 *  preprocess.cpp
 *  Filtering out contents id userid text hashtags
 *  from raw json-format tweets.
 *  
 *  prog_name location_file output_dir
 */

 /*
  * Copyright [2015] [Tian Xia]

  *	Licensed under the Apache License, Version 2.0 (the "License");
  *	you may not use this file except in compliance with the License.
  *	You may obtain a copy of the License at

  * http://www.apache.org/licenses/LICENSE-2.0

  * Unless required by applicable law or agreed to in writing, software
  * distributed under the License is distributed on an "AS IS" BASIS,
  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  * See the License for the specific language governing permissions and
  * limitations under the License.
*/


#include <iostream>
#include <fstream>
#include <boost/iostreams/filtering_stream.hpp>
#include <boost/iostreams/filter/gzip.hpp>

#include <sstream>

#include "rapidjson/document.h"
#include "rapidjson/writer.h"
#include "rapidjson/stringbuffer.h"

#include "./cld2/internal/detectenglish.h"

#include <ctime>
#include <cstring>


// Get current Date and Time
const std::string currentDateTime() {
    time_t     now = time(0);
    struct tm  tstruct;
    char       buf[80];
    tstruct = *localtime(&now);
    // Visit http://en.cppreference.com/w/cpp/chrono/c/strftime
    // for more information about date/time format
    strftime(buf, sizeof(buf), "%Y-%m-%d.%X", &tstruct);

    return buf;
}



// Process each json record
std::string process_record(std::string line) {
	
	int hashtag_size;
	
	// The final result string
	
	
	/**
	*   The format of result sting: id_str, user_id, text, hashtags
	*	How to write json: refer tt.cpp
	*/
	
	std::string result = "";
	
	rapidjson::StringBuffer s;
		
	rapidjson::Writer<rapidjson::StringBuffer> writer(s);
	
	rapidjson::Document *d = new rapidjson::Document();
	

	d -> Parse<0>(line.c_str());
	
	if (d -> HasParseError()) {
		
		//std::cout << "Get ParseError: "<< d->GetParseError() << std::endl;
		
		delete d;
		return "";
	}
	
	// detect whether the tweet is deleted
	if (d -> IsObject() && d -> HasMember("delete")) {
		
		delete d;
		return "";
	}
	
	
	if (d -> IsObject() && d -> HasMember("text") && d -> HasMember("user") ) {
		
		// add id_str, user_id[usser id_str]
		
		std::string buffer = (*d)["text"].GetString();
		
		if (detect_english(buffer.c_str()) == false) {
		
			delete d;
			return "";
		}
		
		
		
		writer.StartObject();
		
		
		writer.String("id_str");
		writer.String((*d)["id_str"].GetString());
		
		
		writer.String("user_id_str");
		writer.String((*d)["user"]["id_str"].GetString());
		
		writer.String("text");
		writer.String((*d)["text"].GetString());
		
		if (d -> HasMember("entities")) {
			
		
			
			if ((*d)["entities"].HasMember("hashtags")) {
				
				
					
					hashtag_size = (*d)["entities"]["hashtags"].Size();
					if (0 == hashtag_size) {    // No Hashtag
						
						delete d;
						writer.EndObject();
						return "";
					} else { 		// hashtag_size hashtags
						
						
						
						
						// Process verified record
						// id: text: hashtags
						writer.String("hashtags");
						writer.StartArray();
						for (int i = 0; i < hashtag_size; ++i) {
							
							writer.String((*d)["entities"]["hashtags"][i]["text"].GetString());
						}
						writer.EndArray();
						writer.EndObject();
						
					}
				
			}
		}
	}
	
	result = s.GetString();
	
	delete d;	
	return result;
} 


// Process each file
void process_file(std::string ifile, std::string ofile) {
	
		
	std::string line = "";	
	
    
    std::ifstream file(ifile.c_str(), std::ios_base::in | std::ios_base::binary);
    std::ofstream fout(ofile.c_str());
	
	try {
        boost::iostreams::filtering_istream in;
        in.push(boost::iostreams::gzip_decompressor());
        in.push(file);
        

        while (std::getline(in, line)) {
			
			// Process each line: a json record
			//std::cout << line << std::endl;
		line = process_record(line);
		if (line.compare("") != 0) 
			fout << line << std::endl;
			//std::cout << line << std::endl;
			
        }
    } catch (const boost::iostreams::gzip_error& e) {
        std::cerr << e.what() << std::endl;
    }catch (std::exception const& e) {
        std::cerr << e.what() << std::endl;
    }
    
	fout.close();
    file.close();
}



int main(int argc, const char * argv[]) {
	
	clock_t start, end;
	
	char *tok;
	
	start = clock();
	
	std::string ifile, ofile, ifile_list, ofile_loc, line;
	
	if (argc < 3) {
		std::cout << "The input format is: [program_name] [file_list] [output_file directory]\n" << std::endl;
		exit(1);
	}
	
	//std::ifstream fin(argv[1]);     // read inputfile and output file (absolute path) full path
		
	//std::getline(fin, ifile_list, ' ');
	
	//std::getline(fin, ofile_loc, ' ');
		
	//fin.close();
	ifile_list = argv[1];
	ofile_loc = argv[2];
	
	std::ifstream fin(ifile_list.c_str());
	//fin.open(ifile_list.c_str(), std::ifstream::in);
	
	// get input directory and filename in format [dir] [file_name]
	while (std::getline(fin, line)) {
		
		tok = strtok((char*)line.c_str(), " ");
		ifile = tok;
		tok = strtok(NULL, " ");
		ofile = tok;
		// concatenate dir and file name => absolute path
		ifile = ifile + ofile;
		
		tok = strtok((char*)ofile.c_str(), ".");
		tok = strtok(NULL, ".");
		//std::cout << tok << std::endl;
		ofile = tok;
		ofile = ofile_loc +"/" + ofile + ".txt";
			
		process_file(ifile, ofile);
		//std::cout << ifile << std::endl;
		
	}
	
	fin.close();
	
	
	
	end = clock();
	
	// Output time to log file when task is completed
	std::cout << (end-start)/CLOCKS_PER_SEC <<"    " << currentDateTime() << std::endl;
	
    return 0;
}	// end main

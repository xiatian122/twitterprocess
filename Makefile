# Makefile 
# author: Tian Xia
# org: Infolab@tamu
# date: July 11, 2015

CC=g++

all : preprocess

staticlib : 
		cd cld2/internal; sh generate_staticlib.sh;
		cd ../../; 
	

preprocess : staticlib preprocess.cpp
	$(CC) preprocess.cpp -lboost_system-mt -lboost_iostreams-mt -I./cld2/internal/ -L./cld2/internal/ -ldetectlang -o preprocess



clean : 
		rm preprocess; 
		rm ./cld2/internal/libdetectlang.a 


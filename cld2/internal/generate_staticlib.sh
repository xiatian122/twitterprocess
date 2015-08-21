#!/usr/bin

cc -c ./*.cc 

ar -r libdetectlang.a *.o

rm *.o

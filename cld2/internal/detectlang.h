/**
* Author: Tian Xia
* tanxia@tamu.edu
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
* detect langugage dynamic linking library 
*
*
* modified from cld2 project
*/

#ifndef DETECTLANG_HEAD_
#define DETECTLANG_HEAD_

#include <stdio.h>
#include <string.h>
#include <fcntl.h>
#include <fstream>
#include <iostream>
#include <sys/mman.h>

#include "cld2_dynamic_compat.h"
#include "../public/compact_lang_det.h"
#include "../public/encodings.h"

namespace CLD2 {
	bool OneTest(Language lang_expected, const char* buffer, int buffer_length); 
}


	

#endif

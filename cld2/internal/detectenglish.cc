
#include "detectenglish.h"
#include "detectlang.h"

bool detect_english(const char* buffer) {
	
	int buffer_length = strlen(buffer);
	CLD2::Language lang_expected = CLD2::ENGLISH;
	return CLD2::OneTest(lang_expected, buffer, buffer_length);
}
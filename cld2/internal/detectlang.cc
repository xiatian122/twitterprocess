#include "detectlang.h"


namespace CLD2 {

bool OneTest(/*int flags, bool get_vector,*/
             Language lang_expected, const char* buffer, int buffer_length) {
		 
  int flags = 0;
  bool get_vector = false;
  bool is_plain_text = true;
  const char* tldhint = "";
  const Encoding enchint = UNKNOWN_ENCODING;
  const Language langhint = UNKNOWN_LANGUAGE;
  const CLDHints cldhints = {NULL, tldhint, enchint, langhint};
  Language language3[3];
  int percent3[3];
  double normalized_score3[3];
  ResultChunkVector resultchunkvector;
  int text_bytes;
  bool is_reliable;
  int valid_prefix_bytes;

  Language lang_detected = ExtDetectLanguageSummaryCheckUTF8(
                          buffer,
                          buffer_length,
                          is_plain_text,
                          &cldhints,
                          flags,
                          language3,
                          percent3,
                          normalized_score3,
                          get_vector ? &resultchunkvector : NULL,
                          &text_bytes,
                          &is_reliable,
                          &valid_prefix_bytes);
// expose DumpExtLang DumpLanguages
  bool good_utf8 = (valid_prefix_bytes == buffer_length);
  
  //if (!good_utf8) {
   // fprintf(stderr, "*** Bad UTF-8 after %d bytes<br>\n", valid_prefix_bytes);
    //fprintf(stdout, "*** Bad UTF-8 after %d bytes\n", valid_prefix_bytes);
  //}

  bool ok = (lang_detected == lang_expected);
  ok &= good_utf8;

  /*
  if (!ok) {
    if ((flags & kCLDFlagHtml) != 0) {
      fprintf(stderr, "*** Wrong result. expected %s, detected %s<br>\n",
              LanguageName(lang_expected), LanguageName(lang_detected));
    }
    fprintf(stdout, "*** Wrong result. expected %s, detected %s\n",
            LanguageName(lang_expected), LanguageName(lang_detected));
    fprintf(stdout, "%s\n\n", buffer);
  }
*/

  return ok;
}
}       // End namespace CLD2




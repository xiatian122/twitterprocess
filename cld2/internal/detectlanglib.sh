cc -O -fno-common -c detectlang.cc \
  cldutil.cc cldutil_shared.cc compact_lang_det.cc  compact_lang_det_hint_code.cc \
  compact_lang_det_impl.cc  debug.cc fixunicodevalue.cc \
  generated_entities.cc  generated_language.cc generated_ulscript.cc  \
  getonescriptspan.cc lang_script.cc offsetmap.cc  scoreonescriptspan.cc \
  tote.cc utf8statetable.cc  \
  cld_generated_cjk_uni_prop_80.cc cld2_generated_cjk_compatible.cc  \
  cld_generated_cjk_delta_bi_32.cc generated_distinct_bi_0.cc  \
  cld2_generated_quad0122.cc cld2_generated_deltaocta0122.cc \
  cld2_generated_distinctocta0122.cc  cld_generated_score_quad_octa_0122.cc  \
	  

	  cc -dynamiclib -install_name detectenglish.dylib \
		  -o detectenglish.dylib *.o
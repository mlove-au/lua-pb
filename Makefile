
%.result : %.lua
	luajit $< > $@


INTEGRATION_TEST_RESULTS= tests/check_proto.result \
     tests/dump_ast.result \
     tests/dump_names.result \
     tests/dump_tokens.result \
     tests/list_unknown.result \

UNIT_TEST_RESULTS=tests/test_luajit_int64_encode_decode.result \
     tests/test_big_numbers.result \
     tests/decode.result \
     tests/decode_raw.result \
     tests/raw_decode_encode.result \
     tests/test_big_numbers_decode.result \
     tests/test_big_numbers.result \
     tests/test_filename.result \
     tests/test_fullname.result \
     tests/test_import.result \
     tests/test_large_ints.result \
     tests/test_large_neg_ints.result \
     tests/test_media.result \
     tests/test_missing_required_field.result \
     tests/test_name.result \
     tests/test_oneof.result \
     tests/test_recursion.result \
     tests/test_varint64_encoding_low_32bits.result \
     tests/test_zigzag.result 


all: $(UNIT_TEST_RESULTS)


clean:
	-@rm -f $(UNIT_TEST_RESULTS) > /dev/null


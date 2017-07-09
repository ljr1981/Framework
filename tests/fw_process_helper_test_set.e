note
	description: "[
		Tests of {FW_PROCESS_HELPER}.
		]"
	testing: "type/manual"

class
	FW_PROCESS_HELPER_TEST_SET

inherit
	EQA_TEST_SET
		rename
			assert as assert_old
		end

	EQA_COMMONLY_USED_ASSERTIONS
		undefine
			default_create
		end

	TEST_SET_BRIDGE
		undefine
			default_create
		end

feature -- Test routines

	set_path_test
		note
			warning: "[
				This test is a FALSE-POSITIVE!
				==============================
				The setting of the path to include "blah" works only for the brief moment
				that the external call is in-effect. Otherwise, it does not impact this software.
				
				The Eiffel Studio program is able to (apparently) effect the state of the path
				using ISE_EIFFEL and ISE_LIBRARY as set in the Windows registry (or Linux equal).
				However, how this is accomplished is unknown to this library author at this time.
				Until that is discovered, this test will have its assertions commented out.
				When the solution is know, effect the solution and then rework this test.
				]"
		local
			l_mock: FW_PROCESS_HELPER
			l_blah,
			l_set_blah: STRING
		do
			if {PLATFORM}.is_windows then
				create l_mock
				assert_32 ("set_blah", not l_mock.output_of_command ("set_path.cmd", "").is_empty)
				l_blah := l_mock.output_of_command ("path.cmd", "")
				print ("blah: `" + l_blah + "'")
	--			assert_32 ("has_blah", l_blah.has_substring (";blah"))
			end
		end

	output_of_where_test
		local
			l_mock: FW_PROCESS_HELPER
		do
			create l_mock
			if {PLATFORM}.is_windows then
				assert_strings_equal ("where", l_mock.DOS_where_not_found_message, l_mock.output_of_command ("where you_wont_find_me.exe", ""))
			end
		end

	has_file_test
		local
			l_mock: FW_PROCESS_HELPER
		do
			create l_mock
			assert_32 ("not_found", not l_mock.has_file_in_path ("you_wont_find_me.exe"))
		end

	process_helper_tests
			-- New test routine
		local
			l_mock: FW_PROCESS_HELPER
			l_result: STRING
		do
			if {PLATFORM}.is_windows then
				create l_mock
				l_result := l_mock.output_of_command ("where notepad.exe", "")
				assert_integers_equal ("notepad_length", notepad_where.count, l_result.count)
				assert_strings_equal ("notepad", notepad_where, l_result)
			end
		end

feature {NONE} -- Implementation

	notepad_where: STRING = "C:\WINDOWS\System32\notepad.exe%R%NC:\WINDOWS\notepad.exe%R%N"

end



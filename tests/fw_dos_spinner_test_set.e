note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	FW_DOS_SPINNER_TEST_SET

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

	spinner_tests
			-- New test routine
		note
			testing:  "execution/isolated"
		local
			l_spinner: FW_DOS_SPINNER
		do
			create l_spinner
			l_spinner.next_prompt_with_text ("TEST").do_nothing
			assert_strings_equal ("test_1", "| TEST", l_spinner.last_prompt)
			assert_strings_equal ("test", "%B%B%B%B%B%B/ ABC", l_spinner.next_prompt_with_text ("ABC"))
		end

end



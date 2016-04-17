note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	MIXED_NUMBER_TEST_SET

inherit
	EQA_TEST_SET
		rename
			assert as assert_old
		undefine
			out
		end

	EQA_COMMONLY_USED_ASSERTIONS
		undefine
			default_create,
			out
		end

	TEST_SET_BRIDGE
		undefine
			default_create,
			out
		end

feature -- Test routines

	mixed_number_test_set
			-- New test routine
		local
			l_mixed: FW_MIXED_NUMBER
			l_formatter: MOCK_MIXED_NUMBER_FORMATTER
		do
			create l_mixed.make (False, 3, 3, 5)
			create l_formatter
			assert_strings_equal ("3_3_5ths", "3 3/5", l_formatter.string_format_for_mixed_number_without_zero_fraction (l_mixed))
		end

feature {NONE} -- Outputs

	out: like {ANY}.out
		do
			create Result.make_empty
		end

end



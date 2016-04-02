note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	FW_ATTRIBUTE_HELPER_TEST_SET

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

	FW_ATTRIBUTE_HELPER
		undefine
			default_create
		end

feature -- Test routines

	attribute_defaults_test
			-- `attribute_defaults_test'
		do
			set_attribute_value (agent color, "black")
			set_attribute_value (agent color, "red")
			set_attribute_value (agent color, "blue")
			set_attribute_value (agent color, "yellow")
			set_attribute_value (agent color, "orange")
		end

feature

	color: attached like attribute_tuple_anchor attribute Result := ["black", "black|red|blue|yellow|orange", Void, "color", is_unquoted] end

end



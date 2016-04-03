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
		redefine
			attribute_list
		end

feature -- Test routines

	attribute_defaults_test
			-- `attribute_defaults_test'
		note
			design_intent: "[
				This test is designed to expose bugs while generating `attributes_out'.
				Each attribute may have a list of default values, stored as a pipe-delimited
				string. The first value is the default. Thus, the attr_value = attr_default [1].
				]"
		do
			assert_integers_equal ("has_2_attributes", 2, attribute_list.count)

			set_attribute_value (agent color, "black")
			assert_strings_equal ("black", "", attributes_out)
			set_attribute_value (agent color, "red")
			check attached {STRING} color.attr_value as al_attr_value then
				assert_strings_equal ("red_1" , "red", al_attr_value)
			end
			assert_strings_equal ("red", "color=%"red%"", attributes_out)
			set_attribute_value (agent color, "blue")
			assert_strings_equal ("blue", "color=%"blue%"", attributes_out)
			set_attribute_value (agent color, "yellow")
			assert_strings_equal ("yellow", "color=%"yellow%"", attributes_out)
			set_attribute_value (agent color, "orange")
			assert_strings_equal ("orange", "color=%"orange%"", attributes_out)
		end

feature {NONE} -- Implementation: Attributes

	attribute_list: HASH_TABLE [attached like attribute_tuple_anchor, STRING]
			-- `attribute_list'.
		do
			create Result.make (Default_capacity)
			Result.force (color, color.attr_name)
			Result.force (values, values.attr_name)
		ensure then
			count: Result.count >= Default_capacity
			matching: across Result as ic all ic.key.same_string (ic.item.attr_name) end
		end

	color: attached like attribute_tuple_anchor attribute Result := ["black", "black|red|blue|yellow|orange", Void, "color", is_quoted] end
	values: attached like attribute_tuple_anchor attribute Result := [100, 100, 0, "values", is_unquoted] end

	Default_capacity: INTEGER = 2

end



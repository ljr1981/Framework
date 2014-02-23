note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	TEXT_FIELD_TEST_SET

inherit
	TEST_SET_HELPER

feature -- Test routines

	test_text_field
			-- Test FW_TEXT_FIELD loading and saving.
		note
			testing:  "execution/isolated"
		local
			l_field: FW_TEXT_FIELD
		do
			create l_field.make_with_objects (agent get_test_string_feature, agent save_test_string_feature, Void, Default_text)
			assert_strings_equal ("empty_text_field", Void, l_field.content)
				-- Ensure content loads from model --> field content
			l_field.load_content
			assert_strings_equal ("has_default_value", Default_text, l_field.content)
				-- Ensure field content --> model feature
			l_field.set_attached_content ("my_attached_stuff")
			assert_strings_equal ("has_my_attached_stuff", "my_attached_stuff", l_field.content)
			l_field.save_content
			assert_strings_equal ("has_my_attached_stuff_saved", "my_attached_stuff", test_string_feature)
		end

feature {NONE} -- Implementation

	get_test_string_feature: like test_string_feature
		do
			Result := test_string_feature
		end

	save_test_string_feature (a_string: like test_string_feature)
		do
			test_string_feature := a_string
		end

	test_string_feature: STRING
			-- Simulated model feature.
		attribute
			Result := default_text
		end

	default_text: STRING = "my_default_text"

end



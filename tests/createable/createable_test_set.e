note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date: $"
	revision: "$Revision: $"
	testing: "type/manual"

class
	CREATEABLE_TEST_SET

inherit
	TEST_SET_HELPER

feature -- Test routines

	test_createable
			-- New test routine
		note
			testing:  "execution/isolated"
		local
			l_object: CREATEABLE_TEST_OBJECT
		do
			create l_object.make_with_objects (my_name, counted_stuff)
			assert_strings_equal ("name_is_my_name", my_name, l_object.name)
			assert_equals ("counted_stuff_is_500", counted_stuff, l_object.counted_stuff)
		end

feature {NONE} -- Implementation: Constants

	my_name: STRING = "my_name"

	counted_stuff: INTEGER = 500

end



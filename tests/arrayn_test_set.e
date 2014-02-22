note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date: $"
	revision: "$Revision: $"
	testing: "type/manual"

class
	ARRAYN_TEST_SET

inherit
	TEST_SET_HELPER

feature -- Test routines

	test_arrayn
			-- New test routine
		local
			l_array_n: ARRAYN [INTEGER]
		do
			create l_array_n.make_n_based (<<[1,2], [1,2], [1,2]>>)
			create l_array_n.make_one_based (<<2, 2, 2>>)
			create l_array_n.make_one_based (<<2, 2, 3>>)
			assert_equals ("location_is_4", 4, l_array_n.location (<<1, 2, 1>>))
		end

end

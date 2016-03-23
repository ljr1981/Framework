note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	FW_PROCESS_HELPER_TEST_SET

inherit
	EQA_TEST_SET

feature -- Test routines

	process_helper_tests
			-- New test routine
		local
			l_mock: FW_PROCESS_HELPER
		do
			assert ("not_implemented", False)
		end

end



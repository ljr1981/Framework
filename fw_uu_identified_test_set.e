note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	FW_UU_IDENTIFIED_TEST_SET

inherit
	EQA_TEST_SET

feature -- Test routines

	mock_uuid_tests
			-- `mock_uuid_tests'
		local
			l_uuid: MOCK_UU_IDENTIFIED
		do
			create l_uuid
		end

end



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

	process_helper_tests
			-- New test routine
		local
			l_mock: FW_PROCESS_HELPER
		do
			do_nothing -- yet ...
		end

end



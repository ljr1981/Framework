note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	FW_CLI_FILE_MANAGER_TEST_SET

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

	FW_CLI_FILE_MANAGER
		undefine
			default_create
		end

feature -- Test routines

	fw_cli_file_manager_tests
			-- New test routine
		local
			l_file: PLAIN_TEXT_FILE
			l_dir: DIRECTORY
			l_env: EXECUTION_ENVIRONMENT
			l_src,
			l_dest: PATH
			l_result: STRING
		do
			create_temp_path
			create l_env

			create l_file.make_create_read_write (l_env.current_working_path.name.out + "\temp_file.txt")
			l_file.put_string ("something")
			l_file.close

			create l_src.make_from_string (l_env.current_working_path.name.out + "\temp_file.txt")
			l_result := move (<<l_src>>, path)

			remove_temp_path
		end

end



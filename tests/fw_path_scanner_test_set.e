note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	FW_PATH_SCANNER_TEST_SET

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

	FW_PROCESS_HELPER
		undefine
			default_create
		end

feature -- Test routines

	path_scanner_test
			-- `path_scanner_test'.
		note
			testing:  "execution/isolated"
		local
			l_env: EXECUTION_ENVIRONMENT
			l_value: STRING
			l_dir: DIRECTORY
			l_path: PATH
			l_exception: EXCEPTION
			l_mock: MOCK_PATH_SCANNER
		do
			create l_env
			if attached l_env.starting_environment.at ("LOCALAPPDATA") as al_local_appdata_path_string then
				create l_path.make_from_string (al_local_appdata_path_string + "\Github")
				create l_dir.make_with_path (l_path)
				if l_dir.exists then
					create l_mock
					l_mock.scan_path (l_path, 0)
					assert ("has_git_exe", attached l_mock.last_git_exe_path)
				else
					create l_exception
					l_exception.set_description ("Missing LOCALAPPDATA Github folder. Ensure Github Desktop App is installed.")
					l_exception.raise
				end
			else
				create l_exception
				l_exception.set_description ("Missing LOCALAPPDATA Environment Varaible.")
				l_exception.raise
			end
		end

end



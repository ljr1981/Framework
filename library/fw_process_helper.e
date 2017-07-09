note
	description: "[
		Abstract notion of a {FW_PROCESS_HELPER}.
		]"
	design: "[
		These "helper" features are designed to assist with
		use of the {PROCESS_IMP} and {PROCESS_FACTORY}.
		]"

class
	FW_PROCESS_HELPER

feature -- Status Report

	has_file_in_path (a_name: STRING): BOOLEAN
			-- `has_file_in_path' as `a_name'?
		local
			l_result,
			l_msg: STRING
		do
			l_msg := dos_where_not_found_message.twin
			l_result := output_of_command ("where " + a_name, "")
			Result := not l_result.same_string (l_msg) xor {PLATFORM}.is_unix
		end

feature -- Basic Operations

	last_error: INTEGER

	output_of_command (a_cmd, a_directory: STRING): STRING
                -- `output_of_command' `a_cmd' launched in `a_directory'.
        require
			cmd_attached: attached a_cmd
			dir_attached: attached a_directory
        local
                l_factory: PROCESS_FACTORY
                l_process: PROCESS
                retried: BOOLEAN
        do
        	create Result.make_empty
			if not retried then
				last_error := 0
				create Result.make (100)
				create l_factory
				l_process := l_factory.process_launcher_with_command_line (a_cmd, a_directory)
				l_process.set_hidden (True)
				l_process.set_separate_console (False)
				l_process.redirect_input_to_stream
				l_process.redirect_output_to_agent (agent (la_result, la_content: STRING)
														do
															if attached la_content then
																la_result.append_string (la_content)
															end
														end (Result, ?)
													)
				l_process.redirect_error_to_same_as_output
				l_process.set_on_fail_launch_handler (agent launch_fail_handler (Result))
				l_process.launch
				if is_wait_for_exit then
					l_process.wait_for_exit
				end
			else
				last_error := 1
			end
        rescue
			retried := True
			retry
        end

	launch_fail_handler (a_result: STRING)
		do
			last_error_result := a_result
		end

	last_error_result: detachable STRING

feature -- Status Report: Wait for Exit

	is_not_wait_for_exit: BOOLEAN

	is_wait_for_exit: BOOLEAN
		do
			Result := not is_not_wait_for_exit
		end

	set_do_not_wait_for_exit
		do
			is_not_wait_for_exit := True
		end

	set_wait_for_exit
		do
			is_not_wait_for_exit := False
		end

feature {TEST_SET_BRIDGE} -- Implementation: Constants

	DOS_where_not_found_message: STRING = "INFO: Could not find files for the given pattern(s).%R%N"

end

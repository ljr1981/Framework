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
				check valid_error_redirection: l_process.is_error_redirection_valid (5) end
				l_process.launch
				l_process.wait_for_exit
			else
				last_error := 1
			end
        rescue
			retried := True
			retry
        end

end

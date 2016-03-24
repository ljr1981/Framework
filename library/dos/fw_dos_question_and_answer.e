note
	description: "[
		Representation of a {FW_DOS_QUESTION_AND_ANSWER}.
		]"

class
	FW_DOS_QUESTION_AND_ANSWER

feature -- Access

	is_yes (a_question: STRING): BOOLEAN
			-- `is_yes' to `a_question'?
		local
			l_answer: CHARACTER
		do
			print (a_question + "? (Y/N): ")
			io.readline
			Result := io.last_string.has ('Y') or io.last_string.has ('y')
		end

end

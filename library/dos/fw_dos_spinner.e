note
	description: "[
		Representation of a {FW_DOS_SPINNER}
		]"
class
	FW_DOS_SPINNER

feature -- Access

	next_prompt_with_text (a_text: STRING): STRING
			-- `next_prompt_with_text' `a_text'.
		local
			l_last: STRING
		do
			Result := internal_next_prompt.out
			Result.append_character (' ')
			Result.append_string (a_text)
			l_last := last_prompt.twin
			last_prompt := Result
			across
				l_last as ic_last
			loop
				Result.prepend_character ('%B')
			end
		end

	next_prompt: STRING
			-- `next_prompt'
		do
			Result := "%B" + internal_next_prompt.out
		end

feature {TEST_SET_BRIDGE} -- Implementation

	last_prompt: STRING
			-- `last_prompt'.
		attribute
			create Result.make_empty
		end

	internal_next_prompt: CHARACTER
			-- `internal_next_prompt' in series.
		do
			Result := spin_characters [next_character_number + 1]
			next_character_number := next_character_number + 1
			if next_character_number > (spin_characters.count - 1) then
				next_character_number := 0
			end
		end

	next_character_number: INTEGER

	spin_characters: STRING = "|/-\"
			-- `spin_characters' used to show Current.

note
	design: "[
		Many times, a DOS program will need to tell the story of progress
		by some form of activity within the DOS window. A spinner of characters
		is an excellent way of getting this presentation into play.

		The spinner consists of four characters: |/-\ with a backspace
		character to move back and overwrite the last character, giving
		the illusion of a spinning prompt.
		]"

end

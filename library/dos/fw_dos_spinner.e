note
	description: "[
		Representation of a {FW_DOS_SPINNER}
		]"
class
	FW_DOS_SPINNER

feature -- Access

	next_prompt: STRING
			-- `next_prompt' in series.
		do
			create Result.make_empty
			Result.append_character ('%B')
			Result.append_character (spin_characters [next_character_number + 1])
			next_character_number := next_character_number + 1
			if next_character_number > 3 then
				next_character_number := 0
			end
		end

feature {NONE} -- Implementation

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

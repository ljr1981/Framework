note
	description: "[
		Mock representation of {FW_UU_IDENTIFIED}.
		]"

class
	MOCK_UU_IDENTIFIED

inherit
	FW_UU_IDENTIFIED

feature -- Access

	uuid_string: STRING
		do
			Result := (create {RANDOMIZER}).uuid.out
		end

end

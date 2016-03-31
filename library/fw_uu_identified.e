note
	description: "[
		Abstract notion of something that is identified with a {UUID}.
		]"

deferred class
	FW_UU_IDENTIFIED

feature -- Access

	uuid: UUID
			-- `uuid' of Current {FW_UU_IDENTIFIED} generated from `uuid_string'.
		once ("object")
			create Result.make_from_string (uuid_string)
		end

	uuid_string: STRING
			-- `uuid_string' to generate `uuid' from.
		note
			design: "[
				For each `item' receiving a permission, provide a UUID as a string constant.
				]"
		deferred
		end

end

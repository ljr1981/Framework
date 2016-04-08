note
	description: "[
		Abstract notion of something that is identified with a {UUID}.
		]"

deferred class
	FW_UU_IDENTIFIED

feature {NONE} -- Initialization

	make_with_uuid (a_uuid: like uuid)
			-- `make_with_uuid' `a_uuid'.
		do
			uuid := a_uuid
		ensure
			set: uuid ~ a_uuid
		end

	make_from_string (a_uuid_string: STRING)
			-- `make_from_string' `a_uuid_string'.
		require
			valid: (create {RANDOMIZER}).uuid.is_valid_uuid (a_uuid_string)
		do
			create uuid.make_from_string (a_uuid_string)
		end

feature -- Access

	uuid: UUID
			-- `uuid' of Current {FW_UU_IDENTIFIED} generated from `uuid_string'.
		attribute
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

feature -- Settings

	set_from_uuid (a_uuid: like uuid)
			-- `set_from_uuid' `a_uuid'.
		do
			uuid := a_uuid
		ensure
			set: uuid ~ a_uuid
		end

end

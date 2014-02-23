note
	description: "[
				Representation of {CREATEABLE_TEST_OBJECT}.
				]"
	date: "$Date: $"
	revision: "$Revision: $"

class
	CREATEABLE_TEST_OBJECT

inherit
	CREATEABLE

create
	make_with_objects

feature {NONE} -- Initialization

	make_with_objects (a_objects: attached like creation_objects_anchor)
			-- Initialize Current with `a_objects'.
		do
			name := a_objects.name
			counted_stuff := a_objects.counted_stuff
		end

feature {NONE} -- Implementation: Creation Objects

	creation_objects_anchor: detachable TUPLE [name: like name; counted_stuff: like counted_stuff]
			-- Creation objects anchor for Current

	is_valid_creation_objects (a_objects: attached like creation_objects_anchor): BOOLEAN
			-- Are the `a_objects' valid for Current?
		do
			Result := True
		end

feature -- Access

	name: STRING

	counted_stuff: INTEGER

end

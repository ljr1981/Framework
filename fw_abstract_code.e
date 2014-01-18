note
	description: "[
					Abstract notion of an Abstract Code
					
					What:
					a system of words, letters, figures, or other symbols substituted 
					for other words, letters, etc., esp. for the purposes of secrecy, or
					for a simplified representation of longer more complex words.
					]"
	date: "$Date$"
	revision: "$Revision$"

class
	FW_ABSTRACT_CODE

inherit
	CREATEABLE

create
	make_with_objects,
	make_empty

feature {NONE} -- Initialization

	make_empty
			-- Initialize Current as empty.
		do
			create name.make_empty
			create code.make_empty
		end

	make_with_objects (a_objects: attached like creation_objects_anchor)
			-- Initialize Current with `a_objects'.
		do
			name := a_objects.name
			code := a_objects.code
		end

feature {NONE} -- Implementation: Creation Objects

	creation_objects_anchor: detachable TUPLE [name: like name; code: like code]
			-- Creation objects anchor for Current

	is_valid_creation_objects (a_objects: attached like creation_objects_anchor): BOOLEAN
			-- Are the `a_objects' valid for Current?
		do
			Result := True
		end

feature -- Access

	name: STRING
			-- Name of Current.

	code: STRING
			-- Code of Current.

end

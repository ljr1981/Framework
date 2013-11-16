note
	description: "Summary description for {CREATEABLE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CREATEABLE

feature {NONE} -- Initialization

	make_with_objects (a_objects: attached like creation_objects_anchor)
			-- Initialize Current with `a_objects'.
		deferred
		end

feature -- Access

feature -- Measurement

feature -- Status report

feature -- Status setting

feature -- Cursor movement

feature -- Element change

feature -- Removal

feature -- Resizing

feature -- Transformation

feature -- Conversion

feature -- Duplication

feature -- Miscellaneous

feature -- Basic operations

feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation: Creation Objects

	creation_objects_anchor: detachable TUPLE [ANY]
			-- Creation objects anchor for Current
		deferred
		end

	is_valid_creation_objects (a_objects: attached like creation_objects_anchor): BOOLEAN
			-- Are the `a_objects' valid for Current?
		deferred
		end

invariant
	invariant_clause: True -- Your invariant here

end

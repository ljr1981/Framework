note
	description: "[
					Abstraction notion of a Createable Object
					
					Attributes of the `creation_objects_anchor' TUPLE represent those objects
					required for the creation of Current.
					]"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	FW_CREATEABLE

feature {NONE} -- Initialization

	make_with_objects (a_objects: attached like creation_objects_anchor)
			-- Initialize Current with `a_objects'.
		deferred
		end

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
	creation_objects_anchor_only: not attached creation_objects_anchor

end

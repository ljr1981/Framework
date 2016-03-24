note
	description: "[
					Representation of an Unit of Measure.
					
					What:
					A Unit of Measure as an Abstract Code, capable of conversion calculation.

					]"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	FW_UOM

inherit
	FW_ABSTRACT_CODE

feature -- Query

	convert_units (a_value: REAL; a_target_uom: FW_UOM): REAL
			-- Convert `a_value' of Current UOM to `a_target_uom'.
		deferred
		end

end

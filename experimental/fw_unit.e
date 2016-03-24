note
	description: "Summary description for {FW_UNIT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	FW_UNIT

inherit
	FW_UOM

feature {NONE} -- Initialization

	make_with_value (a_value: like value)
			-- Initialize Current with `a_value'.
		do
			value := a_value
		ensure
			value_set: value = a_value
		end

feature -- Access

	value: REAL
			-- Value of Current unit.

end

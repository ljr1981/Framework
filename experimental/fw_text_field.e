note
	description: "[
			Representation of {FW_TEXT_FIELD}.
		]"
	date: "$Date: $"
	revision: "$Revision: $"

class
	FW_TEXT_FIELD

inherit
	FW_DATA_SOURCED [STRING, EV_TEXT_FIELD]
		rename
			update_content_with_widget as update_content_from_widget
		end

create
	make_with_objects

feature {NONE} -- Initialization

	create_widget (a_default_content: like default_content)
			-- <Precursor>
		do
			if attached {like widget.text} a_default_content as al_default_content then
				create widget.make_with_text (al_default_content)
			else
				create widget
			end
		end

feature {NONE} -- Implementation

	update_content_from_widget
			-- <Precursor>
		do
			content := widget.text
		ensure then
			content_updated: attached content as al_content and then al_content.same_string (widget.text)
		end

end

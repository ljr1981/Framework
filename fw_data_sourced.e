note
	description: "[
			Representation of {FW_DATA_SOURCED}.
		]"
	date: "$Date: $"
	revision: "$Revision: $"

deferred class
	FW_DATA_SOURCED [G -> ANY, W -> EV_WIDGET]

inherit
	FW_CREATEABLE

feature {NONE} -- Initialization

	make_with_objects (a_objects: attached like creation_objects_anchor)
			-- Initialize Current with `a_objects'.
		do
			load_content_agent := a_objects.load_content_agent
			save_content_agent := a_objects.save_content_agent
			validate_content_agent := a_objects.validate_content_agent
			create_widget (a_objects.default_content)
			widget.key_press_actions.extend (agent on_widget_key_press_changes)
			widget.key_release_actions.extend (agent on_widget_key_release_changes)
		end

	create_widget (a_default_content: like default_content)
			-- Creation routine of `widget'.
		deferred
		end

feature -- Settings

	set_attached_content (a_content: attached like content)
			-- Set attached version of `a_content' into `content'.
		do
			set_content (a_content)
		end

	set_content (a_content: like content)
			-- Set `content' with `a_content'.
		do
			content := a_content
		ensure
			content_set: content ~ a_content
		end

feature -- Basic Operations

	load_content
			-- Load `content' of Current from source.
		do
			load_content_agent.call (Void)
			if attached {like content} load_content_agent.last_result as al_result then
				content := al_result
			end
			load_content_agent.clear_last_result
		end

	save_content
			-- Save `content' of Current to source.
		do
			save_content_agent.call (content)
		end

feature {NONE} -- Implementation: Creation Objects

	creation_objects_anchor: detachable TUPLE [load_content_agent: like load_content_agent; save_content_agent: like save_content_agent; validate_content_agent: like validate_content_agent; default_content: like default_content]
			-- Creation objects anchor for Current

	is_valid_creation_objects (a_objects: attached like creation_objects_anchor): BOOLEAN
			-- Are the `a_objects' valid for Current?
		do
			Result := True
		end

feature -- Status Report

	is_save_automatic: BOOLEAN
			-- `is_save_automatic' when content changes in `widget' and `content' to model?

feature -- Settings

	set_save_automatic
			-- Set `is_save_automatic' to True.
		do
			is_save_automatic := True
		ensure
			save_is_automatic: is_save_automatic
		end

feature {TEST_SET_HELPER} -- Implemenation

	content: detachable G
			-- Primitive content to be displayed in GUI by Current.

	default_content: like content
			-- Primitive content to be displayed in GUI by Current by default.

feature {NONE} -- Implemenation

	load_content_agent: FUNCTION [ANY, TUPLE, like content]
			-- Load from model to Current. pre/post-load actions.

	save_content_agent: PROCEDURE [ANY, TUPLE [like content]]
			-- Save Current to model. pre/post-save actions.

	validate_content_agent: detachable FUNCTION [ANY, TUPLE, BOOLEAN]
			-- Validate Current. pre/post-validate actions.

	widget: W
			-- GUI widget to use for the display of Current.

	on_widget_key_press_changes (a_key: EV_KEY)
			-- What to do when key press happens on widget.
		do
			do_nothing
		end

	on_widget_key_release_changes (a_key: EV_KEY)
			-- What happens on key release on widget.
		do
			update_content_with_widget
			if is_save_automatic then
				save_content
			end
		end

	update_content_with_widget
			-- Update `content' with content of `widget'
		deferred
		end

end

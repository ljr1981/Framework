note
	description: "[
		An EV_GRID which handles cell selection and focus movement based on key presses.
		]"
	design: "[
		Key presses to respond to and what to do:
		
		Key				What to do
		=========		==================================================================
		Home			Move to first item in row
		Ctrl+Home		Move to first item in grid (upper-left)
		End				Move to last item in row
		Ctrl+End		Move to last item in grid (lower-right)
		Page Up			In current column, move up one page or to top
		Page Down		In current column, move down one page or to bottom
		Tab				Move right to next item or first item of next row if in last item
		Enter			Activate current item for edit (with select all of text)
		Printable		Replace existing text with printable char and position 
							insertion caret to its right
		]"

class
	FW_GRID

inherit
	EV_GRID
		redefine
			initialize
		end

feature {NONE} -- Initialization

	initialize
			-- <Precursor>
		local
			l_colors: FW_STOCK_COLORS
		do
			create l_colors
			Precursor
			enable_column_separators
			key_press_actions.extend (agent handle_key_press (?))
			virtual_position_changed_actions.extend (agent handle_virtual_position_changed (?, ?))
			virtual_size_changed_actions.extend (agent handle_virtual_size_changed (?, ?))
			set_default_key_processing_handler (agent key_press_handler)

			set_focused_selection_color (l_colors.default_selected_list_item_background_color)
			set_focused_selection_text_color (l_colors.default_selected_list_item_foreground_color)
			set_non_focused_selection_color (l_colors.default_non_focused_selected_list_item_background_color)
			set_non_focused_selection_text_color (l_colors.default_non_focused_selected_list_item_foreground_color)
		end

feature -- Access

	first_fully_visible_row: detachable EV_GRID_ROW
			-- Gives the first fully visible row of the grid. Unlike `{EV_GRID}.first_visible_row', which returns the first partially visible row of the grid.
		require
			not_destroyed: not is_destroyed
		local
			l_indexes: ARRAYED_LIST [INTEGER]
			l_count: INTEGER
		do
			if is_displayed then
				l_indexes := visible_row_indexes
				l_count := l_indexes.count
				if l_count > 0 then
					Result := row (l_indexes.i_th (1))
					if l_count > 1 and then attached Result and then Result.virtual_y_position < maximum_virtual_y_position and then Result.virtual_y_position < virtual_y_position then
							-- First visible row is not fully visible, we go for the fully visible one if it exists.
						if
							attached row (l_indexes.i_th (2)) as l_next_row and then
							l_next_row.virtual_y_position + l_next_row.height <= virtual_y_position + viewable_height
						then
								-- Next item is fully visible, we use it as target.
							Result := l_next_row
						end
					end
				end
			end
		ensure
			has_rows_implies_result_not_void: visible_row_count > 0 implies attached Result
			no_rows_implies_result_void: visible_row_count = 0 implies not attached Result
		end

	last_fully_visible_row: detachable EV_GRID_ROW
			-- Gives the last fully visible row of the grid, Unlike `{EV_GRID}.last_visible_row' which returns the last partially visible row of the grid.
		require
			not_destroyed: not is_destroyed
		local
			l_indexes: ARRAYED_LIST [INTEGER]
			l_count: INTEGER
		do
			if is_displayed then
				l_indexes := visible_row_indexes
				l_count := l_indexes.count
				if l_count > 0 then
					Result := row (l_indexes.i_th (l_count))
					if l_count > 1 and then attached Result and then Result.virtual_y_position + Result.height > virtual_y_position + implementation.viewable_height then
							-- Last visible rows is not fully visible, we go for the fully visible one if it exists.
						if
							attached row (l_indexes.i_th (l_count - 1)) as l_prev_row and then
							l_prev_row.virtual_y_position >= virtual_y_position
						then
								-- Previous item is fully visible, we use it as target.
							Result := l_prev_row
						end
					end
				end
			end
		ensure
			has_rows_implies_result_not_void: visible_row_count > 0 implies attached Result
			no_rows_implies_result_void: visible_row_count = 0 implies not attached Result
		end

	viewable_row_count: INTEGER
			-- Number of items that will be scrolled when doing a page up or down operation.
		do
			Result := viewable_height // row_height
		ensure
			valid_result: Result = viewable_height // row_height
		end

feature -- Status Setting

	enable_row_colorizing
			-- Enable row colorizing.
		do
			is_row_colorizing_enabled := True
		end

	disable_row_colorizing
			-- Disable row colorizing.
		do
			is_row_colorizing_enabled := False
		end

	enable_enter_key_tabbing
			-- Enable enter key tabbing.
		do
			is_enter_key_tabbing_disabled := False
		end

	disable_enter_key_tabbing
			-- Disable enter key tabbing.
		do
			is_enter_key_tabbing_disabled := True
		end

	column_masks: ARRAYED_LIST [INPUT_MASK [ANY, DATA_COLUMN_METADATA [ANY]]]
		attribute
			create Result.make (20)
		end

feature -- Status Report

	is_row_colorizing_enabled: BOOLEAN
			-- True if colorizing rows is enabled.

	is_enter_key_tabbing_disabled: BOOLEAN
			-- Is tab navigation from "Enter key" blocked for Current?

feature -- Adders

	add_column (a_title: STRING; a_field: ANY; a_mask: detachable INPUT_MASK [ANY, DATA_COLUMN_METADATA [ANY]])
		local
			l_column: INTEGER
			l_mask: INPUT_MASK [ANY, DATA_COLUMN_METADATA [ANY]]
			l_font: EV_FONT
		do
			l_column := column_count + 1
			set_column_count_to (l_column)
			column (l_column).set_title (a_title)
			create l_font
			column (l_column).set_width (l_font.string_width (a_title) + 20)
			if attached a_mask as al_mask then
				l_mask := a_mask
			else
				if attached {DECIMAL} a_field as al_field then
					create {DECIMAL_VALUE_INPUT_MASK} l_mask.make (2, 10)
				elseif attached {DATE} a_field as al_field then
					create {DATE_TIME_VALUE_INPUT_MASK} l_mask.make_with_date
				elseif attached {DATE_TIME} a_field as al_field then
					create {DATE_TIME_VALUE_INPUT_MASK} l_mask.make_with_date_and_time
				elseif attached {TIME} a_field as al_field then
					create {DATE_TIME_VALUE_INPUT_MASK} l_mask.make_with_time
				elseif attached {STRING} a_field as al_field then
					create {STRING_VALUE_INPUT_MASK} l_mask.make_repeating ("!")
				else
					create {STRING_VALUE_INPUT_MASK} l_mask.make_repeating ("!")
				end
			end
			column_masks.force (l_mask)
		end
feature -- Ops

	apply_mask_to_selected
		local
			l_mask: INPUT_MASK [ANY, DATA_COLUMN_METADATA [ANY]]
		do
			if
				has_selected_item
					and then attached {EV_GRID_EDITABLE_ITEM} selected_items [1] as al_grid_item
					and then al_grid_item.column.index <= column_masks.count
			then
				l_mask := column_masks [al_grid_item.column.index]
				if attached al_grid_item.text_field as al_field then
					l_mask.initialize_masking_widget_events (al_field)
				end
			end
		end

feature {TEST_SET_BRIDGE} -- Implementation

	key_press_handler (a_key: EV_KEY): BOOLEAN
			-- Handle Page Up and Page Down, otherwise allow default key press handling.
		do
			inspect
				a_key.code
			when
				{EV_KEY_CONSTANTS}.key_page_up,
				{EV_KEY_CONSTANTS}.key_page_down,
				{EV_KEY_CONSTANTS}.key_home,
				{EV_KEY_CONSTANTS}.key_end
			then
				if is_single_item_selection_enabled or is_single_row_selection_enabled then
					Result := False
				else
					Result := True
				end
			else
				Result := True
			end
			inspect
				a_key.code
			when {EV_KEY_CONSTANTS}.key_enter then
				if
					attached selected_editable_item as al_item
				then
					al_item.activate
					if attached selected_editable_item_text_field as al_field then
						if not al_field.text.is_empty then
							al_field.select_all
						else
							al_field.set_caret_position (al_field.text.count + 1)
						end
					end
				end
			else
				if
					a_key.is_printable
						and then attached selected_editable_item as al_item
						and then attached selected_editable_item_text_field as al_field
				then
					al_item.activate
				end
			end
		end

	selected_editable_item: detachable EV_GRID_EDITABLE_ITEM
		do
			if
				has_selected_item
					and then attached {EV_GRID_EDITABLE_ITEM} selected_items [1] as al_item
			then
				Result := al_item
			end
		end

	selected_editable_item_text_field: detachable EV_TEXT_FIELD
		do
			if
				has_selected_item
					and then attached {EV_GRID_EDITABLE_ITEM} selected_items [1] as al_item
					and then attached {EV_TEXT_FIELD} al_item.text_field as al_field
			then
				Result := al_field
			end
		end

	handle_key_press (a_key: EV_KEY)
			-- Process a key press event from `grid'.
		do
			if not is_destroyed and then (row_count > 0 and column_count > 0) then
				inspect
					a_key.code
				when {EV_KEY_CONSTANTS}.key_page_up then
					handle_key_page_up_down (True)
				when {EV_KEY_CONSTANTS}.key_page_down then
					handle_key_page_up_down (False)
				when {EV_KEY_CONSTANTS}.key_home then
					handle_key_home_end (True)
				when {EV_KEY_CONSTANTS}.key_end then
					handle_key_home_end (False)
				else
					-- No custom handling needed.
				end
			end
		end

	handle_key_enter (a_key: EV_KEY) --obsolete
			-- `handle_enter_key' or printable `a_key'.
		do
			if -- First, do we have a selected editable grid item?
				has_selected_item
					and then attached {EV_GRID_EDITABLE_ITEM} selected_items [1] as al_item
			then
				al_item.activate
					-- First, we presume we will have a text field post-activation
				check has_field: attached {EV_TEXT_FIELD} al_item.text_field as al_field then
						-- Second, if the field is empty, then just place our printable character
						--	and put the insertion point caret to its right.
					if al_field.text.is_empty then
						al_field.set_text (a_key.text.out)
						al_field.set_caret_position (2)
					else
							-- Otherwise, if we have a printable character (enter is not printable)
							-- 	then set that and position the caret ...
						if a_key.is_printable then
							al_field.set_text (a_key.text.out)
							al_field.set_caret_position (2)
						else
								-- Otherwise, just select all of the text already in the field
							al_field.select_all
						end
					end

				end -- check -> al_field
			end
		end

	handle_key_page_up_down (a_is_up: BOOLEAN)
			-- Page Up key press moves selection to top of current page, or if at top, top of next page at the same column position.
			-- Ctrl+Page Up key press moves selection to item in first row with same column index.
			-- Page Down key press moves selection to bottom of current page, or if at bottom, bottom of next page at the same column position.
			-- Ctrl+Page Up key press moves selection to item in last row with same column index.
		require
			has_at_least_one_row_and_column: row_count > 0 and column_count > 0
		local
			l_column_index, l_row_index, l_scroll_height, l_proportion, l_new_virtual_y: INTEGER
			l_items: ARRAYED_LIST [EV_GRID_ITEM]
			l_item: detachable EV_GRID_ITEM
			l_target_row: detachable EV_GRID_ROW
		do
			if selected_items.valid_index (1) then
				l_column_index := selected_items.i_th (1).column.index

				if ev_application.ctrl_pressed then
					if a_is_up then
							-- Will set vertical scroll bar to scroll all the way to the top.
						l_proportion := 0
						if viewable_row_indexes.is_empty then
							l_row_index := 1
						else
							l_row_index := viewable_row_indexes.first
						end
					else
							-- Will set vertical scroll bar to scroll all the way to the bottom.
						l_proportion := 1
						if viewable_row_indexes.is_empty then
							l_row_index := row_count
						else
							l_row_index := viewable_row_indexes.last
						end
					end

					l_item := item (l_column_index, l_row_index)
					if virtual_height > viewable_height and is_vertical_scroll_bar_show_requested then
						vertical_scroll_bar.set_proportion (l_proportion)
					end
				else
					if a_is_up then
						l_target_row := first_fully_visible_row
					else
						l_target_row := last_fully_visible_row
					end
						-- `has_selected_item' also returns True if row selection is enabled and a row is selected.
					if has_selected_item then
						l_items := selected_items
						l_item := l_items.first
						if attached l_target_row as al_row then
							l_row_index := al_row.index
							if l_item.row.index = l_row_index then
									-- Number of rows we want to scroll, minimum of `1'.
								l_scroll_height := ((viewable_row_count - 1).max (1)) * row_height
								if a_is_up then
										-- Top row is the first selected row, we can scroll up.
									set_virtual_position (virtual_x_position, (l_item.row.virtual_y_position - l_scroll_height).max (0))
									l_target_row := first_fully_visible_row
								else
										-- Bottom row is the last selected row, we can scroll down.
									l_new_virtual_y := l_item.row.virtual_y_position + l_item.row.height - viewable_height + l_scroll_height
									set_virtual_position (virtual_x_position, l_new_virtual_y.min (maximum_virtual_y_position))
									l_target_row := last_fully_visible_row
								end
								if attached l_target_row as al_target_row then
									l_row_index := al_target_row.index
								end
							end
							l_item := item (l_column_index, l_row_index)
						end
					end
				end
				if attached l_item as al_item and then al_item.is_displayed then
					if is_single_item_selection_enabled then
						select_item (l_column_index, l_row_index)
					else
						select_row (l_row_index)
					end
				else
					select_row (l_row_index)

					l_new_virtual_y := selected_rows.i_th (1).virtual_y_position
					if ev_application.ctrl_pressed or maximum_virtual_y_position < l_new_virtual_y then
						set_virtual_position (virtual_x_position, maximum_virtual_y_position)
					else
						set_virtual_position (virtual_x_position, l_new_virtual_y)
					end
					ev_application.add_idle_action_kamikaze (agent select_item (l_column_index, l_row_index))
				end
			end
		end

	handle_key_home_end (a_is_home: BOOLEAN)
			-- Home key press moves selection to first item in current row.
			-- Ctrl+End key press moves selection to first item in first row.
			-- End key press moves selection to last item in row.
			-- Ctrl+End key press moves selection to last item in last row.
		require
			has_at_least_one_row_and_column: row_count > 0 and column_count > 0
		local
			l_column_index, l_row_index, l_proportion: INTEGER
			l_item: detachable EV_GRID_ITEM
		do
			if a_is_home then
				l_column_index := displayed_column (1).index
					-- Will set horizontal scroll bar to scroll all the way left.
				l_proportion := 0
			else
				l_column_index := displayed_column (displayed_column_count).index
					-- Will set horizontal scroll bar to scroll all the way right.
				l_proportion := 1
			end

			if ev_application.ctrl_pressed then
				if a_is_home then
					l_row_index := 1
				else
					if viewable_row_indexes.is_empty then
						l_row_index := row_count
					else
						l_row_index := viewable_row_indexes.last
					end
				end
			else
				l_row_index := selected_items.i_th (1).row.index
			end

			l_item := item (l_column_index, l_row_index)

			if attached l_item as al_item and then al_item.is_displayed then
				select_item (l_column_index, l_row_index)
				if virtual_width > viewable_width and is_horizontal_scroll_bar_show_requested then
					horizontal_scroll_bar.set_proportion (l_proportion)
				end
			else
				if ev_application.ctrl_pressed then
					if a_is_home then
						set_virtual_position (0, 0)
					else
						set_virtual_position (maximum_virtual_x_position, maximum_virtual_y_position)
					end
				else
					set_virtual_position (maximum_virtual_x_position, virtual_y_position)
				end
				ev_application.add_idle_action_kamikaze (agent select_item (l_column_index, l_row_index))
			end
		end

	select_item (a_column_index, a_row_index: INTEGER)
			-- Select item at `a_column_index', `a_row_index'.
		require
			valid_column_index: 0 < a_column_index and a_column_index <= column_count
			valid_row_index: 0 < a_row_index and a_row_index <= row_count
		local
			l_item: detachable EV_GRID_ITEM
		do
			l_item := item (a_column_index, a_row_index)
			if attached l_item as al_item then
				select_row (a_row_index)
				remove_selection
				al_item.enable_select
				al_item.ensure_visible
			end
		end

	handle_virtual_position_changed (a_virtual_x_position, a_virtual_y_position: INTEGER)
			-- a_virtual_x_position: INTEGER -- New `virtual_x_position' of grid.
			-- a_virtual_y_position: INTEGER -- New `virtual_y_position' of grid.
		do
			colorize_alternating_rows
		end

	handle_virtual_size_changed (a_virtual_width, a_virtual_height: INTEGER)
			-- a_virtual_width: INTEGER -- New `virtual_width' of grid.
			-- a_virtual_height: INTEGER -- New `virtual_height' of grid.
		do
			colorize_alternating_rows
		end

	colorize_alternating_rows
			-- Set alternating background color for visible rows.
			-- This notion of visible is what the human observing the grid can actually see.
		local
			l_row: detachable EV_GRID_ROW
			l_even_row: BOOLEAN
			l_first_row_index, l_last_row_index: INTEGER
			l_colors: FW_STOCK_COLORS
		do
			-- Only colorize rows that are visible to the user on the screen.
			if is_displayed and is_row_colorizing_enabled and then row_count > 0 then
				create l_colors
				if attached first_fully_visible_row as al_full_row then
					l_first_row_index := al_full_row.index
					if l_first_row_index > 1 and then attached row (l_first_row_index - 1) as al_partial_row then
						l_first_row_index := al_partial_row.index
					end
				else
					l_first_row_index := 1
				end
				if attached last_fully_visible_row as al_full_row then
					l_last_row_index := al_full_row.index
					if l_last_row_index < row_count and then attached row (l_last_row_index + 1) as al_partial_row then
						l_last_row_index := al_partial_row.index
					end
				else
					l_last_row_index := row_count
				end
				l_row := row (l_last_row_index)

				if attached l_row then
					across l_first_row_index |..| l_last_row_index as ic_row_counter loop
						l_row := row (ic_row_counter.item)
						if l_row.is_show_requested and then (attached l_row.parent_row as al_row implies al_row.is_expanded) then
							if l_even_row then
								l_row.set_background_color (l_colors.default_list_even_row_background_color)
							else
								l_row.set_background_color (l_colors.default_list_odd_row_background_color)
							end
							l_even_row := not l_even_row
						end
					end
				end
			end
		end

	ev_environment: EV_ENVIRONMENT
		once
			create Result
		end

	ev_application: EV_APPLICATION
			-- Application Access.
		local
			l_application: detachable EV_APPLICATION
		do
			l_application := ev_environment.application
			check l_application_available: attached l_application end
			Result := l_application
		end

end

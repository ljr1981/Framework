note
	warning: "[
		NOT A PART OF LIBRARY!
		======================
		
		This class is not a part of this library! I had this library open and was
		coding out a response to a question about creating a simple extension of
		the {ARRAY2} class to have easy-to-understand features. I coded that example
		and its test here. This needs to be moved to the Catch-all library I call
		"Framework" (see EIS link below).
		]"
		EIS: "name=Framework", "src=https://github.com/ljr1981/Framework"
	detail: "[
		Extended the ARRAY2 class by adding convenience features that make more sense
		to the casual user.
		
		row (i) --> gives back the row at `i'
		column (i) --> gives back the column at `i'
		
		put_row (row, i) --> puts row data at row i
		put_row_offset (row, i, o) --> puts row data at row i starting at column o (offset)
		put_column (col, i) --> puts column data at column i
		put_column_offset (col, i, o) --> puts column data at column i starting at row o (offset)
		
		There are perhaps other convenience features as well, but these were the obvious ones.
		]"

class
	FW_ARRAY2_EXT [G]

inherit
	ARRAY2 [G]
		rename
			height as row_count,
			width as column_count
		redefine
			make_filled
		end

create
	make,
	make_filled

feature {NONE} -- Initialization

	make_filled (a_default_value: G; nb_rows, nb_columns: INTEGER_32)
			-- <Precursor>
			-- And save `a_default_value'.
		do
			default_value_internal := a_default_value
			Precursor (a_default_value, nb_rows, nb_columns)
		end

feature -- Access

	row (i: INTEGER): ARRAY [G]
			-- Fetch `row' number `i' from Current.
		require
			valid_i: i >= 1 and then i <= row_count
		local
			l_result: ARRAYED_LIST [G]
		do
			create l_result.make (column_count)
			across
				1 |..| column_count as ic_col
			loop
				l_result.force (item (i, ic_col.item))
			end
			Result := l_result.to_array
		ensure
			row_same: across 1 |..| Result.count as ic all
							item (i, ic.item) ~ Result.item (ic.item)
						end
		end

	column (i: INTEGER): ARRAY [G]
			-- Fetch `column' number `i' from Current.
		require
			valid_i: i >= 1 and then i <= column_count
		local
			l_result: ARRAYED_LIST [G]
		do
			create l_result.make (row_count)
			across
				1 |..| row_count as ic_row
			loop
				l_result.force (item (ic_row.item, i))
			end
			Result := l_result.to_array
		ensure
			col_same: across 1 |..| Result.count as ic all
							item (ic.item, i) ~ Result.item (ic.item)
						end
		end

	rows: ARRAYED_LIST [ARRAY [G]]
			-- The `rows' of Current.
		do
			create Result.make (row_count)
			across
				1 |..| row_count as ic
			loop
				Result.force (row (ic.item))
			end
		ensure
			Result.count = row_count
		end

	columns: ARRAYED_LIST [ARRAY [G]]
			-- The `columns' of Current.
		do
			create Result.make (column_count)
			across
				1 |..| column_count as ic
			loop
				Result.force (column (ic.item))
			end
		ensure
			Result.count = column_count
		end

feature -- Settings

	put_row (a_row: ARRAY [G]; a_row_index: INTEGER)
			-- Put items in `a_row' into Current on `a_row_index'.
		require
			col_count: a_row.count = column_count
		do
			across
				a_row as ic
			loop
				put (ic.item, a_row_index, ic.cursor_index)
			end
		ensure
			row_put: across 1 |..| a_row.count as ic all
							item (a_row_index, ic.item) ~ a_row.item (ic.item)
						end
		end

	put_row_offset (a_items: ARRAY [G]; a_row_index, a_offset: INTEGER)
			-- Put `a_items' into Current, starting in column number `a_offset'.
		require
			non_empty: not a_items.is_empty
			col_count: a_items.count <= column_count
			valid_offset: a_offset >= 1 and then
							a_offset < column_count and then
							column_count >= (a_offset + a_items.count - 1)
		do
			across
				a_items as ic
			loop
				put (ic.item, a_row_index, ic.cursor_index + a_offset - 1)
			end
		ensure
			row_put: across 1 |..| a_items.count as ic all
							item (a_row_index, ic.item + a_offset - 1) ~ a_items.item (ic.item)
						end
		end

	put_column (a_column: ARRAY [G]; a_column_index: INTEGER)
			-- Put items in `a_column' into Current on `a_column_index'.
		require
			row_count: a_column.count = row_count
		do
			across
				a_column as ic
			loop
				put (ic.item, ic.cursor_index, a_column_index)
			end
		ensure
			col_put: across 1 |..| a_column.count as ic all
							item (ic.item, a_column_index) ~ a_column.item (ic.item)
						end
		end

	put_column_offset (a_items: ARRAY [G]; a_column_index, a_offset: INTEGER)
			-- Put `a_items' into Current, starting in row number `a_offset'.
		require
			non_empty: not a_items.is_empty
			row_count: a_items.count <= row_count
			valid_offset: a_offset >= 1 and then
							a_offset < row_count and then
							row_count >= (a_offset + a_items.count - 1)
		do
			across
				a_items as ic
			loop
				put (ic.item, ic.cursor_index + a_offset - 1, a_column_index)
			end
		ensure
			column_put: across 1 |..| a_items.count as ic all
							item (ic.item + a_offset - 1, a_column_index) ~ a_items.item (ic.item)
						end
		end

	put_by_row (a_items: ARRAY [G]; a_starting_row: INTEGER)
			-- Put `a_items' into Current, starting at `a_starting_row'
			-- NOTE: If the count of `a_items' does not match `column_count'
			-- 	precisely, then any remaining columns in the last row will
			--	be filled with `default_value'.
		require
			space: row_count > 0 and column_count > 0
			valid_starting: a_starting_row > 0 and then a_starting_row <= row_count
		local
			rn, cn: INTEGER
		do
			across
				a_items as ic
			from
				rn := a_starting_row; cn := 0
			loop
				cn := cn + 1
				if cn > column_count then
					cn := 1; rn := rn + 1
					if rn > row_count then
						resize_with_default (default_value, row_count + 1, column_count)
					end
				end
				put (ic.item, rn, cn)
			end
		end

	append_by_row (a_items: ARRAY [G])
			-- Append `a_items' to bottom (current `row_count' + 1)
			-- 	(grow by at least 1 row and then `put_by_row').
		do
			resize_with_default (default_value, row_count + 1, column_count)
			put_by_row (a_items, row_count)
		end

Feature {NONE} -- Implementation

	default_value: attached like default_value_internal
		do
			check attached default_value_internal as al_value then Result := al_value end
		end

	default_value_internal: detachable G

end

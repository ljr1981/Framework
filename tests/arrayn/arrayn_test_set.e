note
	description: "[
		Tests of {FW_ARRAYN}
		]"
	testing: "type/manual"

class
	ARRAYN_TEST_SET

inherit
	EQA_TEST_SET
		rename
			assert as assert_old
		end

	EQA_COMMONLY_USED_ASSERTIONS
		undefine
			default_create
		end

	TEST_SET_BRIDGE
		undefine
			default_create
		end

feature -- Test routines

	test_make_n_based
			-- General testing of {FW_ARRAYN}
		note
			testing:  "execution/isolated"
		local
			l_array_n: FW_ARRAYN [INTEGER]
		do
			create l_array_n.make_n_based (<<[1,2], [1,2], [1,2]>>)
			create l_array_n.make_one_based (<<2, 2, 2>>)
			create l_array_n.make_one_based (<<2, 2, 3>>)
			assert_equal ("location_is_4", 4, l_array_n.location (<<1, 2, 1>>))
		end

	test_one_based_filled
			-- Exercise class contracts of `make_one_based_filled' of {FW_ARRAYN}
		note
			testing:  "execution/isolated"
		local
			l_array_n: FW_ARRAYN [CREATEABLE_TEST_OBJECT]
			l_test_object: CREATEABLE_TEST_OBJECT
		do
			create l_test_object.make_with_objects (name_string, counted_stuff)
			l_array_n := test_array_filled (l_test_object)
		end

	test_replace
			-- Exercise and test {FW_ARRAYN}.place/replace.
		note
			testing:  "execution/isolated"
		local
			l_array_n: FW_ARRAYN [CREATEABLE_TEST_OBJECT]
			l_test_object: CREATEABLE_TEST_OBJECT
		do
			create l_test_object.make_with_objects (name_string, counted_stuff)
			l_array_n := test_array_filled (l_test_object)
			create l_test_object.make_with_objects ("another_name", 10)
			l_array_n.replace (l_test_object, <<1,2,2>>)
			assert_equal ("another_name_and_10", l_test_object, l_array_n.item (<<1,2,2>>))
		end

	test_place
			-- Exercise and test {FW_ARRAYN}.place/replace.
		note
			testing:  "execution/isolated"
		local
			l_array_n: FW_ARRAYN [CREATEABLE_TEST_OBJECT]
			l_test_object: CREATEABLE_TEST_OBJECT
		do
			create l_test_object.make_with_objects (name_string, counted_stuff)
			l_array_n := test_array_empty
			l_array_n.place (l_test_object, <<1,2,2>>)
			assert_equal ("another_name_and_10", l_test_object, l_array_n.item (<<1,2,2>>))
		end

	test_clear_all
			-- Exercise and test {FW_ARRAYN}.clear_all/is_empty
		note
			testing:  "execution/isolated"
		local
			l_array_n: FW_ARRAYN [CREATEABLE_TEST_OBJECT]
			l_test_object: CREATEABLE_TEST_OBJECT
		do
			create l_test_object.make_with_objects (name_string, counted_stuff)
			l_array_n := test_array_empty
			l_array_n.place (l_test_object, <<1,2,2>>)
			assert_equal ("another_name_and_10", l_test_object, l_array_n.item (<<1,2,2>>))
			l_array_n.clear_all
			assert ("array_filled_any", across l_array_n.internal_items as ic_items all attached {ANY} ic_items.item end)
		end

	test_location
			-- Exercise and test {FW_ARRAYN}.location
			--| Construct the vector from the upper bounds of the array itself and then
			--|		test to see if that derived vector matches the Max_size of the array.
		note
			testing:  "execution/isolated"
		local
			l_array_n: FW_ARRAYN [CREATEABLE_TEST_OBJECT]
			l_vector: ARRAY [INTEGER]
		do
			l_array_n := test_array_empty
			create l_vector.make_filled (0, 1, l_array_n.bounds.count)
			across 1 |..| l_array_n.dimensions as ic_index loop
				l_vector.put (l_array_n.bounds [ic_index.item].upper_nb, ic_index.item)
			end
			assert_integers_equal ("max_location_is_dimensions", l_array_n.Max_size, l_array_n.location (l_vector))
		end

feature {NONE} -- Implementation

	name_string: STRING = "my_name"

	counted_stuff: INTEGER = 500

	test_array_filled (a_default: CREATEABLE_TEST_OBJECT): FW_ARRAYN [CREATEABLE_TEST_OBJECT]
			-- Test array one.
		once
			create Result.make_n_based_filled (<<[1,2], [1,2], [1,2]>>, a_default)
		end

	test_array_empty: FW_ARRAYN [CREATEABLE_TEST_OBJECT]
			-- Test array one.
		once
			create Result.make_n_based (<<[1,2], [1,2], [1,2]>>)
		end

feature -- Testing

feature -- Test routines

	array2_ext_test
		local
			l_array: FW_ARRAY2_EXT [INTEGER]
		do
			create l_array.make_filled (0, 3, 4)
			l_array.put_row (row_1, 1)
			l_array.put_row (row_2, 2)
			l_array.put_row (row_3, 3)
			assert_integers_equal ("row_3_col_4", 4_000, l_array.item (3, 4)) -- Ensure on `put_row' now handles this!

			assert_arrays_equal ("row_1", row_1, l_array.row (1))
			assert_arrays_equal ("row_2", row_2, l_array.row (2))
			assert_arrays_equal ("row_3", row_3, l_array.row (3))

			l_array.rows.do_nothing
			across
				l_array.rows as ic
			loop
				inspect
					ic.cursor_index
				when 1 then
					assert_arrays_equal ("row_1", row_1, ic.item)
				when 2 then
					assert_arrays_equal ("row_2", row_2, ic.item)
				when 3 then
					assert_arrays_equal ("row_3", row_3, ic.item)
				else

				end
			end

			assert_arrays_equal ("col_1", col_1, l_array.column (1))
			assert_arrays_equal ("col_2", col_2, l_array.column (2))
			assert_arrays_equal ("col_3", col_3, l_array.column (3))
			assert_arrays_equal ("col_4", col_4, l_array.column (4))

			l_array.columns.do_nothing
			across
				l_array.columns as ic
			loop
				inspect
					ic.cursor_index
				when 1 then
					assert_arrays_equal ("col_1", col_1, ic.item)
				when 2 then
					assert_arrays_equal ("col_2", col_2, ic.item)
				when 3 then
					assert_arrays_equal ("col_3", col_3, ic.item)
				when 4 then
					assert_arrays_equal ("col_3", col_4, ic.item)
				else

				end
			end


			l_array.put_row_offset (offset_2, 2, 2) -- put `offset_2' in row-2, starting in col-2
			assert_arrays_equal ("offset_2_result", offset_2_result, l_array.row (2))

		end

feature {NONE} -- Constants

	row_1: ARRAY [INTEGER]
			-- Row data
		once Result := <<10, 20, 30, 40>> end

	row_2: ARRAY [INTEGER]
			-- Row data
		once Result := <<100, 200, 300, 400>> end

	row_3: ARRAY [INTEGER]
			-- Row data
		once Result := <<1_000, 2_000, 3_000, 4_000>> end

	col_1: ARRAY [INTEGER]
			-- Column data
		once Result := <<10, 100, 1_000>> end

	col_2: ARRAY [INTEGER]
			-- Column data
		once Result := <<20, 200, 2_000>> end

	col_3: ARRAY [INTEGER]
			-- Column data
		once Result := <<30, 300, 3_000>> end

	col_4: ARRAY [INTEGER]
			-- Column data
		once Result := <<40, 400, 4_000>> end

	offset_2: ARRAY [INTEGER]
			-- Offset data
		once Result := <<-200, -300>> end

	offset_2_result: ARRAY [INTEGER]
			-- Offset data
		once Result := <<100, -200, -300, 400>> end

end

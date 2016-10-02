note
	description: "[
		Representation of an {FW_PATH_SCANNER}.
		]"

deferred class
	FW_PATH_SCANNER

feature -- Basic Operations

	scan (a_path: PATH; a_file: STRING): detachable PATH
		local
			l_dir: DIRECTORY
		do
			create l_dir.make_with_path (a_path)
			if across l_dir.entries as ic some ic.item.name.out.same_string (a_file) end then
				create Result.make_from_string (a_path.absolute_path.name.out + "\" + a_file)
			else
				across
					l_dir.entries as ic
				until
					attached Result
				loop
					if not (ic.item.is_current_symbol or ic.item.is_parent_symbol) then
						Result := scan (create {PATH}.make_from_string (a_path.name.out + "\" + ic.item.name.out), a_file)
					end
				end
			end
		end

	scan_path (a_path: PATH; a_level: INTEGER)
			-- Recursively `scan_path' based on `a_path' (root or sub-path).
		note
			design: "[
				The `scan_path' is recursive (e.g. this feature calls itself).
				]"
		local
			l_dir: DIRECTORY
		do
			handle_current_path (a_path, a_level)
			if is_scan_down then
				create l_dir.make_with_path (a_path)
				across
					l_dir.entries as ic_entries
				loop
					if not (ic_entries.item.is_current_symbol or ic_entries.item.is_parent_symbol) then -- ignore "."/".." paths
						scan_path (create {PATH}.make_from_string (l_dir.name.out + a_path.directory_separator.out + ic_entries.item.name.out), a_level + 1)
					end
				end
			end
			is_scan_down := False
		end

	handle_current_path (a_path: PATH; a_level: INTEGER)
			-- `handle_current_path'
		deferred
		end

	is_scan_down: BOOLEAN
			-- `is_scan_down' another folder/directory level?

end

note
	description: "[
		Abstract notion of an {FW_ATTRIBUTE_HELPER}.
		]"

deferred class
	FW_ATTRIBUTE_HELPER

inherit
	ANY
		redefine
			out
		end

feature -- Output

	out: STRING
			-- <Precursor>
		do
			Result := attributes_out
		end

	attributes_out: STRING
			-- `attributes_out' for Current {FW_ATTRIBUTE_HELPER}.
			-- General form: Output ::= {Attribute_name "=" Attribute_value Attribute_separator}*
		local
			l_add_quotes: BOOLEAN
			l_value,
			l_default: detachable ANY
		do
			create Result.make_empty
			across
				attribute_list as ic_list
			loop
				l_value := ic_list.item.attr_value
				l_default := ic_list.item.attr_default
				if
					attached l_value as al_value and then
					attached l_default as al_default and then
					not is_value_same_as_default (al_value, al_default)
				then
					l_add_quotes := ic_list.item.is_quoted
					Result.append_string_general (ic_list.item.attr_name)
					Result.append_character ('=')
					if l_add_quotes then Result.append_character ('"') end
					Result.append_string_general (al_value.out)
					if l_add_quotes then Result.append_character ('"') end
					Result.append_string_general (Attribute_separator)
				end
			end
			if Result.count > 0 and then Result [Result.count] = ' ' then
				Result.remove_tail (2)
			end
		end

	attribute_separator: STRING
			-- `attribute_separator' used between `attributes_out'.
		once ("object")
			Result := "; "
		end

feature -- Attributes

	attribute_list: HASH_TABLE [attached like attribute_tuple_anchor, STRING]
			-- `attribute_list'.
		do
			create Result.make (0)
		ensure
			count: Result.count >= 0
			matching: across Result as ic all ic.key.same_string (ic.item.attr_name) end
		end

feature -- Status Report

	attribute_defaults_list (a_attribute_agent: FUNCTION [ANY, TUPLE, attached like attribute_tuple_anchor]): detachable LIST [STRING]
			-- `attribute_defaults_list' (if any) for `a_attribute_agent'.
			-- If `Attribute_defaults' tuple item of `attribute_list' item is a {STRING}, then split it to a list.
		do
			a_attribute_agent.call ([Void])
			check attached a_attribute_agent.last_result as al_result then
				if attached {STRING} al_result [Attribute_defaults] as al_string_defaults_list then
					Result := al_string_defaults_list.split ('|')
				end
			end
		end

	is_value_same_as_default (a_value, a_default: ANY): BOOLEAN
			-- `is_value_same_as_default'?
		note
			design: "[
				The default can be anything (e.g. {ANY}). However, if `a_default' is a {STRING},
				the string may be a pipe-delimited (i.e. "|") list of legal or valid values. If
				this is the case, then the first value is always the default. This can be proven
				by the attr_value = attr_default [1], where attr_default = pipe-delimited string,
				which is then split on the pipe to a {LIST} of strings and the first value selected
				as the default.
				]"
		require
			same_type: a_value.generating_type ~ a_default.generating_type
		do
			if attached {STRING} a_value as al_value and then attached {STRING} a_default as al_default and then attached al_default.split ('|') [1] as al_first_item then
				Result := al_first_item.same_string (al_value)
			else
				Result := a_value.out.same_string (a_default.out)
			end
		end

feature -- Settings

	set_attribute_value (a_attribute_agent: FUNCTION [ANY, TUPLE, attached like attribute_tuple_anchor]; a_value: detachable ANY)
			-- `set_attribute_value' to `a_value' using `a_getter' agent function.
			-- If `a_attribute_agent' has default-values-list, then `a_value' must be on that list.
		do
			a_attribute_agent.call ([Void])
			check attached a_attribute_agent.last_result as al_result then
				check a_value_is_in_defaults_list:
					attached attribute_defaults_list (a_attribute_agent.twin) as al_defaults_list and then
						attached {STRING} a_value as al_value implies
							across al_defaults_list as ic some
									attached {STRING} ic.item as al_item and then al_item.same_string (al_value)
								end
				end
				al_result [Attribute_value] := a_value
				if
					attached {COMPARABLE} al_result [Attribute_value] as al_value and then
					attached {COMPARABLE} al_result [Attribute_minimum] as al_min
				then
					check above_minimum_standard: al_value >= al_min end
				end
			end
		ensure
			set: attached a_attribute_agent.last_result as al_result and then al_result [Attribute_value] ~ a_value
		end

feature {NONE} -- Implementation: Constants

	Attribute_value: INTEGER = 1
	Attribute_defaults: INTEGER = 2
	Attribute_minimum: INTEGER = 3

	is_quoted: BOOLEAN = True

	is_unquoted: BOOLEAN = False

feature {NONE} -- Implementation: Anchors

	attribute_tuple_anchor: detachable TUPLE [attr_value: detachable ANY;
												attr_default: detachable ANY;
												attr_minimum: detachable NUMERIC;
												attr_name: STRING;
												is_quoted: BOOLEAN]

invariant
	match_value_and_default: across attribute_list as ic all
									(attached ic.item.attr_value as al_value and then attached ic.item.attr_default as al_default implies
									al_value.generating_type ~ al_default.generating_type)
								end

;note
	design: "[
		For an attribute of `attribute_list' to be in a "default-state", the attr_value must equal the attr_default.
		If the attr_default is a {STRING}, then it may also be a pipe-delimited string, which means that the default
		value is the first item in the {LIST} when the attr_default is `split' on '|'.
		
		The notion of attr_minimum is for numeric values only. For all other basic or reference types, the attr_minimum
		must be Void.
		
		The attr_name will be the name used when the attributes are generated by the `attributes_out' feature.
		Otherwise, if you are accessing this class looking for an attribute, you may use the feature name of
		the feature found in the class (of course). This means you have two ways for accessing attribute feature
		values--either by direct reference (e.g. Current.my_attribute.attr_value) or by way of `attributes_out',
		or by accessing the `attributes_list' (e.g. Current.attributes_list.item ("my_attribute").attr_value).
		]"
	how_to: "[
		See EIS link to "Attribute Option Design.png"
		]"
	EIS: "src=file://$GITHUB\graphviz\docs\Attribute Option Design.png"
end

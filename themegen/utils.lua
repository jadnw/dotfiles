local _utils = {}

_utils.deepcopy = function(orig, copies)
	copies = copies or {}
	local orig_type = type(orig)
	local copy
	if orig_type == "table" then
		if copies[orig] then
			copy = copies[orig]
		else
			copy = {}
			copies[orig] = copy
			for orig_key, orig_value in next, orig, nil do
				copy[_utils.deepcopy(orig_key, copies)] = _utils.deepcopy(orig_value, copies)
			end
			setmetatable(copy, _utils.deepcopy(getmetatable(orig), copies))
		end
	else -- number, string, boolean, etc
		copy = orig
	end
	return copy
end

_utils.template = function(tpl, sch)
	return (
		tpl:gsub("($%b{})", function(w)
			local k = w:sub(3, -2)
			if k == "theme" then
				return sch.theme or w
			end

			return sch.palette[w:sub(3, -2)] or w
		end)
	)
end

_utils.remove_hashtag_from_schema = function(sch)
  local _sch = _utils.deepcopy(sch)
	local pal = _sch.palette
	for k, v in pairs(pal) do
		if type(v) == "string" then
			pal[k] = v:gsub("^#", "")
		end
	end
	return _sch
end

_utils.cwd = function(file)
	local chr = os.tmpname():sub(1, 1)
	if chr == "/" then
		-- linux
		chr = "/[^/]*$"
	else
		-- windows
		chr = "\\[^\\]*$"
	end
	return arg[0]:sub(1, arg[0]:find(chr)) .. (file or "")
end

return _utils

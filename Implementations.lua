local _ENV = (getgenv or getfenv)()

local Implementations = {}

-- custom tostring to support different constants (will be replaced later on.)
function Implementations.tostring(e)
	if typeof(e) == "userdata" then
		local mt = getmetatable(e)
		if type(mt) == "table" then
			local __type = rawget(mt, "__type")
			local t = type(__type)
			if t == "string" then
				return __type
			elseif t == "function" then
				return __type()
			end
		end
	end

	return tostring(e)
end

-- from number to boolean
function Implementations.toboolean(n)
	return n ~= 0
end

-- an easy way to escape string, most developers better code like this!!!!
function Implementations.toEscapedString(s)
	if type(s) == "string" then
		local hasQuotationMarks = string.find(s, '"') ~= nil
		local hasApostrophes = string.find(s, "'") ~= nil
		if hasQuotationMarks and hasApostrophes then
			return `[[{s}]]`
		elseif hasQuotationMarks and not hasApostrophes then
			return `'{s}'`
		else
			return `"{s}"`
		end
	else
		return Implementations.tostring(s)
	end
end

-- picks indexing method based on characters in a string
function Implementations.formatIndexString(s)
	if type(s) == "string" then
		local validDirectPattern = "^[%a_][%w_]*$"
		if string.find(s, validDirectPattern) then
			return `.{s}`
		end
		return `["{s}"]`
	else
		return tostring(s)
	end
end

-- returns true if passed string is a key pointing to a Roblox global
function Implementations.isGlobal(s)
	return _ENV[s] ~= nil
end

return Implementations

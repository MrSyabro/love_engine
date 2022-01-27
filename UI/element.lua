local new_object = require "love_engine.UI.object"

local function new_element (name, x, y, h, w)
	local element = new_object(name)

	element.__t = "element"
	element.pos = {}
	element.pos.x = x
	element.pos.y = y
	element.size = {}
	element.size.h = h
	element.size.w = w

	return element
end

return new_element

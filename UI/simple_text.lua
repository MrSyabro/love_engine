local new_element = require "love_engine.UI.element"

local function new_simple_text(name, x, y, w, h)
	local obj = new_element(name, x or 0, y or 0, w or 0, h or 0)
	obj.printed_name = name
	function obj:draw()
		love.graphics.print(self.printed_name, self.pos.x, self.pos.y)
	end

	return obj
end

return new_simple_text

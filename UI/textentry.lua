local new_element = require "love_engine.UI.element"

local function new_textentry (name, x, y, w, h)
	local textentry = new_element(name, x or 0, y or 0, w or 40, h or 160)
	textentry.__t = "textentry"
	textentry.textinput = ""
	textentry.color = { 1, 1, 1, 0.8 }
	textentry.color.selected = { 1, 1, 1, 1 }

	function textentry:load()
		objs.mouse:register("pressed", self)
	end

	function textentry:draw()
		if self.selected then
			love.graphics.setColor( self.color.selected )
		else
			love.graphics.setColor( self.color )
		end
		love.graphics.polygon( "line",
			self.pos.x, self.pos.y,
			self.pos.x + self.size.w, self.pos.y,
			self.pos.x + self.size.w, self.pos.y + self.size.h,
			self.pos.x, self.pos.y + self.size.h )
		love.graphics.print(self.textinput, self.pos.x + 10, self.pos.y + 12)
	end

	function textentry:mousepressed (x, y, button, istouch, presses)
		if button == 1 then
			tmp_x = x - self.pos.x
			tmp_y = y - self.pos.y
			if (tmp_x < self.size.w and tmp_x > 0) and (tmp_y < self.size.h and tmp_y > 0) then
				objs:select(self)
				if self.callbacks.mousepressed then
					self.callback.mousepressed(self)
				end
			end
		end
	end

	return textentry
end

return new_textentry

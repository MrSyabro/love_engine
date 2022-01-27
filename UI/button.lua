local new_element = require "love_engine.UI.element"

local function new_button (name, x, y, w, h)
	local button = new_element(name, x or 0, y or 0, w or 40, h or 160)
	button.__t = "button"
	button.printed_name = name
	button.color = {}
	button.color.selected = {}
	button.color.selected.background = { 1, 1, 1, 1 }
	button.color.selected.text = { 0, 0, 0, 1 }
	button.color.background = { 1, 1, 1, 1 }
	button.color.text = { 0, 0, 0, 1 }

	function button:load()
		self.font = love.graphics.getFont()
		self.text = love.graphics.newText(self.font, { self.color.text, self.printed_name })
		objs.mouse:register("pressed", button)
		objs.mouse:register("released", button)
	end

	function button:draw()
		local color = self.color
		if self.selected then
			color = self.color.selected
		end
		love.graphics.setColor( color.background )
		love.graphics.polygon( "fill",
			self.pos.x, self.pos.y,
			self.pos.x + self.size.w, self.pos.y,
			self.pos.x + self.size.w, self.pos.y + self.size.h,
			self.pos.x, self.pos.y + self.size.h )

		love.graphics.draw(self.text, self.pos.x, self.pos.y)
	end

	function button:mousepressed(x, y, button, istouch, presses)
		if button == 1 then
			tmp_x = x - self.pos.x
			tmp_y = y - self.pos.y
			if (tmp_x < self.size.w and tmp_x > 0) and (tmp_y < self.size.h and tmp_y > 0) then
				objs:select(self)
				if self.callbacks.mousepressed then
					self.callbacks.mousepressed(self)
				end
			end
		end
	end

	function button:mousereleased(x, y, button, istouch, presses)
		if button == 1 then
			tmp_x = x - self.pos.x
			tmp_y = y - self.pos.y
			if (tmp_x < self.size.w and tmp_x > 0) and (tmp_y < self.size.h and tmp_y > 0) then
				if self.callbacks.mousereleased then
					self.callbacks.mousereleased(self)
				end
			end
		end
	end

	return button
end

return new_button

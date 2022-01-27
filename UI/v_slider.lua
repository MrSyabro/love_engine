local new_element = require "love_engine.UI.element"

local function new_v_slider(name, x, y, state, w, h)
	local slider = new_element(name, x or 0, y or 0, w or 160, h or 40)
	slider.__t = "v_slider"
	slider.state = {}
	slider.state.current = state or 0
	slider.state.default = state or 0
	slider.size.border = 2
	slider.color = { 1, 1, 1, 0.7 }
	slider.color.border = { 1, 1, 1, 0.8}
	slider.color.selected = { 1, 1, 1, 1 }
	slider.color.selected.border = { 1, 1, 1, 1}

	function slider:load()
		objs.mouse:register("pressed", self)
		objs.mouse:register("released", self)
		objs.mouse:register("moved", self)
	end

	function slider:draw()
		local colors
		if self.selected then
			colors = self.color.selected
		else
			colors = self.color
		end

		love.graphics.setColor( colors.border )
		love.graphics.polygon( "line",
			self.pos.x, self.pos.y,
			self.pos.x + self.size.w, self.pos.y,
			self.pos.x + self.size.w, self.pos.y + self.size.h,
			self.pos.x, self.pos.y + self.size.h
		)

		local q = 1 - self.state.current
		local poly_verts = {
			self.pos.x + self.size.border, self.pos.y + self.size.border + self.size.h * q,
			self.pos.x + self.size.w - self.size.border, self.pos.y  + self.size.border + self.size.h * q,
			self.pos.x + self.size.w - self.size.border, self.pos.y + self.size.h - self.size.border,
			self.pos.x + self.size.border, self.pos.y + self.size.h - self.size.border
		}
		love.graphics.setColor( colors )
		love.graphics.polygon( "fill", poly_verts)
	end

	function slider:mousepressed( x, y, button, istouch, presses )
		if button == 1 or istouch then
			local tmp_x = x - self.pos.x
			local tmp_y = y - self.pos.y
			if (tmp_x < self.size.w and tmp_x > 0) and (tmp_y < self.size.h and tmp_y > 0) then
				objs:select_obj(self)
				self.clicked = true
				if self.callbacks.mousepressed then
					self.callback.mousepressed(self)
				end
				self:change_state(1 - (tmp_y + self.size.border) / self.size.h)
			end
		end
	end

	function slider:mousereleased( x, y, button )
		if self.clicked then
			self.clicked = false
			if self.callbacks.mousereleased then
				self.callbacks.mousereleased(self, button)
			end
		end
	end

	function slider:mousemoved( x, y, dx, dy, istouch )
		if self.clicked then
			tmp_x = x - self.pos.x
			tmp_y = y - self.pos.y
			if self.callbacks.mousemoved then
				self.callback.mousemoved(self)
			end
			if (1 - (tmp_y + self.size.border) / self.size.h) < 0 then
				self:change_state(0)
			elseif (1 - (tmp_y + self.size.border) / self.size.h) > 1 then
				self:change_state(1)
			else
				self:change_state(1 - (tmp_y + self.size.border) / self.size.h)
			end
		end
	end

	function slider:change_state(state)
		if self.state.current ~= state then
			self.state.current = state
			if self.callbacks.statechanged then
				self.callbacks.statechanged(self)
			end
		end
	end

	return slider
end

return new_v_slider

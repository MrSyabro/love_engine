local M = {}

function M.new_button (name, x, y, w, h)
	local button = M.new_element(name, x, y, w or 40, h or 160)
	button.printed_name = name
	button.colors = {}
	button.colors.background = { 1, 1, 1, 1 }
	button.colors.text = { 0, 0, 0, 1 }

	function button:load()
		self.font = love.graphics.getFont()
		self.text = love.graphics.newText(self.font, { self.colors.text, self.printed_name })
		objs.mouse:register("pressed", button)
		objs.mouse:register("released", button)
	end

	function button:draw()
		love.graphics.setColor( self.colors.background )
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
				objs:select_obj(self)
				if self.callbacks.mousepressed then
					self.callback.mousepressed(self)
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

function M.new_textentry (name, x, y, w, h)
	local textentry = M.new_element(name, x, y, w or 40, h or 160)
	textentry.printed_name = name
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
		love.graphics.print(self.printed_name, self.pos.x - 15, self.pos.y + 4)
		love.graphics.print(self.textinput, self.pos.x + 5, self.pos.y + 4)
	end

	function textentry:mousepressed (x, y, button, istouch, presses)
		if button == 1 then
			tmp_x = x - self.pos.x
			tmp_y = y - self.pos.y
			if (tmp_x < self.size.w and tmp_x > 0) and (tmp_y < self.size.h and tmp_y > 0) then
				objs:select_obj(self)
				if self.callbacks.mousepressed then
					self.callback.mousepressed(self)
				end
			end
		end
	end

	return textentry
end

function M.new_vertical_slider(name, x, y, state, w, h)
	local slider = M.new_element(name, x, y, w or 160, h or 40)
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

function M.new_object(name)
	local obj = {}

	obj.name = name
	obj.callbacks = {}

	function obj:set_callback(event, callback)
		table.insert(self.callbacks, event, callback)
	end

	return obj
end

function M.new_element (name, x, y, h, w)
	local element = M.new_object(name)

	element.pos = {}
	element.pos.x = x
	element.pos.y = y
	element.size = {}
	element.size.h = h
	element.size.w = w

	return element
end

function M.toPixels(x, y)
	local nx, ny

	nx = love.graphics.getHeight() / 900 * x
	ny = love.graphics.getWidth() / 1600 * y

	return nx, ny
end

return M

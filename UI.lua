local u = require "love_engine.utils"

local M = {}

function M.new_button (name, x, y, w, h)
	local button = M.new_element(name, x or 0, y or 0, w or 40, h or 160)
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

function M.new_textentry (name, x, y, w, h)
	local textentry = M.new_element(name, x or 0, y or 0, w or 40, h or 160)
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

function M.new_vertical_slider(name, x, y, state, w, h)
	local slider = M.new_element(name, x or 0, y or 0, w or 160, h or 40)
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

function M.new_grid(name, x, y, w, h, column, string)
	local obj = M.new_element(name, x or 0, y or 0, h or 640, w or 640)
	obj.__t = "grid"
	obj.column = column or 3
	obj.string = string or 3
	obj.grid = {}
	obj.grid.n = 0
	for i = 1, obj.column do
		obj.grid[i] = {}
		obj.grid[i].n = 0
	end

	local function update (c, s)
		local co = u.error_handle(obj.grid[c][s], ("element grid[%d][%d]=nil"):format(c, s))
		co.size.h = obj.size.h / obj.string
		co.size.w = obj.size.w / obj.column
		co.pos.x = obj.pos.x + obj.size.w / obj.column * (c - 1)
		co.pos.y = obj.pos.y + obj.size.h / obj.string * (s - 1)
	end

	local function update_all ()
		for c = 1, obj.column do
			for s = 1, obj.string do
				update(c, s)
			end
		end
	end

	function obj:add(child_obj, column, string)
		local c = column
		local s = string
		if self.grid[c][s] == nil then
			self.grid[c][s] = child_obj
			self.grid.n = self.grid.n + 1
			self.grid[c].n = self.grid[c].n + 1
			if self.loaded and not child_obj.loaded then
				self.parent:add(co)
				child_obj.parent = self
			end
			update (c, s)
		end
	end

	function obj:load()
		for c = 1, obj.column do
			for s = 1, obj.string do
				if obj.grid[c][s] ~= nil then
					local co = obj.grid[c][s]
					if not co.loaded then
						self.parent:add(co)
						co.parent = self
					end
					update(c, s)
				end
			end
		end
	end

	return obj
end

function M.new_text(name, x, y, w, h)
	local obj = M.new_element(name, x or 0, y or 0, w or 0, h or 0)
	obj.printed_name = name
	function obj:draw()
		love.graphics.print(self.printed_name, self.pos.x, self.pos.y)
	end

	return obj
end

function M.new_object(name)
	local obj = {}

	obj.__t = "obj"
	obj.name = name
	obj.callbacks = {}

	function obj:set_callback(event, callback)
		table.insert(self.callbacks, event, callback)
	end

	return obj
end

function M.new_element (name, x, y, h, w)
	local element = M.new_object(name)

	element.__t = "element"
	element.pos = {}
	element.pos.x = x
	element.pos.y = y
	element.size = {}
	element.size.h = h
	element.size.w = w

	return element
end

return M

local utf8 = require "utf8"
local u = require "love_engine.utils"
local s = require "love_engine.scene"
local M = {}

M.textinput = ""
M.config = {}
M.config.buffering = false
M.userdata = {}

function M:init(love)
	function love.load() self:load() end
	function love.update(dt) self:update(dt) end
	function love.draw() self:draw() end
	function love.textinput(t) self:textinput(t) end
	function love.keypressed(key, scancode, isrepeat)
		self:keypressed(key, scancode, isrepeat)
	end
	function love.keyreleased(key, scancode)
		self:keyreleased(key, scancode)
	end
	function love.mousemoved( x, y, dx, dy, istouch )
		self:mousemoved( x, y, dx, dy, istouch )
	end
	function love.mousepressed( x, y, button, istouch, presses )
		self:mousepressed( x, y, button, istouch, presses )
	end
	function love.mousereleased( x, y, button, istouch, presses )
		self:mousereleased( x, y, button, istouch, presses )
	end
	function love.wheelmoved( x, y )
		self:wheelmoved( x, y )
	end
	function love.quit()
		-- TODO: нормальное завершение программы
		print("Thanks for playing! Come back soon!")
		--love.thread.getChannel( "app" ):push("stop")
	end
end

function M:load_scene(file_name)
	self.current_scene = null
	collectgarbage("collect")
	local env = _G
	env.objs = s.generate_scene()
	env.engine = M
	env.utils = u
	local scene_func = u.error_handle(love.filesystem.load(file_name))
	scene_func = setfenv(scene_func, env)
	u.pcall(scene_func)
	self.current_scene = env.objs
	self.current_scene:select(self.current_scene[1])
	self:load()
end

function M:load()
	self.graphics_buffer = love.graphics.newCanvas(love.window.getWidth, love.window.getHeight)

	if not self.current_scene.loaded then
		for k, object in ipairs(self.current_scene) do
			if object.load then
				u.pcall(object.load, object)
			end
		end
		self.current_scene.loaded = true
	end
end

function M:update(dt)
	for k, object in ipairs(self.current_scene) do
		if object.update then
			u.pcall(object.update, object, dt)
		end
	end
end

function M:draw()
	if self.config.buffering then
		love.graphics.setCanvas(self.graphics_buffer)
		love.graphics.clear()
	end

	for k, object in ipairs(self.current_scene) do
		if object.draw then
			u.pcall(object.draw, object)
		end
	end

	if self.config.buffering then
		love.graphics.setCanvas()
		love.graphics.draw(self.graphics_buffer)
	end
end

function M:keypressed(key, scancode, isrepeat)
	if key == "backspace" and self.current_scene.selected.textinput then
		-- get the byte offset to the last UTF-8 character in the string.
		local byteoffset = utf8.offset(self.current_scene.selected.textinput, -1)

		if byteoffset then
			-- remove the last UTF-8 character.
			-- string.sub operates on bytes rather than UTF-8 characters, so we couldn't do string.sub(text, 1, -2).
			self.current_scene.selected.textinput = string.sub(self.current_scene.selected.textinput, 1, byteoffset - 1)
		end
	end
	
	for k, obj in ipairs(self.current_scene.keys.pressed) do
		u.pcall(obj.keypressed, obj, scancode, isrepeat)
	end
end

function M:keyreleased(key, scancode)
	for k, obj in ipairs(self.current_scene.keys.released) do
		u.pcall(obj.keyreleased, obj, scancode)
	end
end

function M:mousemoved( x, y, dx, dy, istouch )
	for k, obj in ipairs(self.current_scene.mouse.moved) do
		u.pcall(obj.mousemoved, obj, x, y, dx, dy, istouch)
	end
end

function M:mousepressed( x, y, button, istouch, presses )
	for k, obj in ipairs(self.current_scene.mouse.pressed) do
		u.pcall(obj.mousepressed, obj, x, y, button, istouch, presses)
	end
end

function M:mousereleased( x, y, button, istouch, presses )
	for k, obj in ipairs(self.current_scene.mouse.released) do
		u.pcall(obj.mousereleased, obj, x, y, button, istouch, presses)
	end
end

function M:wheelmoved( x, y )
	for k, obj in ipairs(self.current_scene.mouse.wheel) do
		u.pcall(obj.wheelmoved, obj, x, y)
	end
end

function M:touchmoved( x, y, dx, dy, istouch )
	for k, obj in ipairs(self.current_scene.touch.move) do
		u.pcall(obj.touchmoved, obj, x ,y, dx, dy, istouch)
	end
end

function M:touchpressed( x, y, button, istouch, presses )
	for k, obj in ipairs(self.current_scene.touch.pressed) do
		u.pcall(obj.touchpressed, obj, x, y, button, istouch, presses)
	end
end

function M:touchreleased( x, y, button, istouch, presses )
	for k, obj in ipairs(self.current_scene.touch.released) do
		u.pcall(obj.touchreleased, obj, x, y, button, istouch, presses)
	end
end

function M:textinput(t)
	if self.current_scene.selected.textinput then
		self.current_scene.selected.textinput = self.current_scene.selected.textinput .. t
	end
end


return M

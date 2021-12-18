local M = {}

local scene_functions = {}
function scene_functions.select (self, obj)
	if type(obj) == "string" then
		obj = self.find (obj)
	end
	if self.selected ~= obj then
		if self.selected then
			self.selected.selected = false
		end
		self.selected = obj
		self.selected.selected = true
		print("Select object:" .. obj.name)
	end
end
function scene_functions.find (self, name)
	if type(name) == "table" then
		for k, i in ipairs(self) do
			if name == i then
				return k, i
			end
		end
	elseif type(name) == "string" then
		for k, i in ipairs(self) do
			if i.name == name then
				return k, i
			end
		end
	end
end
function scene_functions.add(self, obj)
	table.insert(self, obj)
	if self.loaded then obj:load() end
end
function scene_functions.remove(self, obj)
	if type(obj) == "number" then
		table.remove(self, obj)
	else
		local k, i = self:find(obj)
		table.remove(self, k)
	end
end
local scene_mt = {__index = scene_functions}

local function register_event (self, event, obj)
	assert(self[event], ("not found callback named '%s'"):format(event))
	table.insert(self[event], obj)
end
local event_mt = {__index = {register = register_event}}


function M.generate_scene()
	local S = setmetatable({}, scene_mt)
	S.keys = setmetatable({}, event_mt)
	S.keys.pressed = {}
	S.keys.released = {}
	S.mouse = setmetatable({}, event_mt)
	S.mouse.pressed = {}
	S.mouse.released = {}
	S.mouse.moved = {}
	S.mouse.wheel = {}
	S.touch = setmetatable({}, event_mt)
	S.touch.pressed = {}
	S.touch.released = {}
	S.touch.moved = {}
	S.userdata = {}
	S.loaded = false
	S.engine = M
	
	return S
end

return M
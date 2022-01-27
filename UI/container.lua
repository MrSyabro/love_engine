local new_element = require "love_engine.UI.element"

local function new_container (name, x, y, h, w)
	local container = new_element(name, x or 0, y or 0, w or 0, h or 0)
	container.__t = "container"
	container.childs = {}

	function container:add(child_obj)
		table.insert(self.childs, child_obj)
		if self.loaded and not child_obj.loaded then
			child_obj.parent = self
			child_obj:load()
		end
	end

	function container:load()
		for k,i in ipairs(self.childs) do
			if not i.loaded then
				i.parent = self
				i:load()
			end
		end
	end

	function container:update(dt)
		for k,i in ipairs(self.childs) do
			i:update()
		end
	end

	function container:remove(obj)
		if type(obj) == "table" then
			for k,i in ipairs(self.childs) do
				if i == obj then
					table.remove(self.childs, k)
					return k
				end
			end
		elseif type(obj) == "number" then
			table.remove(self.childs, obj)
		end
	end

	return container
end

return new_container

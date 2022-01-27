local new_container = require "love_engine.UI.container"

function new_grid(name, x, y, w, h, column, string)
	local grid = new_container(name, x or 0, y or 0, h or 0, w or 0)
	grid.__t = "grid"
	grid.params = {}
	grid.column = column or 3
	grid.string = string or 3
	local _add = grid.add
	local _load = grid.load
	local _remove = grid.remove

	function grid:get_child(column, string)
		for k, i in ipairs(self.childs) do
			if param[k].column == column and param[k].string == string then
				return i
			end
		end
		return false
	end

	function grid:get_param(obj)
		for k,i in ipairs(self.childs) do
			if i == obj then
				return self.params[k]
			end
		end
		return false
	end

	local function update (i)
		local param = grid.params[i]
		local co = grid.childs[i]
		local c,s = param.column, param.string

		co.size.h = grid.size.h / grid.string
		co.size.w = grid.size.w / grid.column
		co.pos.x = grid.pos.x + grid.size.w / grid.column * (c - 1)
		co.pos.y = grid.pos.y + grid.size.h / grid.string * (s - 1)
	end

	local function update_all ()
		for k,i in ipairs(self.childs) do
			update(k)
		end
	end

	function grid:add(child_obj, column, string)
		local param = {}
		param.column = column
		param.string = string
		local i = table.insert (self.params, param)

		_add(child_obj)
		update (i)
	end

	function grid:load()
		update_all()

		_load(self)
	end

	function grid:remove(obj)
		local i = _remove(self)
		if i then
			table.remove(self.params, i)
		else
			table.remove(self.params, obj)
		end
	end

	return grid
end

return new_grid

local function new_object(name)
	local obj = {}

	obj.__t = "obj"
	obj.name = name
	obj.callbacks = {}

	function obj:set_callback(event, callback)
		table.insert(self.callbacks, event, callback)
	end

	return obj
end

return new_object

local m = {}
local w, h = love.window.getMode()
local unpack = unpack or table.unpack

function m.tc(ux, uy, _w, _h)
    w, h = _w or w, _h or h
    return ux * w, uy * h
end
function m.tu(cx, cy, _w, _h)
    w, h = _w or w, _h or h
    return cx / w, cy / h
end

function m.error_handle (...)
	local args = {...}
	if args[1] == false or args[1] == nil then
		local error_mess = args[#args]
		m.error (error_mess)
	else
		--table.remove(args, #args)
		return unpack(args)
	end
end

m.error = function (err)
	io.stderr:write(os.date("[%H:%M] ERROR: ")..err or "".."\n")
end
m.info = function (text)
	io.stdout:write(os.date("[%H:%M] INFO: ")..text or "".."\n")
end
m.pcall = function (...)
	m.error_handle(pcall(...))
end

return m

local m = {}
local w, h = love.window.getMode()

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
		m.error (args[2])
    else return ... end
end

m.error = function (err)
	io.stderr:write(os.date("[%H:%M] ERROR: ")..err.."\n")
end
m.info = function (text)
	io.stdout:write(os.date("[%H:%M] INFO: ")..text.."\n")
end
m.pcall = function (...)
	m.error_handle(pcall(...))
end

return m
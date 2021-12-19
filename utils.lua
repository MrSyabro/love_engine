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

return m
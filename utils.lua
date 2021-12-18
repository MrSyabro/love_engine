local m = {}

function m.tc(ux, uy, w, h)
    return ux * w, uy * h
end
function m.tu(cx, cy, w, h)
    return cx / w, cy / h
end

return m
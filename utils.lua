local m = {}
m.coef = {}
m.coef.w, m.coef.h = love.window.getMode()

function m:tc(ux, uy)
    return ux * self.coef.w, uy * self.coef.h
end
function m:tu(cx, cy)
    return cx / self.coef.w, cy / self.coef.h
end

return m
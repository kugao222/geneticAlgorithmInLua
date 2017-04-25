local t = class("util")

-- 
local math = _G.math

-- 随机数
function t:rand(l,r) -- 整数
	return math.random(l,r)
end

return t
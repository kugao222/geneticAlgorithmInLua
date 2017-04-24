--
require("src/init")

--
local gb = _G.gb
local populationClass = gb.populationClass

--
local function main()
	-- 基因定义(基因长度/bit的类型/适应性)
	local geneBitCount = 2
	local geneBitTypes = {}; for i=1,100 do geneBitTypes[i] = i end
	local function fitnessCaculate(geneBitList) -- 
		local x = geneBitTypes[geneBitList[1]]
		local y = geneBitTypes[geneBitList[2]]
		local v = x+1/(y+1)
		return v
	end

	-- 
	local population = populationClass:create(100, geneBitCount,geneBitTypes,fitnessCaculate)
	for i=1,100 do
		population:epoch()
	end
end
main()
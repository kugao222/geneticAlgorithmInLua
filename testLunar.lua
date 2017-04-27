--
require("src/init")

--
local gb = _G.gb
local populationClass = gb.populationClass

--
local function main()
	-- 基因定义(基因长度/bit的类型/适应性)
	local geneBitCount = 2
	local generateGeneBitFunc = {}; for i=1,100 do generateGeneBitFunc[i] = i end
	local function fitnessMeasurementFunc(geneBitList) -- 
		local x = generateGeneBitFunc[geneBitList[1]]
		local y = generateGeneBitFunc[geneBitList[2]]
		local v = x+1/(y+1)
		return v
	end

	-- 
	local population = populationClass:create(100, geneBitCount,generateGeneBitFunc,fitnessMeasurementFunc)
	for i=1,100 do
		population:epoch()
	end
end
main()
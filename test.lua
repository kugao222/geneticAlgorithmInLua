--
require("src/init")

--
local gb = _G.gb
local populationClass = gb.populationClass
local util = gb.util

--
local function main()
	-- 基因定义 -----------------------------
	-- 1. 基因结构(数值范围)
	local geneBitValueRange = {1,100}
	local function generateGeneBitFunc() -- 基因bit内部是数组
		local t = {util:rand(geneBitValueRange[1],geneBitValueRange[2])}
		return t
	end
	-- 2. 基因变异
	local function mutateGeneBitFunc(t)
		t[1] = util:rand(geneBitValueRange[1],geneBitValueRange[2])
	end
	-- 3. 适应性度量
	local function fitnessMeasurementFunc(geneBitList) -- 
		--dump(geneBitList, "geneBitList--------")
		local a = geneBitList[1]
		local b = geneBitList[2]
		local x = a[1]
		local y = b[1]
		local v = x+1/(y+1)
		return v
	end

	local t = {
		-- 人口
		population = 100,
		-- 基因
		geneBitCount = 2,-- 长度
		generateGeneBitFunc = generateGeneBitFunc,
		mutateGeneBitFunc = mutateGeneBitFunc,
		fitnessMeasurementFunc = fitnessMeasurementFunc,
	}

	-- 
	local population = populationClass:create(t)
	for i=1,100 do
		population:epoch()
	end
end
main()
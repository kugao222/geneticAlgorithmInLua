local t = class("gene")
-- 基因的定义(基因链中存有问题的解，
-- 这个解得好坏用updateFitness()和fitness来衡量和存储)

local gb = _G.gb
local util = gb.util

--
function t:ctor(geneBitCount, types, population) -- length:geneBitCount
	-- 适应性值
	self.fitness = 0

	-- bit类型记录
	--self.geneBitTypes = types -- 

	-- 基因bit链
	local typesCount = #types
	local geneBitList = {}; self.geneBitList = geneBitList
	for i=1,geneBitCount do
		geneBitList[i] = util:rand(1,typesCount) -- 初始化都是随机的.
	end

	-- 群组
	self.population = population
end

-- 更新适应性值
function t:updateFitness() -- func:打分函数
	local func = self.population.fitnessCaculate
	self.fitness = func(self.geneBitList)
end

-- 变异
function t:mutate() -- func:打分函数
	local population = self.population
	local geneBitTypes = population.geneBitTypes
	local fold = 1000
	local mutationRate = math.floor(population.mutationRate*fold+0.00001) 
	local bitTypeCount = #geneBitTypes

	local rn
	local geneBitList = self.geneBitList
	local count = #geneBitList
	local v
	for i=1,count do
		v = geneBitList[i]
		rn = util:rand(1,fold)
		if rn <= mutationRate then
			-- print("----------------- rn == "..rn)
			-- print("----------------- mutationRate == "..mutationRate)
			geneBitList[i] = util:rand(1,bitTypeCount)
		end
	end

end

return t
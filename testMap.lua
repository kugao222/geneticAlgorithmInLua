--
require("src/init")

--
local gb = _G.gb
local populationClass = gb.populationClass
local math = _G.math

-- 地图定义 --
local width = 15
local height = 10
local map = 
{
 {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,},
 {1, 0, 1, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1,},
 {8, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1,},
 {1, 0, 0, 0, 1, 1, 1, 0, 0, 1, 0, 0, 0, 0, 1,},
 {1, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 1, 0, 1,},
 {1, 1, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 1, 0, 1,},
 {1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 1, 1, 0, 1,},
 {1, 0, 1, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 5,},
 {1, 0, 1, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1,},
 {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,},
};

-- 起始位置
local posStart = {x=15,y=8}
local posEnd = {x=1,y=3}

-- 获取下一个点位(pos 重用)
local function getNextPos(pos, dir)-- dir:方向 -- 
	local x = pos.x
	local y = pos.y

	if dir == 1 then
		y = y + 1
	elseif dir == 2 then
		y = y - 1
	elseif dir == 3 then
		x = x - 1
	elseif dir == 4 then
		x = x + 1		
	end
	pos.x = x
	pos.y = y
	return pos
end

-- 位置合法检测
local function isLocationValid(pos)
	local x = pos.x
	local y = pos.y

	local groundRow = map[y]
	if not groundRow then return false end
	
	local xx = groundRow[x]
	if not xx then return false end
	return  xx < 1
end

--
local function main()
	-- 群组个数
	local populationSize = 150

	-- 基因定义(基因长度/bit的类型/适应性)
	local geneBitCount = 70
	local geneBitTypes = {1,2,3,4} -- 上下左右
	local function fitnessCaculate(geneBitList) -- geneBitList:70
		local curPos = {x=posStart.x, y=posStart.y}
		local farestPos = {x=posStart.x, y=posStart.y} -- 记录最远的点
		local v
		for i=1,geneBitCount do
			v = geneBitList[i]

			curPos = getNextPos(curPos, v)
			--dump(curPos)

			if curPos.x == posEnd.x and curPos.y == posEnd.y then
				farestPos.x = curPos.x
				farestPos.y = curPos.y
				break
			end

			if not isLocationValid(curPos) then
				break
			end
			-- 合法的则往前走
			farestPos.x = curPos.x
			farestPos.y = curPos.y
		end

		local dx = math.abs(farestPos.x-posEnd.x)
		local dy = math.abs(farestPos.y-posEnd.y)
		--print("dx == "..dx)
		--print("dy == "..dy)
		if dx == 0 and dy == 0 then
			dump(geneBitList, "-----geneBitList")
		end
		return 1/(dx+dy+1)
	end

	-- 跳出条件
	local jumpOutFitnessLevel = 1.0

	-- 
	local population = populationClass:create(populationSize, geneBitCount,geneBitTypes,fitnessCaculate)

	--
	local r = false
	for i=1,10000 do
		r = population:epoch(jumpOutFitnessLevel)
		if r then return end
	end
end
main()
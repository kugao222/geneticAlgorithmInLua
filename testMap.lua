--
require("src/init")

--
local gb = _G.gb
local populationClass = gb.populationClass
local math = _G.math
local util = gb.util

-- 地图定义 --
-- local width = 15
-- local height = 10
local map = {
 {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,},
 {1, 0, 1, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1,},
 {0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1,},
 {1, 0, 0, 0, 1, 1, 1, 0, 0, 1, 0, 0, 0, 0, 1,},
 {1, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 1, 0, 1,},
 {1, 1, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 1, 0, 1,},
 {1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 1, 1, 0, 1,},
 {1, 0, 1, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0,},
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

-- setColor
local function setColor(pos, newMap)
	local x = pos.x
	local y = pos.y

	local groundRow = newMap[y]
	if not groundRow then return false end
	
	local xx = groundRow[x]
	if not xx then return false end
	groundRow[x] = '^'
end

-- color path
local function colorPath(list, newMap)
	local curPos = {x=posStart.x, y=posStart.y}
	local farestPos = {x=posStart.x, y=posStart.y}
	for i,v in ipairs(list) do
		curPos = getNextPos(curPos, v[1])
		if isLocationValid(curPos) then
			farestPos.x = curPos.x
			farestPos.y = curPos.y
			setColor(farestPos, newMap)
		else
			curPos.x = farestPos.x-- 不合法则等于碰壁
			curPos.y = farestPos.y
		end
	end
end

--
local function main()
	-- 基因定义(基因长度/bit的类型/适应性)
	local geneBitValueRange = {1,2,3,4} -- 上下左右
	local function generateGeneBitFunc() -- 基因bit内部是数组
		local t = {util:rand(geneBitValueRange[1],geneBitValueRange[4])}
		return t
	end
	-- 2. 基因变异
	local function mutateGeneBitFunc(t)
		t[1] = util:rand(geneBitValueRange[1],geneBitValueRange[4])
	end
	-- 3. 适应性度量
	local function fitnessMeasurementFunc(geneBitList) -- geneBitList:70
		local curPos = {x=posStart.x, y=posStart.y}
		local farestPos = {x=posStart.x, y=posStart.y} -- 记录最远的点
		local v
		for i=1,#geneBitList do
			v = geneBitList[i][1]

			curPos = getNextPos(curPos, v)
			--dump(curPos)

			if curPos.x == posEnd.x and curPos.y == posEnd.y then
				farestPos.x = curPos.x
				farestPos.y = curPos.y
				break
			end

			if isLocationValid(curPos) then
				-- 合法的则往前走
				farestPos.x = curPos.x
				farestPos.y = curPos.y
			else
				curPos.x = farestPos.x-- 不合法则等于碰壁
				curPos.y = farestPos.y
			end
		end

		local dx = math.abs(farestPos.x-posEnd.x)
		local dy = math.abs(farestPos.y-posEnd.y)
		if dx == 0 and dy == 0 then
			local newMap = clone(map)
			colorPath(geneBitList, newMap)
			--dump(map, "-----map")
			for i,v in ipairs(newMap) do
				local line = ""
				for j,vv in ipairs(v) do
					line = line .." "..vv
				end
				print(line)
			end
			print("------------------------------")
		end
		return 1/(dx+dy+1)
	end

	local t = {
		-- 人口
		population = 140,
		-- 基因
		geneBitCount = 35,-- 长度
		generateGeneBitFunc = generateGeneBitFunc,
		mutateGeneBitFunc = mutateGeneBitFunc,
		fitnessMeasurementFunc = fitnessMeasurementFunc,
	}

	-- 
	local population = populationClass:create(t)

	-- 跳出条件
	local jumpOutFitnessLevel = 1.0	
	local r = false
	for i=1,500 do
		r = population:epoch(jumpOutFitnessLevel)
		if r then return end
	end
end
main()
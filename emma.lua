-- os.loadAPI("./git/turtleUtils.lua")



-- -- TURN DIRECTIONS
-- local NONE = 0
-- local RIGHT = 1
-- local LEFT = 2
-- local END_LEVEL = 3

-- -- SLOTS 
-- local FUEL_SLOT = 1
-- local RESERVED_MYSTERY_SLOTS = 2
-- local FREE_SLOTS = 5

-- local XPos = 0
-- local ZPos = 0
-- local YPos = 0 
-- local FacingDirection = NORTH
-- local level_progress = 0


-- local function Dig()
--     local Success, FailedReason = turtle.dig()
--     if not Success then
--         print("Failed to dig block ahead: ", FailedReason)
--     end
-- end


-- local function MoveFowrard()
--     if turtle.detect() then 
--         if not Dig() then return false end
--         return MoveFowrard()
--     else
--        local Success, FailedReason = turtle.forward()
--        if not Success then
--             print("Failed to move forward: ", FailedReason)
--             return false
--        end
--        level_progress = level_progress + 1
--        XPos = XPos + MOVE_INCREMENTS[FacingDirection+1][1]
--        ZPos = ZPos + MOVE_INCREMENTS[FacingDirection+1][2]
--        return true
--     end
-- end

-- ((Ypos - 1) / (Y - 1)) * 2 - 1

-- local function TurnInDirection(TurnDirection) 
--     local Success = false

--     if TurnDirection == RIGHT then
--         Success = turtle.turnRight()        
--     elseif TurnDirection == LEFT then
--         Success = turtle.turnLeft()
--     elseif TurnDirection == NONE then
--         return true
--     elseif TurnDirection == END_LEVEL then
--         return false
--     else
--         print("Invalid turn direction: ", TurnDirection)
--     end

--     if not Success then
--         print("Failed to turn")
--         return false
--     end

--     if TurnDirection == RIGHT then
--         FacingDirection = (FacingDirection + 1) % 4
--     else
--         FacingDirection = (FacingDirection - 1) % 4
--     end

--     return true
-- end

-- local function TurnAround(TurnDirection)
--     if not TurnInDirection(TurnDirection) then return false end
--     if not MoveFowrard() then return false end
--     if not TurnInDirection(TurnDirection) then return false end
--     return true
-- end

-- local function GoDown()
--     if(YPos >= MineY) then return false end

--     if turtle.detectDown() then
--         turtle.digDown()
--     end

--     local Success, FailedReason = turtle.down()

--     if not Success then
--          print("Failed to move down: ", FailedReason)
--          return false
--     end

--     level_progress = 1
--     YPos = YPos + 1

--     return true
-- end

-- local function HandleFailedAction()
--    -- for now handle only case when out of fuel 
--    if turtle.getFuelLevel() == 0 then
--         print("Out of fuel, starting refuel")
--         local RefuelSucceeded = turtleUtils.Refuel()
--         return RefuelSucceeded
--    else
--         print("Unexpected fail :/")
--         return false
--    end
-- end

-- local function RunAction(fn)
--     if not fn() then
--         local Success = HandleFailedAction()
--         return Success
--     end
--     return true
-- end

-- local function GetNextAction()
--     if level_progress == MineX * MineZ then
--         return GoDown
--     end

--     if XPos >= MineX and FacingDirection == NORTH and levelIsEven then
--         return function () return TurnAround(RIGHT) end
--     elseif XPos <= 0 and FacingDirection == SOUTH and levelIsEven then
--         return function () return TurnAround(LEFT) end
--     elseif XPos >= MineX and FacingDirection == SOUTH and not levelIsEven then
--         return function () return TurnAround(LEFT) end
--     elseif XPos <= 0 and FacingDirection == NORTH and not levelIsEven then
--         return function () return TurnAround(RIGHT) end
--     end

--     return MoveFowrard
-- end

-- local function Main()
--     while true do
--         local nextAction = GetNextAction()
--         if not RunAction(nextAction) then break end
--     end
-- end

-- Main()

-- ROTATION DIRECTIONS
local NORTH = 0
local EAST = 1
local SOUTH = 2
local WEST = 3

-- TURNING DIRECTIONS
local RIGHT = 1
local LEFT = -1


local MOVE_INCREMENTS = {
    {0, 1},
    {1, 0},
    {0, -1},
    {-1, 0}
}

local arg1, arg2, arg3 = ...
local MineX, MineZ, MineY = tonumber(arg1), tonumber(arg2), tonumber(arg3)


function Sweep(x, y, z)
    local xPos, yPos, zPos = 0, 0, 0
    local facingDirection = NORTH

    local stepCount = 0
    

    function moveForward()
        turtle.forward()

        stepCount = stepCount + 1 
        xPos = xPos + MOVE_INCREMENTS[facingDirection+1][1]
        zPos = zPos + MOVE_INCREMENTS[facingDirection+1][2]
        
        print(xPos, zPos, yPos)
    end

    function turn(turnDirection)
        if(turnDirection == LEFT) then
            turtle.turnLeft()
        else
            turtle.turnRight()
        end

        if TurnDirection == RIGHT then
            facingDirection = (facingDirection + 1) % 4
        else
            facingDirection = (facingDirection - 1) % 4
        end
    end

    function walkLine(count)
        for i = 1, count, 1 do
            moveForward()
        end
    end

    function turnAround(turnDirection)
        turn(turnDirection)

        moveForward()

        turn(turnDirection)

    end

    function walkPlane(x, z)
        for i = 1, x, 1 do
            walkLine(z)
            if i ~= x then
                if x % 2 == 0 then
                    turnAround(RIGHT)
                else
                    turnAround(LEFT)
                end
            end
        end

        turn(LEFT)
        turn(LEFT)
    end

    walkPlane(x, z)
    
end

Sweep(MineX, MineY, MineZ)
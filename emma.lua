os.loadAPI("./git/turtleUtils.lua")

-- ROTATION DIRECTIONS
local NORTH = 0
local EAST = 1
local SOUTH = 2
local WEST = 3

local MOVE_INCREMENTS = {
    {1, 0},
    {0, 1},
    {-1, 0},
    {0, -1}
}

-- TURN DIRECTIONS
local NONE = 0
local RIGHT = 1
local LEFT = 2
local END_LEVEL = 3

-- SLOTS 
local FUEL_SLOT = 1
local RESERVED_MYSTERY_SLOTS = 2
local FREE_SLOTS = 5

local XPos = 0
local ZPos = 0
local YPos = 0 
local FacingDirection = NORTH
local level_progress = 0

local arg1, arg2, arg3 = ...
local MineX, MineZ, MineY = tonumber(arg1), tonumber(arg2), tonumber(arg3)


local function Dig()
    local Success, FailedReason = turtle.dig()
    if not Success then
        print("Failed to dig block ahead: ", FailedReason)
    end
end


local function MoveFowrard()
    if turtle.detect() then 
        if not Dig() then return false end
        return MoveFowrard()
    else
       local Success, FailedReason = turtle.forward()
       if not Success then
            print("Failed to move forward: ", FailedReason)
            return false
       end
       level_progress = level_progress + 1
       XPos = XPos + MOVE_INCREMENTS[FacingDirection+1][1]
       ZPos = ZPos + MOVE_INCREMENTS[FacingDirection+1][2]
       return true
    end
end

local function TurnInDirection(TurnDirection) 
    local Success = false

    if TurnDirection == RIGHT then
        Success = turtle.turnRight()        
    elseif TurnDirection == LEFT then
        Success = turtle.turnLeft()
    elseif TurnDirection == NONE then
        return true
    elseif TurnDirection == END_LEVEL then
        return false
    else
        print("Invalid turn direction: ", TurnDirection)
    end

    if not Success then
        print("Failed to turn")
        return false
    end

    if TurnDirection == RIGHT then
        FacingDirection = (FacingDirection + 1) % 4
    else
        FacingDirection = (FacingDirection - 1) % 4
    end

    return true
end

local function TurnAround(TurnDirection)
    if not TurnInDirection(TurnDirection) then return false end
    if not MoveFowrard() then return false end
    if not TurnInDirection(TurnDirection) then return false end
    return true
end

local function GoDown()
    if(YPos >= MineY) then return false end

    if turtle.detectDown() then
        turtle.digDown()
    end

    local Success, FailedReason = turtle.down()

    if not Success then
         print("Failed to move down: ", FailedReason)
         return false
    end

    level_progress = 1
    YPos = YPos + 1

    return true
end

local function HandleFailedAction()
   -- for now handle only case when out of fuel 
   if turtle.getFuelLevel() == 0 then
        print("Out of fuel, starting refuel")
        local RefuelSucceeded = turtleUtils.Refuel()
        return RefuelSucceeded
   else
        print("Unexpected fail :/")
        return false
   end
end

local function RunAction(fn)
    if not fn() then
        local Success = HandleFailedAction()
        return Success
    end
    return true
end

local function GetNextAction()
    if level_progress == MineX * MineZ then
        return GoDown
    end

    if level_progress % MineX == 0 then
        local levelIsEven = YPos % 2 == 0
        local turnDirection = NONE
        
        if FacingDirection == NORTH and levelIsEven then
            turnDirection = RIGHT
        elseif FacingDirection == SOUTH and levelIsEven then
            turnDirection = LEFT
        elseif FacingDirection == NORTH and not levelIsEven then
            turnDirection = LEFT
        elseif FacingDirection == SOUTH and not levelIsEven then
            turnDirection = RIGHT
        else
            return function ()
                print("This should never happen")
                return false    
            end
        end
           
        return function () return TurnAround(turnDirection) end
    end

    return MoveFowrard
end

local function Main()
    local EndProgram = false

    while not EndProgram do
        local nextAction = GetNextAction()
        if not RunAction(nextAction) then break end
    end
end

Main()

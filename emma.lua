os.loadAPI("turtleUtils")

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

local arg1, arg2, arg3 = ...
local MineX, MineZ, MineY = tonumber(arg1), tonumber(arg2)

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

       XPos = XPos + MOVE_INCREMENTS[FacingDirection+1][1]
       ZPos = ZPos + MOVE_INCREMENTS[FacingDirection+1][2]
       return true
    end
end

local function GetTurnDirection()
    if(ZPos >= MineZ - 1 and XPos % MineX == 0) then
        return END_LEVEL
    elseif(XPos >= MineX and FacingDirection == NORTH) then
       return RIGHT
    elseif(XPos <= 0 and FacingDirection == SOUTH) then
        return LEFT        
    else
        return NONE
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

local function Main()
    local EndProgram = false

    while not EndProgram do
        local TurnDirection = GetTurnDirection()
        if TurnDirection == END_LEVEL then
            if not RunAction(GoDown) then break end
        elseif TurnDirection ~= NONE then
           local Success = RunAction(function() return TurnAround(TurnDirection) end)
           if not Success then break end
        end
        if not RunAction(MoveFowrard) then break end
    end
end

Main()

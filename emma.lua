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
local END_WALK = 3

-- SLOTS 
local FUEL_SLOT = 0
local RESERVED_MYSTERY_SLOTS = 1
local FREE_SLOTS = 5

local XPos = 0
local YPos = 0 
local FacingDirection = NORTH

local FlattenX = 16
local FlattenY = 16


local function Dig()
    print("Dig")
    local Success, FailedReason = turtle.dig()
    if not Success then
        print("Failed to dig block ahead: ", FailedReason);
    end
    return Success;
end

local function MoveFowrard()
    print("MoveFowrard")
    if turtle.detect() then 
        return Dig();
    else
       local Success, FailedReason = turtle.forward()
       if not Success then
            print("Failed to move forward: ", FailedReason)
            return false;
       end

       XPos = XPos + MOVE_INCREMENTS[FacingDirection+1][1]
       YPos = YPos + MOVE_INCREMENTS[FacingDirection+1][2]
       return true;
    end
end

local function GetTurnDirection()
    print("GetTurnDirection")
    if(YPos == FlattenY and XPos % FlattenX == 0) then
        return END_WALK
    else if(XPos == FlattenX and FacingDirection == NORTH) then
       return RIGHT;
    elseif(XPos == 0 and FacingDirection == SOUTH) then
        return LEFT;        
    else
        return NONE;
    end
end

local function TurnInDirection(TurnDirection) 
    print("TurnInDirection")
    local Success = false

    if TurnDirection == RIGHT then
        Success = turtle.turnRight()        
    elseif TurnDirection == LEFT then
        Success = turtle.turnLeft()
    elseif TurnDirection == NONE then
        Success = true
    else
        print("Invalid turn direction: ", TurnDirection)
    end

    if not Success then
        print("Failed to turn")
        return false;
    end

    if TurnDirection == RIGHT then
        FacingDirection = (FacingDirection + 1) % 4
    else
        FacingDirection = (FacingDirection - 1) % 4
    end

    return true;
end

local function TurnAround(TurnDirection)
    print("TurnAround")
    if not TurnInDirection(TurnDirection) then return false; end
    if not MoveFowrard() then return false end
    if not TurnInDirection(TurnDirection) then return false; end
    return true
end

local function Refuel()
    print("Refuel")

    turtle.select(FUEL_SLOT)

    local Success = turtle.refuel();
    if not Success then
        print("Failed to refuel")
    end

    turtle.select(FREE_SLOTS)

    return Success
end

local function HandleFailedAction()
    print("HandleFailedAction")
   -- for now handle only case when out of fuel 
   if turtle.getFuelLevel() == 0 then
        print("Out of fuel, starting refuel")
        local RefuelSucceeded = Refuel();
        return RefuelSucceeded
   else
        print("Unexpected fail :/")
        return false
   end
end

local function RunAction(fn)
    print("RunAction")
    if not fn() then
        local Success = HandleFailedAction()
        return Success
    end
    return true
end

local function Main()
    local EndProgram = false

    while not EndProgram do
        local TurnDirection = GetTurnDirection();
        if TurnDirection ~= NONE then
           local Success = RunAction(function() return TurnAround(TurnDirection) end)
           if not Success then break end
        end
        if not RunAction(MoveFowrard) then break end
    end
end

Main()
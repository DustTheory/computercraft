XPos = 0
YPos = 0 

FlattenX = 16
FlattenY = 16

   
-- TURN DIRECTIONS
NONE = 0
RIGHT = 1
LEFT = -1

-- SLOTS 
FUEL_SLOT = 0
RESERVED_MYSTERY_SLOTS = 1
FREE_SLOTS = 5

local function Dig()
    local Success, FailedReason = turtle.dig()
    if not Success then
        print("Failed to dig block ahead: ", FailedReason);
    end
    return Success;
end

local function MoveFowrard()
    if turtle.detect() then 
        return Dig();
    else
       local Success, FailedReason = turtle.forward()
       if not Success then
            print("Failed to move forward: ", FailedReason)
       end
    end
end

local function GetTurnDirection()
    if(XPos == FlattenX) then
       return RIGHT;
    elseif(XPos == 0) then
        return LEFT;
    else
        return NONE;
    end
end

local function TurnInDirection(turnDirection) 
    local Success, FailedReason

    if turnDirection == RIGHT then
        Success, FailedReason = turtle.turnRight()
    elseif Success == LEFT then
        Failed, FailedReason = turtle.turnLeft()
    end

    if not Success then
        print("Failed to turn: ", FailedReason)
    end

    return Success;
end

local function TurnAround(turnDirection)
    if not TurnInDirection(turnDirection) then return false; end
    if not MoveFowrard() then return false end
    if not TurnInDirection(turnDirection) then return false; end
end

local function Refuel()
    turtle.select(FUEL_SLOT)

    local Success, FailedReason = turtle.refuel();
    if not Success then
        print("Failed to refuel:", FailedReason)
    end

    turtle.select(FREE_SLOTS)

    return Success
end

local function HandleFailedAction()
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
    if not fn() then
        local Success = HandleFailedAction()
        return Success
    end
    return true
end

local function Main()
    while true do
        local TurnDirection = GetTurnDirection();
        if TurnDirection ~= NONE then
           RunAction(TurnAround)
        end
        RunAction(MoveFowrard)
    end
end


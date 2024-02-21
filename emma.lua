-- ROTATION DIRECTIONS
NORTH = 0
EAST = 1
SOUTH = 2
WEST = 3

local MOVE_INCREMENTS = {
    {1, 0},
    {0, 1},
    {-1, 0},
    {0, -1}
}

   
-- TURN DIRECTIONS
NONE = 0
RIGHT = 1
LEFT = 2
END_WALK = 3

-- SLOTS 
FUEL_SLOT = 0
RESERVED_MYSTERY_SLOTS = 1
FREE_SLOTS = 5

XPos = 0
YPos = 0 
FacingDirection = NORTH

FlattenX = 16
FlattenY = 16


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
            return false;
       end

       XPos = XPos + MOVE_INCREMENTS[FacingDirection][0]
       YPos = YPos + MOVE_INCREMENTS[FacingDirection][1]
       return true;
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
    local Success

    if turnDirection == RIGHT then
        Success = turtle.turnRight()        
    elseif Success == LEFT then
        Success = turtle.turnLeft()
    end

    if not Success then
        print("Failed to turn")
        return false;
    end

    if turnDirection == RIGHT then
        FacingDirection = (FacingDirection + 1) % 4
    else
        FacingDirection = (FacingDirection - 1) % 4
    end


    return true;
end

local function TurnAround(turnDirection)
    if not TurnInDirection(turnDirection) then return false; end
    if not MoveFowrard() then return false end
    if not TurnInDirection(turnDirection) then return false; end
end

local function Refuel()
    turtle.select(FUEL_SLOT)

    local Success = turtle.refuel();
    if not Success then
        print("Failed to refuel")
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

Main();
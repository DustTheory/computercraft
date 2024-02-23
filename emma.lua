os.loadAPI("./git/turtleUtils.lua")

-- ROTATION DIRECTIONS
local NORTH = 0
local EAST = 1
local SOUTH = 2
local WEST = 3

-- TURNING DIRECTIONS
local RIGHT = 1
local LEFT = -1

-- VERTICAL DIRECTIONS
local UP = 1
local DOWN = -1

local MOVE_INCREMENTS = {
    {0, 1},
    {1, 0},
    {0, -1},
    {-1, 0}
}

local xPos, yPos, zPos = 0, 0, 0
local facingDirection = NORTH


function moveForward(beforeHorizontalAction, afterHorizontalAction)    
    turtlUtils.safeCall(beforeHorizontalAction)

    if not turtle.forward() then
       turtleUtils.Refuel() 
    end
    

    xPos = xPos + MOVE_INCREMENTS[facingDirection+1][1]
    zPos = zPos + MOVE_INCREMENTS[facingDirection+1][2]
    
    turtlUtils.safeCall(afterHorizontalAction)
end

function moveVertical(direction, beforeVerticalAction, afterVerticalAction)
    turtlUtils.safeCall(function () beforeVerticalAction(direction) end)
    
    if(direction == UP) then
        if not turtle.up() then turtleUtils.Refuel() end
    else
        if not turtle.down() then turtleUtils.Refuel() end
    end
    yPos = yPos + direction

    turtlUtils.safeCall(function () afterVerticalAction(direction) end)

end

function turn(turnDirection)
    if(turnDirection == LEFT) then
        turtle.turnLeft()
    else
        turtle.turnRight()
    end


    if turnDirection == RIGHT then
        facingDirection = (facingDirection + 1) % 4
    else
        facingDirection = (facingDirection - 1) % 4
    end

end


function turnAround(turnDirection, beforeHorizontalAction, afterHorizontalAction)
    turn(turnDirection)
    moveForward(beforeHorizontalAction, afterHorizontalAction)
    turn(turnDirection)
end

function invertTurnDirection(turnDirection)
    return turnDirection * -1
end


function sweepPlane(x, z, beforeHorizontalAction, afterHorizontalAction)
    for i = 1, x, 1 do
        for j = 1, z-1, 1 do
            moveForward(beforeHorizontalAction, afterHorizontalAction)
        end
        if i ~= x then
            local turnDirection = RIGHT
            if i % 2 == 0 then turnDirection = invertTurnDirection(turnDirection) end
            
            turnAround(turnDirection, beforeHorizontalAction, afterHorizontalAction)
        end
    end

    turn(LEFT)
    turn(LEFT)
end

function Sweep(x, y, z, verticalDirection, beforeHorizontalAction, afterHorizontalAction, beforeVerticalAction, afterVerticalAction)    
    for i = 1, y, 1 do
        sweepPlane(x, z, beforeHorizontalAction, afterHorizontalAction)
        if i ~= y then
           moveVertical(verticalDirection,  beforeVerticalAction, afterVerticalAction)
        end
    end
    
end

local arg1, arg2, arg3, arg4 = ...
local mineX, mineZ, mineY, verticalDir = tonumber(arg1), tonumber(arg2), tonumber(arg3), tonumber(arg4)

Sweep(
    mineX,
    mineY,
    mineZ,
    verticalDir,
    function ()
        if turtle.detect() then
            turtle.dig()
        end
    end,
    nil,
    function (direction)
        if(direction == UP) then
            if turtle.detectUp() then
                turtle.digUp()
            end
        else
            if turtle.detectDown() then
                turtle.digDown()
            end 
        end
        
    end,
    nil
)
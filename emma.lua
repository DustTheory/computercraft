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


function moveForward()
    if turtle.detect() then
        turtle.dig()
    end
    
    turtle.forward()

    xPos = xPos + MOVE_INCREMENTS[facingDirection+1][1]
    zPos = zPos + MOVE_INCREMENTS[facingDirection+1][2]
    
    print(xPos, zPos, yPos)
end

function moveVertical(direction)
    if(direction == UP) then
        if turtle.detectUp() then
            turtle.digUp()
        end
        turtle.up()
        yPos = yPos + 1
    else
        if turtle.detectDown() then
            turtle.digDown()
        end
        turtle.down()
        yPos = yPos - 1 
    end

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


function turnAround(turnDirection)
    turn(turnDirection)
    moveForward()
    turn(turnDirection)
end

function invertTurnDirection(turnDirection)
    return turnDirection * -1
end

function sweepLine(count)
    for i = 1, count, 1 do
        moveForward()
    end
end

function sweepPlane(x, z)
    for i = 1, x, 1 do
        sweepLine(z)
        if i ~= x then
            local turnDirection = RIGHT
            if i % 2 == 0 then turnDirection = invertTurnDirection(turnDirection) end
            if yPos % 2 == 1 then turnDirection = invertTurnDirection(turnDirection) end
            
            turnAround(turnDirection)
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

Sweep(mineX, mineY, mineZ, verticalDir)
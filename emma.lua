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

local xPos, yPos, zPos = 0, 0, 0
local facingDirection = NORTH

function moveForward()
    turtle.forward()

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
    while xPos < x do
        walkLine(z)
        if xPos ~= x then
            local turnDirection = RIGHT
            if xPos % 2 == 1 then turnDirection = invertTurnDirection(turnDirection) end
            if yPos % 2 == 1 then turnDirection = invertTurnDirection(turnDirection) end
            
            turnAround(turnDirection)
        end
    end

    turn(LEFT)
    turn(LEFT)
end

function Sweep(x, y, z)    
    while yPos < y do
        walkPlane(x, z)
        if yPos ~= y then
            turtle.up()
            yPos = yPos + 1
        end
    end
    
end

local arg1, arg2, arg3 = ...
local MineX, MineZ, MineY = tonumber(arg1), tonumber(arg2), tonumber(arg3)

Sweep(MineX, MineY, MineZ)
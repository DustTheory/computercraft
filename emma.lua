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

    function invertTurnDirection(turnDirection)
        return turnDirection * -1
    end

    function walkPlane(x, z)
        for i = 1, x, 1 do
            walkLine(z)
            if i ~= x then
                local turnDirection = RIGHT
                if i % 2 then turnDirection = invertTurnDirection(turnDirection) end
                if yPos % 2 then turnDirection = invertTurnDirection(turnDirection) end
                
                turnAround(turnDirection)
            end
        end

        turn(LEFT)
        turn(LEFT)
    end

    for i = 1, y, 1 do
        walkPlane(x, z)
        if i ~= y then
            turtle.up()
        end
    end
    
end

local arg1, arg2, arg3 = ...
local MineX, MineZ, MineY = tonumber(arg1), tonumber(arg2), tonumber(arg3)

Sweep(MineX, MineY, MineZ)
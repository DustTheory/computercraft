-- VERSION 1.0.1

FUEL_SLOT = 1

CLOCKWISE = 1
COUNTER_CLOCKWISE = -1

UP = 1
DOWN = -1

local Xpos, Ypos, Zpos = 0, 0, 0

---@return boolean
---@param FuelBuffer number|nil
function Refuel(FuelBuffer)

    FuelBuffer = FuelBuffer or 0

    if turtle.getFuelLevel() > FuelBuffer then
        return true
    end

    local SelectedSlot = turtle.getSelectedSlot()

    turtle.select(FUEL_SLOT)

    local Success = turtle.refuel()
    
    if not Success then
        print("Failed to refuel")
    end

    turtle.select(SelectedSlot)

    return Success
end

local function Turn(steps, direction)
    for i = 1, steps, 1 do
        if direction == CLOCKWISE then
            turtle.turnRight()
        elseif direction == COUNTER_CLOCKWISE then
            turtle.turnLeft()
        end

    end
end

local function MoveVertical(direction)
    if direction == UP then
        turtle.up()
        return true
    elseif direction == DOWN then
        turtle.down()
        return true
    else
        return false
    end
end

---@return boolean
---@param func function
function safeCall(func)
    if func ~= nil then
        func()
    end
end

---@return boolean
---@param x number
---@param y number
---@param z number
---@param verticalDirection number
---@param beforeHorizontalAction function
---@param afterHorizontalAction function
---@param beforeVerticalAction function
---@param afterVerticalAction function
function Sweep(x, y, z, verticalDirection, beforeHorizontalAction, afterHorizontalAction, beforeVerticalAction, afterVerticalAction)
    local stepCount = 0
    -- exit condition => x * y * z
    while true do
        -- The turning calculation mwhehehe
        if Zpos == 0 and Xpos == 0 and Ypos == 0 then
            -- do nuffin
        elseif (stepCount + 1) % (x * z) == 0 then
            Turn(2, CLOCKWISE)
        elseif Zpos == z - 1 or Zpos == 0 then
            -- DO FUNNY FORMULA
            -- funny formula step 1: (Zpos - 1) / (z - 1) * 2 - 1
            -- step 2: * (Xpos - 1) % 2 * 2 - 1
            -- step 3: * (Ypos - 1) % 2 * 2 - 1
            Turn(1, (Zpos / (z - 1) * 2 - 1) * (Xpos % 2 * 2 - 1) * (Ypos % 2 * 2 - 1))
        end

        if (stepCount + 1) % (x * z) == 0 then
            safeCall(beforeVerticalAction)
            if MoveVertical(verticalDirection) then
                Ypos = (stepCount + 1) % (x * z)
                stepCount = stepCount + 1
            else
                break    
            end
            safeCall(afterVerticalAction)
            sleep(1/20)
        end

        safeCall(beforeHorizontalAction)
        if turtle.forward() then
            stepCount = stepCount + 1
            local layerMatriXpos = stepCount % (x * z)
            Xpos = (math.floor((layerMatriXpos / x)) * ((Ypos + 1) % 2 * 2 - 1)) + ((x * z) * (Ypos % 2))
            Zpos = ((layerMatriXpos % x) * ((Ypos + 1) % 2 * 2 - 1)) + ((x * z) * (Ypos % 2))
        else
            break    
        end
        safeCall(afterHorizontalAction)

        if stepCount + 1 >= x * y * z then
            break
        end

    end
end

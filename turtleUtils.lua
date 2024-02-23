local FUEL_SLOT = 1

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
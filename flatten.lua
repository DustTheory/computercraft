local function checkFuelLevel()
    local fuelLevel = turtle.getFuelLevel();
    print("Fuel level is: " + fuelLevel.tostring())
end

checkFuelLevel();


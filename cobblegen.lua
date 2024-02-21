os.loadAPI("turtleUtils.lua")

local CanDrop = true

local function Main()
    while true do
        turtle.select(1)
        if turtle.getItemCount() == 0 then
            turtle.suckUp()
            turtleUtils.Refuel()
        end

        turtle.select(2)

        if CanDrop then
            turtle.dig()
        end

        if not turtle.dropDown() then
            sleep(60)
            CanDrop = false
        else
            CanDrop = true
        end
    end
end

Main()
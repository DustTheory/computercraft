os.loadAPI("/git/turtleUtils.lua")

local CanDrop = true

local function Main()
    while true do
        if turtle.getFuelLevel == 0 then
            turtle.select(1)
            if turtle.getItemCount() == 0 then
                turtle.suckUp()
                turtleUtils.Refuel()
            end

            turtle.select(2)
        end

        local DidDig = false
        if CanDrop then
            if turtle.dig() then
                DidDig = true
            end
        end

        if (not turtle.dropDown()) and DidDig then
            sleep(60)
            CanDrop = false
        else
            CanDrop = true
        end

        print(turtle.getFuelLevel())
    end
end

Main()
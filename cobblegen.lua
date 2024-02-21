os.loadAPI("/git/turtleUtils.lua")

local CanDrop = true

local function Main()
    while true do
        ::begin::
        turtle.select(1)
        if turtle.getItemCount() == 0 then
            turtle.suckUp()
            turtleUtils.Refuel()
        end

        turtle.select(2)

        if CanDrop then
            if not turtle.dig() then
                sleep(1)
                goto begin
            end
        end

        if not turtle.dropDown() then
            sleep(1)
            CanDrop = false
        else
            CanDrop = true
        end
    end
end

Main()
local function Main()
    while true do

        if turtle.dig() and (not turtle.dropDown()) then
            sleep(60)
        end
    end
end

Main()
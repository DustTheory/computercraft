local args = {...}

local function Main()
    while true do
        turtle.suck(64)
        turtle.dropDown()
        sleep(tonumber(args[1]) or 1)
    end
end

Main()
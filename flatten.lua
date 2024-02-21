XPos = 0
YPos = 0 

FlattenX = 16
FlattenY = 16

local function Move()
    if turtle.detect() then 
        return turtle.dig()
    else
        return turtle.forward();
    end
end

local function Main()
    local EndProgram = false
    local MoveCount = 0

    while !EndProgram do
       EndProgram = Move()
       MoveCount = MoveCount + 1
       if MoveCount == 5 then
        EndProgram = true
       end
    end
end


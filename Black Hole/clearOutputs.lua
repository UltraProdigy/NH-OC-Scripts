local component = require("component")
local sides = require("sides")

local redstone1 = component.proxy("a4bcfe55-b349-45ee-8261-29a85dd341d4") -- South
local redstone2 = component.proxy("8e2e599f-9925-4e72-b21a-a0fb73e7ffe9") -- North

local function clearOutputs()
    print ("Clearing Previous Outputs")
    redstone1.setOutput(sides.south,0)
    redstone1.setOutput(sides.north,0)
    redstone1.setOutput(sides.east,0)
    redstone1.setOutput(sides.west,0)
    redstone1.setOutput(sides.top,0)
    redstone1.setOutput(sides.bottom,0)
    redstone2.setOutput(sides.south,0)
    redstone2.setOutput(sides.north,0)
end

clearOutputs()

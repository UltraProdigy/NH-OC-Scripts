-- Library Establishment
local component = require("component")
local term = require("term")
local os = require("os")
local sides = require("sides")

-- Local Global Variable Establishment
local antiMatter = component.proxy("289e234e-b795-4d1e-9728-9c09e2458e13")
local umvsc = component.proxy("7f84c75c-33e0-4d61-905a-c55174375592")
local activationSignal = component.proxy("d51243ae-2fd8-47e2-945a-f2b0ba75f22f")
local args = {...}
local antiMatterQuantity = tonumber(args[1])

-- Function to Read Amount of Antimatter in Tank
local function getAntimatter()
    while true do
        local amount = antiMatter.getTankLevel(sides.top) -- Need Correct Side
        if amount >= antiMatterQuantity then
            print("Antimatter levels have reached ".. antiMatterQuantity.. " Beginning SLAM Procedure")
            break
        else
            os.sleep(1)
        end
    end
end

-- Main Line
while true do
    term.clear()
    print("Initializing Program, use Ctrl + Alt + C to Exit")
    print("Waiting for Antimatter Levels to Reach ".. antiMatterQuantity.. " Liters")

    getAntimatter()
    antiMatter.transferFluid(sides.top, sides.bottom, antiMatterQuantity)
    umvsc.transferFluid(sides.north,sides.south,antiMatterQuantity)
    print("Antimatter and Superconductor Successfully Transferred, Activating SLAM")

    activationSignal.setOutput(sides.top,15)
        os.sleep(10)
    activationSignal.setOutput(sides.top,0)
    print("SLAM Cycle Complete, Restarting Program")
end

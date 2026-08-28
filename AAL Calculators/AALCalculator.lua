-- Library Declaration
local term = require("term")

-- Function to Prompt the User
local function ask(prompt)
    io.write(prompt.. " ")
    return io.read()
end

-- Function to Round Up to nearest tenth
local function roundUpToTenths(z)
    return math.ceil(z*10) / 10
end

-- Main Line

-- Voltage Setting
local voltage = ask("Enter Recipe Voltage Tier: ")
local voltageNumber = 0
local clockSet = 0

if voltage == "uxv" then
    voltageNumber = 536870912
    clockSet = 9
elseif voltage == "umv" then
    voltageNumber = 134217728
    clockSet = 8
elseif voltage == "uiv" then
    voltageNumber = 33554432
    clockSet = 7
elseif voltage == "uev" then
    voltageNumber = 8388608
    clockSet = 6
elseif voltage == "uhv" then
    voltageNumber = 2097152
    clockSet = 5
elseif voltage == "uv" then
    voltageNumber = 524288
    clockSet = 4
elseif voltage == "zpm" then
    voltageNumber = 131072
    clockSet = 3
elseif voltage == "luv" then
    voltageNumber = 32768
    clockSet = 2
elseif voltageNumber == "iv" then
    voltageNumber = 8192
    clockSet = 1
else
    print("Invalid tier; Use IV+ voltage or try again using lowercase letters")
end

-- Traditional Overclock Calculation
local overClock = ask("Enter Energy Hatch Tier: ")
local overClockNum = 0

if overClock == "uxv" then
    overClockNum = 9
elseif overClock == "umv" then
    overClockNum = 8
elseif overClock == "uiv" then
    overClockNum = 7
elseif overClock == "uev" then
    overClockNum = 6
elseif overClock == "uhv" then
    overClockNum = 5
elseif overClock == "uv" then
    overClockNum = 4
elseif overClock == "zpm" then
    overClockNum = 3
elseif overClock == "luv" then
    overClockNum = 2
elseif overClock == "iv" then
    overClockNum = 1
else
    print("Invalid tier; Use IV+ voltage or try again using lowercase letters")
end

overClockNum = (overClockNum - clockSet)
local rocTimeDiscount = 2^(overClockNum)

-- Time Setting & Function for Time Discount
local completionTime = ask("Enter Recipe Completion Time: ")
completionTime = tonumber(completionTime)

local function locTimeDiscount(x)
    local loctimeDiscount = 2^(overClockNum + x)
    return loctimeDiscount
end

-- Slice Setting
local sliceCount = ask("Enter # of Slices: ")
sliceCount = tonumber(sliceCount)

-- Machine Count Setting
local machineCount = ask("Enter Total Machine Count: ")
machineCount = tonumber(machineCount)

-- Function to Calculate Laser Overclock
local function laserOCAmpMultiplier(x)
    local result = 4.3
    for i = 2,x do
        result = result * (4.0 + i * 0.3)
    end
    return result
end

-- High Amp Recipe Contingency & Final Printout
local highAmpRecipe = ask("Is This a HIGH AMP Recipe? (In Need of ~1M+ Amps) [Y | N]: ")
if highAmpRecipe == "Y" or highAmpRecipe == "y" then
    term.clear()
    print("Statistics for a ".. voltage.. " recipe with ".. sliceCount.. " slices taking ".. completionTime.. " seconds using ".. overClock.. " voltage on "..machineCount.." machines:")
    print(string.rep("=",158))

    for i = 6,14 do
        local x = i
        print(x.." Laser Overclock")
        local ampPerMachine = laserOCAmpMultiplier(x) * sliceCount
        local totalAmps = ampPerMachine * machineCount
        print("Amps Per Machine = ".. math.ceil(ampPerMachine).." || Total Amps = "..math.ceil(totalAmps))
        local euPerMachine = voltageNumber * ampPerMachine
        local totalEU = euPerMachine * machineCount
        print("EU/t Per Machine = "..string.format("%.2e",euPerMachine).." || Total EU/t = "..string.format("%.2e",totalEU))
        local timePerSlice = completionTime / (locTimeDiscount(x) * sliceCount)
        local totalTime = completionTime / locTimeDiscount(x)
        print("Time Per Slice = "..(roundUpToTenths(timePerSlice)).."s || Total Time Per Operation = "..(roundUpToTenths(totalTime)).."s")
        print(string.rep("=",158))
    end

else
        term.clear()
        print("Statistics for a ".. voltage.. " recipe with ".. sliceCount.. " slices taking ".. completionTime.. " seconds using ".. overClock.. " voltage on "..machineCount.." machines:")
        print(string.rep("=",158))

        print("No Laser Overclock:")
        print("Amps Per Machine = ".. sliceCount.." || Total Amps = "..(sliceCount * machineCount))
        local A0 = voltageNumber * sliceCount
        local B0 = A0 * machineCount
        print("EU/t Per Machine = "..string.format("%.2e",A0).." || Total EU/t = "..string.format("%.2e",B0))
        print("Time Per Slice = "..(completionTime / (rocTimeDiscount * sliceCount)).."s || Total Time Per Operation = "..(completionTime / rocTimeDiscount).."s")
        print(string.rep("=",158))

    for i = 1,8 do
        local x = i
        print(x.." Laser Overclock")
        local ampPerMachine = laserOCAmpMultiplier(x) * sliceCount
        local totalAmps = ampPerMachine * machineCount
        print("Amps Per Machine = ".. math.ceil(ampPerMachine).." || Total Amps = "..math.ceil(totalAmps))
        local euPerMachine = voltageNumber * ampPerMachine
        local totalEU = euPerMachine * machineCount
        print("EU/t Per Machine = "..string.format("%.2e",euPerMachine).." || Total EU/t = "..string.format("%.2e",totalEU))
        local timePerSlice = completionTime / (locTimeDiscount(x) * sliceCount)
        local totalTime = completionTime / locTimeDiscount(x)
        print("Time Per Slice = "..(roundUpToTenths(timePerSlice)).."s || Total Time Per Operation = "..(roundUpToTenths(totalTime)).."s")
        print(string.rep("=",158))
    end
end

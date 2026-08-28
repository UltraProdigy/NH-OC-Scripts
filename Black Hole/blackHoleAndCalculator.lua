-- Library Call
local component = require("component")
local term = require ("term")
local os = require ("os")
local event = require("event")
local sides = require("sides")

-- Transcendent Variable Establishment
local prevItems = {}
local stAmount = 0
local activationSignal = 0
local totalLaserTime = 0
local gpu = component.gpu
local interface = component.me_interface
local redstone = component.proxy("087f2ef4-940e-4d6e-b238-397f2a65298f") -- Redstone I/O Address

-- Function to set Foreground to Green
local function green()
    gpu.setForeground(0x00FF00)
end

-- Function to set Foreground to Cyan
local function cyan()
    gpu.setForeground(0x00FFFF)
end

-- Function to set Foreground to Peach
local function peach()
    gpu.setForeground(0xFFCC99)
end

-- Function to set Foreground to Purple
local function purple()
    gpu.setForeground(0x8F00FF)
end

-- Function to set Foreground to White
local function white()
    gpu.setForeground(0xFFFFFF)
end

-- Function to Prompt the User
local function ask(prompt)
    io.write(prompt.. " ")
    return io.read()
end

-- Function to Obtain Consumption Information
local function spacetimePrompt()
    peach()
    io.write("Desired")
    purple()
    io.write(" Spacetime ")
    peach()
    stAmount = ask("Consumption Per Cycle (L):")
    stAmount = tonumber(stAmount)
end

-- Function to Find Value of "N" (But Y for sake of the program)
local function findY()
    local Y = 0
    while true do
        if (30*2^Y) > stAmount then
            return Y
        else
            Y = Y + 1
        end
    end
end    

-- Function to Sum Series for N-1
local function sumSeriesN()
    local sum = 0
    for N = 0, (findY() - 1) do
        sum = sum + (30 * 2^(N))
    end
    return sum
end

-- Function to Sum Series for N
local function sumSeries()
    local sum = 0
    for N = 0, (findY()) do
        sum = sum + (30 * 2^(N))
    end
    return sum
end

-- Remainder Function
local function remainder()
    local remainingLiters = stAmount - sumSeriesN()
    local litersNeededInTheNext30SecondsButWeArentUsingTheFull30Seconds = sumSeries() - sumSeriesN()
    local remainingSeconds = 30 * (remainingLiters / litersNeededInTheNext30SecondsButWeArentUsingTheFull30Seconds)
    return remainingSeconds
end

-- Function to Calculate Total Spacetime Consumption, Total Seconds Hole is Awake, & Parallel Efficiency
local function calculations()
    local totalAwakeTime = (30 * findY()) + remainder() + 90
    local parallelEfficiency = (1 - (80 / totalAwakeTime)) * 100
    green()
    io.write("Using ")
    cyan()
    io.write(stAmount.."L")
    green()
    io.write(" of ")
    purple()
    io.write("Spacetime")
    green()
    io.write(", Each Cycle will be ")
    cyan()
    io.write(math.ceil(totalAwakeTime).."(s)")
    green()
    io.write(" Operating at ")
    cyan()
    io.write(math.ceil(parallelEfficiency).."%")
    green()
    print(" Uptime-Parallel Efficiency")
    totalLaserTime = totalAwakeTime - 90
end

-- Function for Reading ME System
local function getItems()
    local items = {}
    for _, item in ipairs(interface.getItemsInNetwork()) do
        items[item.label] = item.size
    end
    return items
end

-- Item Check for Activation
local function checkForNewItem()
    while true do
    local currentItems = getItems()
        for label, count in pairs(currentItems) do
            if not prevItems[label] or count > prevItems[label] then
            green()
            print("Inputs Detected!")
            activationSignal = 1
            os.sleep(0.5)
                return
            end
        end
    prevItems = currentItems
    os.sleep(0.5)
    end
end

-- Clear Output Function
local function clearOutputs()
    peach()
    print ("Clearing Previous Outputs")
    redstone.setOutput(sides.east,0) -- Black Hole Seed Redstone Output
    redstone.setOutput(sides.north,0) -- Spacetime On/Off Redstone Output
    redstone.setOutput(sides.west,0) -- Black Hole Collapser Redstone Output
    activationSignal = 0
    os.sleep(0.5)
end

-- Emergency "Recipe Still Running" Check
local function checkRun()
    while true do
        if redstone.getInput(sides.top) ~= 0 then
            os.sleep(1)
        elseif redstone.getInput == 0 then
            break
        end
    os.sleep(0.5)
    end
    print("Last Recipe has Finished Runtime")
end

-- Activation Check & Timekeeper
local function waitForActivation()
    peach()
    print("Waiting for Activation Signal")
    while true do
        if activationSignal >= 1 then
            green()
            print("Signal Found; Initiating Black Hole")
            redstone.setOutput(sides.east,15) -- Black Hole Seed Redstone Output
            os.sleep(90)
            cyan()
            io.write("Stability Has Reached 10%; Deploying ")
            purple()
            print("Spacetime")
            redstone.setOutput(sides.north,15) -- Spacetime On/Off Redstone Output
            os.sleep(totalLaserTime) -- Expenditure
            io.write("Spacetime ")
            cyan()
            print("Expenditure at Limit; Attempting to Close Black Hole")
            redstone.setOutput(sides.west,15) -- Black Hole Collapser Redstone Output
            checkRun()
            return
        else
            os.sleep(0.5)
        end
        os.sleep(0.5)
    end
end

-- Main Line --

-- Initial Loop for Establishing Uptime
while true do
    term.clear()
    spacetimePrompt()
    calculations()
    peach()
    local confirmation = ask("Is This Configuration Okay? [Y/N]: ")
    if confirmation == "Y" or confirmation == "Yes" or confirmation == "y" then
        break
    else
    end
end

-- Loop for Running Black Hole
while true do
    term.clear()
    calculations()
    peach()
    print("Awaiting Recipe Inputs; Use Ctrl+Alt+C to Exit")
    checkForNewItem()
    os.sleep(0.5)
    waitForActivation()
    os.sleep(0.5)
    clearOutputs()
    os.sleep(0.5)
end

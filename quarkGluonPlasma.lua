-- Library Calls
local component = require("component")
local os = require ("os")
local sides = require("sides")

-- Interfaces
local fluidNet = component.proxy("f69d9513-945e-46c7-ba97-5d5f3c356c68")
local itemNet = component.proxy("0a9f8e2d-ab1d-4716-8b4c-e9d78d51f1a4")
local combinedReadOnlyNet = component.proxy("460fb446-eaa9-46cf-bdfd-637df3cc66d0")
local mainNetInterface = component.proxy("85f80d2b-651e-4a2b-bedc-b767a8fef96f")

-- Transposers
local mainNetTransposer = component.proxy("4fcd951d-fa03-4fb3-af26-7c788fdebcf2")
local trashTransposer = component.proxy("c800e45c-78de-4ff4-80a6-41c2eeda71bd")
local fluidTransposer1 = component.proxy("8ee16223-2940-420b-9a7b-b0ef39538cca")
local fluidTransposer2 = component.proxy("350991ec-ac64-4c84-a34f-f42215fea972")
local fluidTransposer3 = component.proxy("d5937940-6368-4aea-9dd3-c5df960e670b")
local fluidTransposer4 = component.proxy("90e64f83-a0bb-4fae-8bef-01984ce5186e")

-- Other Functionally Global Variables
local data = component.database
local dbaddress = data.address
local gpu = component.gpu
local meItemAmount = 0
local meFluidAmount = 0

-- Function to set Foreground to Green
local function green()
    gpu.setForeground(0x00FF00)
end

-- Function to set Foreground to Cyan
local function cyan()
    gpu.setForeground(0x00FFFF)
end

-- Function to set Foreground to White
local function white()
    gpu.setForeground(0xFFFFFF)
end

-- Function to Show User When Good Shutdown Time is
local function safeShutdown()
        local items = combinedReadOnlyNet.getItemsInNetwork()
        if #items > 0 then
            return
        else
            print("Ideal Shut Down Time Reached (5s)")
            os.sleep(5)
        end
end

-- Function to Read Items in ItemNet
local function readItemNet()
    local meItems = itemNet.getItemsInNetwork()
    meItemAmount = 0
        for _, item in ipairs(meItems) do
            meItemAmount = meItemAmount + item.size
        end
    return meItemAmount
end

-- Function to Perform PlasmaNet Item Transfer 
local function itemToPlasma()
    
    -- Checks for item in system and skips function if not
    while true do
        if readItemNet() == nil or readItemNet() == 0 then
            return
        else
            break
        end
    end

    -- Sets database to item
    local items = itemNet.getItemsInNetwork()
    local item = items[1]
    local itemName = item.label
    data.clear(1)
    data.set(1,item.name,item.damage,item.nbt)

    -- Establish batchQuantity
    local batchQuantity = readItemNet() * 9
    print("Found "..readItemNet().." of "..itemName.." in Item Net")

    -- Curium Contingency
    if itemName == "Curium Dust" then
        data.clear(1)
        fluidTransposer4.transferFluid(sides.west,sides.north,(batchQuantity * 144))
        trashTransposer.transferItem(sides.east,sides.top,64)
        return
    else
    end

    -- Iodine Contingency
    if itemName == "Iodine Dust" then
        data.clear(1)
        fluidTransposer4.transferFluid(sides.south,sides.north,(batchQuantity * 144))
        trashTransposer.transferItem(sides.east,sides.top,64)
        return
    else
    end

    -- Set Interface to Request Item
    mainNetInterface.setInterfaceConfiguration(1, dbaddress, 1, batchQuantity)
    
    -- Loop to check for complete item stocking
    while true do 
    local waitForSystem = mainNetTransposer.getSlotStackSize(sides.west, 1)
        if waitForSystem == batchQuantity then
            print("Transposing ".. batchQuantity.." "..itemName.." to Plasma Net")
            break
        else
            os.sleep(0.5)
        end
    end

    -- Transfer item to plasma, & Cleanup
    mainNetTransposer.transferItem(sides.west,sides.east,batchQuantity)
    mainNetInterface.setInterfaceConfiguration(1)
    trashTransposer.transferItem(sides.east,sides.top,64)
    data.clear(1)

end

-- Function to Read Fluids in FluidNet
local function readFluidNet()
    local meFluids = fluidNet.getItemsInNetwork()
    meFluidAmount = 0
        for _, item in ipairs(meFluids) do
            meFluidAmount = meFluidAmount + item.size
        end
    return meFluidAmount
end

-- Function to Perform PlasmaNet Fluid Transfer
local function fluidToPlasma()

    -- Checks for item in system and skips function if not
    while true do
        if readFluidNet() == nil or readFluidNet() == 0 then
            return
         else
            break
        end
    end

    -- Define Fluid
    local items = fluidNet.getItemsInNetwork()
    local item = items[1]
    local itemName = item.label
    local fluidQuantity = readFluidNet() * 1000
    print("Found "..readFluidNet().."L of "..itemName)

    -- Transposer 1 Transfers
    if itemName == "drop of Helium Gas" then
        fluidTransposer1.transferFluid(sides.east,sides.north,fluidQuantity)
        print("Transposing "..fluidQuantity.."L of "..itemName.." to Plasma Net")
    elseif itemName == "drop of Hydrogen Gas" then
        fluidTransposer1.transferFluid(sides.west,sides.north,fluidQuantity)
        print("Transposing "..fluidQuantity.."L of "..itemName.." to Plasma Net")
    elseif itemName == "drop of Radon" then
        fluidTransposer1.transferFluid(sides.south,sides.north,fluidQuantity)
        print("Transposing "..fluidQuantity.."L of "..itemName.." to Plasma Net")
    -- Transposer 2 Transfers
    elseif itemName == "drop of Tritium" then
        fluidTransposer2.transferFluid(sides.east,sides.north,fluidQuantity)
        print("Transposing "..fluidQuantity.."L of "..itemName.." to Plasma Net")
    elseif itemName == "drop of Chlorine" then
        fluidTransposer2.transferFluid(sides.west,sides.north,fluidQuantity)
        print("Transposing "..fluidQuantity.."L of "..itemName.." to Plasma Net")
    elseif itemName == "drop of Nitrogen Gas" then
        fluidTransposer2.transferFluid(sides.south,sides.north,fluidQuantity)
        print("Transposing "..fluidQuantity.."L of "..itemName.." to Plasma Net")
    -- Transposer 3 Transfers
    elseif itemName == "drop of Argon Gas" then
        fluidTransposer3.transferFluid(sides.east,sides.north,fluidQuantity)
        print("Transposing "..fluidQuantity.."L of "..itemName.." to Plasma Net")
    elseif itemName == "drop of Deuterium" then
        fluidTransposer3.transferFluid(sides.west,sides.north,fluidQuantity)
        print("Transposing "..fluidQuantity.."L of "..itemName.." to Plasma Net")
    elseif itemName == "drop of Mercury" then
        fluidTransposer3.transferFluid(sides.south,sides.north,fluidQuantity)
        print("Transposing "..fluidQuantity.."L of "..itemName.." to Plasma Net")
    -- Transposer 4 Transfers
    elseif itemName == "drop of Fluorine" then
        fluidTransposer4.transferFluid(sides.east,sides.north,fluidQuantity)
        print("Transposing "..fluidQuantity.."L of "..itemName.." to Plasma Net")
    else
        print("Fluid is Non-Transposable; Skipping Round")
        return
    end

    -- Transfer Fluid from FluidNet to TrashNet
    trashTransposer.transferFluid(sides.west,sides.bottom,64)

end

-- Main Line
while true do
    green()
    itemToPlasma()
    os.sleep(2)
    cyan()
    fluidToPlasma()
    os.sleep(2)
    white()
    safeShutdown()
end

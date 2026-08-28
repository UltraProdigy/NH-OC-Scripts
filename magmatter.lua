local component = require("component")
local term = require ("term")
local os = require ("os")
local event = require("event")

-- Set IDs of each Interface, Transposer, & Database
local seFluid = component.proxy("e1b54304-814b-4b90-9609-434f08358225")
local trtFluid = component.proxy("c371f88c-869d-4bdb-b646-ab3989c73ee4")
local tinyDust = component.proxy("39d4313a-0df3-43d7-bcf5-559ae363c59b")
local dustReceiver = component.proxy("fca3dce0-2c32-4390-94ab-68ce652652f2")
local dustTransposer = component.transposer
local data = component.database

-- Functionally Transcendent Variables
local seFluidAmount = 0
local trtFluidAmount = 0
local quantity = 0
local batchQuantity = 0
local remainder = 0
local dbAddress = data.address

-- Total item count for Spatially Enlarged Fluid
local function getSEFluidAmount()
    local seItems = seFluid.getItemsInNetwork()
    seFluidAmount = 0
        for _, item in ipairs(seItems) do
            seFluidAmount = seFluidAmount + item.size
        end
    print("Detected ".. seFluidAmount.. " Liters of Spatially Enlarged Fluid")
    return seFluidAmount
end

-- Total item count for Tachyon Rich Temporal Fluid
local function getTRTFluidAmount()
    local trtItems = trtFluid.getItemsInNetwork()
    trtFluidAmount = 0
        for _, item in ipairs(trtItems) do
            trtFluidAmount = trtFluidAmount + item.size
        end
    print("Detected ".. trtFluidAmount.. " Liters of Tachyon Rich Temporal Fluid")
    return trtFluidAmount
end

-- Function to establish Batchsize
local function findBatchsize()
    quantity =  (seFluidAmount - trtFluidAmount)
        if quantity > 64 then
            batchQuantity = 64
            remainder = (quantity - 64)
        else 
            batchQuantity = quantity
            remainder = 0
        end
    print("Batchsize will be ".. quantity)
end

-- Function to Detect Tiny Dust
local function getTinyDust()
    local tdItems = tinyDust.getItemsInNetwork()
    if #tdItems == 1 then
        return tdItems[1]
    end
    return nil
end

-- Function to Convert Tiny to Regular Dust & Queue in Interface
local function configureInterface()
    local item = getTinyDust()
    local itemName = item.label
    dustReceiver.setInterfaceConfiguration(1) -- Clears Interface Slots
    dustReceiver.setInterfaceConfiguration(2)
    print("Searching Government Database for ".. item.label)

    if itemName == "Rhugnor Dust" then
        dustReceiver.setInterfaceConfiguration(1, dbAddress, 1, batchQuantity)
        dustReceiver.setInterfaceConfiguration(2, dbAddress, 1, remainder)
    elseif itemName == "Bedrockium Dust" then
        dustReceiver.setInterfaceConfiguration(1, dbAddress, 2, batchQuantity)
        dustReceiver.setInterfaceConfiguration(2, dbAddress, 2, remainder)
    elseif itemName == "Hypogen Dust" then
        dustReceiver.setInterfaceConfiguration(1, dbAddress, 3, batchQuantity)
        dustReceiver.setInterfaceConfiguration(2, dbAddress, 3, remainder)
    elseif itemName == "Neutronium Dust" then
        dustReceiver.setInterfaceConfiguration(1, dbAddress, 4, batchQuantity)
        dustReceiver.setInterfaceConfiguration(2, dbAddress, 4, remainder)
    elseif itemName == "Celestial Tungsten Dust" then
        dustReceiver.setInterfaceConfiguration(1, dbAddress, 5, batchQuantity)
        dustReceiver.setInterfaceConfiguration(2, dbAddress, 5, remainder)
    elseif itemName == "Flerovium Dust" then
        dustReceiver.setInterfaceConfiguration(1, dbAddress, 6, batchQuantity)
        dustReceiver.setInterfaceConfiguration(2, dbAddress, 6, remainder)
    elseif itemName == "Infinity Dust" then
        dustReceiver.setInterfaceConfiguration(1, dbAddress, 7, batchQuantity)
        dustReceiver.setInterfaceConfiguration(2, dbAddress, 7, remainder)
    elseif itemName == "Draconium Dust" then
        dustReceiver.setInterfaceConfiguration(1, dbAddress, 8, batchQuantity)
        dustReceiver.setInterfaceConfiguration(2, dbAddress, 8, remainder)
    elseif itemName == "Awakened Draconium Dust" then
        dustReceiver.setInterfaceConfiguration(1, dbAddress, 9, batchQuantity)
        dustReceiver.setInterfaceConfiguration(2, dbAddress, 9, remainder)
    elseif itemName == "Dragonblood Dust" then
        dustReceiver.setInterfaceConfiguration(1, dbAddress, 10, batchQuantity)
        dustReceiver.setInterfaceConfiguration(2, dbAddress, 10, remainder)
    elseif itemName == "Chromatic Glass Dust" then
        dustReceiver.setInterfaceConfiguration(1, dbAddress, 11, batchQuantity)
        dustReceiver.setInterfaceConfiguration(2, dbAddress, 11, remainder)
    elseif itemName == "Ichorium Dust" then
        dustReceiver.setInterfaceConfiguration(1, dbAddress, 12, batchQuantity)
        dustReceiver.setInterfaceConfiguration(2, dbAddress, 12, remainder)
    elseif itemName == "Cosmic Neutronium Dust" then
        dustReceiver.setInterfaceConfiguration(1, dbAddress, 13, batchQuantity)
        dustReceiver.setInterfaceConfiguration(2, dbAddress, 13, remainder)
    elseif itemName == "Tritanium Dust" then
        dustReceiver.setInterfaceConfiguration(1, dbAddress, 14, batchQuantity)
        dustReceiver.setInterfaceConfiguration(2, dbAddress, 14, remainder)
    else
        print("Dust not Recognized as part of Magmatter System")
    end
    print("Warning: Big Papa Dust Corralling Imminent!")

end

-- Function to Check Interface item Amount, Transpose to Plasma Inventory, & TD Recycle
local function sendToPlasma()
    while true do
        if quantity == (dustTransposer.getSlotStackSize(4,1) + dustTransposer.getSlotStackSize(4,2)) then
            dustTransposer.transferItem(4, 5, batchQuantity, 1, 1) -- Main to Plasma
            dustTransposer.transferItem(4, 5, batchQuantity, 2, 2)
                print("Plasmifying Papi's Dust")
            break
        else
            print("Whats up donkey")
            os.sleep(1)
        end
    end
    print("Beginning System Cleanup")
end

while true do
    term.clear()
    print("Program Initializing; Use Ctrl + Alt + C to Cancel Program")
    local checker = getTinyDust()

    if checker ~= nil then
        getSEFluidAmount()
        getTRTFluidAmount()
        findBatchsize()
        configureInterface()
        sendToPlasma()
        dustTransposer.transferItem(0, 4, 1, 1, 9)
        os.sleep(5)
    else 
        os.sleep(5)
    end
end

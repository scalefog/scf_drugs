Inventory = exports.vorp_inventory:vorp_inventoryApi()

local VorpCore = {}

TriggerEvent("getCore",function(core)
    VorpCore = core
end)


data = {}

TriggerEvent("vorp_inventory:getData",function(call)
    data = call
end)
RegisterServerEvent("scf_drugs:reward1")
AddEventHandler("scf_drugs:reward1", function()
    local _source = source
    local User = VorpCore.getUser(_source) 
    local Character = User.getUsedCharacter         
    Inventory.subItem(_source, "cannabis", 5)
    Inventory.addItem(_source, "cannabis_pack", 1)

end)
RegisterServerEvent("scf_drugs:reward2")
AddEventHandler("scf_drugs:reward2", function()
    local _source = source
    local User = VorpCore.getUser(_source) 
    local Character = User.getUsedCharacter         
    Inventory.subItem(_source, "cocain", 5)
    Inventory.addItem(_source, "cocain_pack", 1)

end)
RegisterServerEvent('scf_drugs:pack1')
AddEventHandler('scf_drugs:pack1', function()
    local _source = source
    local User = VorpCore.getUser(_source) 
    local Character = User.getUsedCharacter 
    local count = Inventory.getItemCount(_source, "cannabis")
    if count >= 5 then
        TriggerClientEvent("scf_drugs:progress1", _source)	
    else
        TriggerClientEvent("vorp:Tip", _source, 'Not enough resources', 5000)
    end  
end)

RegisterServerEvent('scf_drugs:pack2')
AddEventHandler('scf_drugs:pack2', function()
    local _source = source
    local User = VorpCore.getUser(_source) 
    local Character = User.getUsedCharacter 
    local count = Inventory.getItemCount(_source, "cocain")
    if count >= 5 then
        TriggerClientEvent("scf_drugs:progress2", _source)	
    else
        TriggerClientEvent("vorp:Tip", _source, 'Not enough resources', 5000)
    end  
end)

-- Sale 
local DrugItems = {
    cocain_pack = {
        name = 'cocain_pack',
        displayName = 'Cocain pack',
        priceMin = 3,
        priceMax = 5,
    },
    cannabis_pack = {
        name = 'cannabis_pack',
        displayName = 'Cannabis Pack',
        priceMin = 3,
        priceMax = 5,
    }
}
DoPlayerHaveItems = function(player)
    local item = false

    for k, v in pairs(DrugItems) do
        local itemName = v.name
        local _source = source
        local User = VorpCore.getUser(_source) 
        local Character = User.getUsedCharacter 
        local itemInformation = Inventory.getItemCount(_source,itemName)

        if itemInformation > 0 then
            item = v

            break
        end
    end

    return item, item ~= false
end
RegisterServerEvent('scf_drugs:sale')
AddEventHandler('scf_drugs:sale',function()
    local _source = source
    local User = VorpCore.getUser(_source) 
    local Character = User.getUsedCharacter 
    local item, hasItem = DoPlayerHaveItems(_source)
    if hasItem then
        local count = Inventory.getItemCount(_source,item.name)
        local randomPayment =  math.random(item.priceMin, item.priceMax)
        local randomCount = math.random(1,3)
        local amount = 0

        if count <= randomCount then 
            amount = count
        else
            amount = randomCount
        end

        Inventory.subItem(_source, item.name, amount)
        local price = randomPayment * amount
        TriggerEvent("vorp:addMoney", _source, 0,price)
        TriggerClientEvent("vorp:Tip", _source, 'You sold '..amount..'x '..item.displayName..' for $'..price, 5000)
    else
        TriggerClientEvent("vorp:Tip", _source, 'You dont have drugs', 5000)
    end  

end)
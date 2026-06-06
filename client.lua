---@diagnostic disable: undefined-global, lowercase-global
-- ╔═══════════════════════════════════════════════════════════╗
-- ║  RDE | IPL MANAGER v1.0.1-alpha          ║
-- ║  Author: RDE | SerpentsByte                               ║
-- ║  Streaming-safe + in-interior exit + per-IPL map blips    ║
-- ╚═══════════════════════════════════════════════════════════╝

-- ============================================
-- 📌 IMPORTS & INITIALIZATION
-- ============================================
local Config = require 'config'

-- ============================================
-- 🎯 STATE MANAGEMENT
-- ============================================
---@class RDE_IPL_ClientState
local State = {
    properties     = {},
    zones          = {},
    blips          = {},
    currentInstance = nil,
    currentBucket   = 0,
    inProperty      = false,
    isAdmin         = false,
    loadedIPLs    = {},
    instanceIPLs  = {},
    entryCoords   = nil,
    exitZoneId    = nil,   -- v1.3: ox_target sphere zone inside interior
    iplCache      = {},
    debugMode     = Config.Statebag.Debug or false,
    playerData    = nil,
    isLoading     = false,
    lastInteraction = 0,
    performanceMetrics = {
        iplLoadTimes = {},
        zoneUpdates  = 0,
        blipUpdates  = 0,
        menuOpens    = 0,
    }
}

-- ============================================
-- 🌐 LANGUAGE SYSTEM
-- ============================================
---@param key string
---@param ... any
---@return string
local function L(key, ...)
    local lang = Config.Languages[Config.DefaultLanguage] or Config.Languages['en']
    local str = lang[key] or key
    if ... then
        return string.format(str, ...)
    end
    return str
end

-- ============================================
-- ⚡ PERFORMANCE UTILITIES
-- ============================================
local Performance = {}

function Performance.measureTime(callback, name)
    local start = GetGameTimer()
    local result = callback()
    local duration = GetGameTimer() - start

    if State.debugMode then
        print(('[RDE | IPL] ⏱️ %s: %dms'):format(name, duration))
    end

    return result, duration
end

function Performance.debounce(callback, delay)
    local timer = nil
    return function(...)
        if timer then return end
        timer = true
        callback(...)
        SetTimeout(delay or 100, function()
            timer = nil
        end)
    end
end

function Performance.throttle(callback, interval)
    local lastCall = 0
    return function(...)
        local now = GetGameTimer()
        if now - lastCall >= interval then
            lastCall = now
            callback(...)
        end
    end
end

-- ============================================
-- 🛡️ COORD VALIDATION (the "void drop" guard)
-- ============================================
---Returns true if coords look usable for a teleport.
---Catches the most common config bugs: nil, (0,0,0), missing fields.
---@param v any
---@return boolean
local function _isValidCoord(v)
    if not v then return false end
    if type(v.x) ~= 'number' or type(v.y) ~= 'number' or type(v.z) ~= 'number' then
        return false
    end
    -- (0,0,0) is the most common "I forgot to set this" sentinel and lives
    -- under the ocean — treat as invalid even if technically a real coord.
    if math.abs(v.x) < 0.01 and math.abs(v.y) < 0.01 and math.abs(v.z) < 0.01 then
        return false
    end
    return true
end

-- ============================================
-- 🎨 IPL MANAGER (collision-aware)
-- ============================================
local IPLManager = {}

---Load one IPL. Waits up to 10s for the engine to mark it active.
---Note: IsIplActive == true does NOT mean models/collision are streamed at
---a specific position — that's why the enterInstance flow also calls
---RequestCollisionAtCoord around the teleport target.
---@param name string
local function _loadOne(name)
    if State.loadedIPLs[name] then return end
    RequestIpl(name)

    local t = 0
    while not IsIplActive(name) and t < 100 do
        Wait(100)
        t = t + 1
    end

    State.loadedIPLs[name] = true

    if State.debugMode then
        if IsIplActive(name) then
            print(('[RDE|IPL] IPL active: %s (%dms)'):format(name, t * 100))
        else
            print(('^3[RDE|IPL] IPL timed out: %s — bad IPL name?^7'):format(name))
        end
    end
end

---Unload one IPL. Only touches IPLs that were tracked by us.
---@param name string
local function _unloadOne(name)
    if not State.loadedIPLs[name] then return end
    RemoveIpl(name)
    local t = 0
    while IsIplActive(name) and t < 30 do
        Wait(100)
        t = t + 1
    end
    State.loadedIPLs[name]   = nil
    State.instanceIPLs[name] = nil
    if State.debugMode then
        print(('[RDE|IPL] IPL unloaded: %s'):format(name))
    end
end

---Load IPL(s) for the current property instance.
---@param ipls string|string[]
function IPLManager.loadForInstance(ipls)
    if type(ipls) == 'string' then ipls = { ipls } end
    for _, name in ipairs(ipls) do
        _loadOne(name)
        State.instanceIPLs[name] = true
    end
end

---Load IPL(s) without instance-scope tracking.
---@param ipls string|string[]
function IPLManager.load(ipls)
    if type(ipls) == 'string' then ipls = { ipls } end
    for _, name in ipairs(ipls) do
        _loadOne(name)
    end
end

---Unload ONLY the IPLs that belong to the current instance.
function IPLManager.unloadInstance()
    for name in pairs(State.instanceIPLs) do
        _unloadOne(name)
    end
    State.instanceIPLs = {}
    if State.debugMode then
        print('[RDE|IPL] All instance IPLs unloaded')
    end
end

---Unload specific IPL(s) by name.
---@param ipls string|string[]
function IPLManager.unload(ipls)
    if type(ipls) == 'string' then ipls = { ipls } end
    for _, name in ipairs(ipls) do
        _unloadOne(name)
    end
end

---Apply a customization variant.
---@param iplData table
---@param customType string
---@param customId string
---@return boolean success
function IPLManager.applyCustomization(iplData, customType, customId)
    if not iplData.customizable or not iplData.customization then
        return false
    end
    local opts = iplData.customization[customType]
    if not opts then return false end

    for _, opt in ipairs(opts) do
        if opt.ipl then
            if opt.name == customId or opt.ipl == customId then
                _loadOne(opt.ipl)
                State.instanceIPLs[opt.ipl] = true
            else
                _unloadOne(opt.ipl)
            end
        end
    end
    return true
end

-- ============================================
-- 🚀 STREAMING-SAFE TELEPORT
-- ============================================
---Performs a teleport that does NOT drop the player into the void.
---Sequence: freeze → disable collision → RequestCollisionAtCoord +
---NewLoadSceneStart → wait for HasCollisionLoadedAroundEntity →
---SetEntityCoords → wait again → unfreeze + re-enable collision.
---Must be called from a thread that allows Wait().
---@param ped number
---@param x number
---@param y number
---@param z number
---@param heading number
---@param doFade boolean|nil  defaults to false (caller usually handles fade)
---@return boolean success
local function StreamingSafeTeleport(ped, x, y, z, heading, doFade)
    if doFade then
        DoScreenFadeOut(500)
        Wait(500)
    end

    FreezeEntityPosition(ped, true)
    SetEntityCollision(ped, false, false)

    -- Stage 1: ask the engine to stream this area
    RequestCollisionAtCoord(x, y, z)
    NewLoadSceneStart(x, y, z, 0.0, 0.0, 0.0, 50.0, 0)

    local tries = 0
    while not HasCollisionLoadedAroundEntity(ped) and tries < 100 do
        RequestCollisionAtCoord(x, y, z)
        Wait(50)
        tries = tries + 1
    end
    NewLoadSceneStop()

    -- Stage 2: teleport
    SetEntityCoords(ped, x, y, z, false, false, false, false)
    SetEntityHeading(ped, heading or 0.0)

    -- Stage 3: settle — give LODs a beat to finish, especially in interiors
    local settleTries = 0
    while not HasCollisionLoadedAroundEntity(ped) and settleTries < 40 do
        Wait(50)
        settleTries = settleTries + 1
    end
    Wait(200)

    -- Stage 4: hand control back
    SetEntityCollision(ped, true, true)
    FreezeEntityPosition(ped, false)

    if doFade then
        DoScreenFadeIn(800)
    end

    if State.debugMode then
        print(('[RDE|IPL] Teleport → %.2f %.2f %.2f | coll tries %d / settle %d'):format(
            x, y, z, tries, settleTries))
    end

    return true
end

-- ============================================
-- 🗺️ BLIP MANAGER
-- ============================================
local BlipManager = {}

---@param property table
---@return number|nil blipHandle
function BlipManager.create(property)
    local iplData = Config.IPLDatabase[property.iplIndex]
    if not iplData then return nil end

    -- v1.3: explicit "no blip" opt-out per IPL
    if iplData.blip == false then return nil end

    -- v1.3: per-IPL blip override → fallback to category defaults
    local blipDef    = type(iplData.blip) == 'table' and iplData.blip or nil
    local sprite     = (blipDef and blipDef.sprite) or Config.BlipSprites[iplData.category] or Config.BlipSprites.default
    local scale      = (blipDef and blipDef.scale)  or 0.8
    local ownedColor = (blipDef and blipDef.color)  or Config.BlipColors.owned
    -- For-sale color is always yellow per design — overriding via per-IPL color would
    -- defeat the visual "this is buyable" cue. We keep the for-sale color from config.
    local blipColor  = property.forSale and Config.BlipColors.forSale or ownedColor

    local blip = AddBlipForCoord(property.coords.x, property.coords.y, property.coords.z)
    SetBlipSprite(blip, sprite)
    SetBlipColour(blip, blipColor)
    SetBlipScale(blip, scale)
    SetBlipAsShortRange(blip, true)
    SetBlipDisplay(blip, 4)
    SetBlipAlpha(blip, 255)

    BeginTextCommandSetBlipName('STRING')
    local blipName = property.forSale and ('%s - %s'):format(iplData.name, L('for_sale')) or iplData.name
    if property.owner and Config.Property.ShowPropertyNames then
        blipName = ('%s (%s)'):format(iplData.name, L('owned'))
    end
    AddTextComponentString(blipName)
    EndTextCommandSetBlipName(blip)

    return blip
end

function BlipManager.refresh()
    Performance.measureTime(function()
        for _, blip in pairs(State.blips) do
            if DoesBlipExist(blip) then
                RemoveBlip(blip)
            end
        end

        State.blips = {}

        for instanceId, property in pairs(State.properties) do
            local shouldShow = (Config.Property.ShowForSaleBlips and property.forSale) or
                               (Config.Property.ShowOwnedBlips and property.owner)

            if shouldShow then
                State.blips[instanceId] = BlipManager.create(property)
            end
        end

        State.performanceMetrics.blipUpdates = State.performanceMetrics.blipUpdates + 1
    end, 'BlipManager.refresh')
end

function BlipManager.clear()
    for _, blip in pairs(State.blips) do
        if DoesBlipExist(blip) then
            RemoveBlip(blip)
        end
    end
    State.blips = {}
end

-- ============================================
-- 🎯 OX_TARGET MANAGER
-- ============================================
local TargetManager = {}

function TargetManager.setup()
    TargetManager.clear()

    for instanceId, property in pairs(State.properties) do
        local iplData = Config.IPLDatabase[property.iplIndex]
        if not iplData then goto continue end

        local options = {
            {
                name = 'rde_ipl_enter_' .. instanceId,
                icon = 'door-open',
                label = L('enter_property'),
                iconColor = '#3b82f6',
                onSelect = function()
                    TargetManager.handleEnter(property, iplData, instanceId)
                end,
                canInteract = function()
                    return not State.inProperty and not State.isLoading
                end
            }
        }

        if property.forSale then
            table.insert(options, {
                name = 'rde_ipl_buy_' .. instanceId,
                icon = 'circle-dollar-sign',
                label = L('buy_property', property.price),
                iconColor = '#10b981',
                items = Config.MoneySystem.Source == 'inventory' and Config.MoneySystem.InventoryItemName or nil,
                onSelect = function()
                    TargetManager.handleBuy(property, iplData, instanceId)
                end,
                canInteract = function()
                    return not State.inProperty and not State.isLoading
                end
            })
        end

        if property.owner or State.isAdmin then
            table.insert(options, {
                name = 'rde_ipl_manage_' .. instanceId,
                icon = 'settings',
                label = L('manage_property'),
                iconColor = '#8b5cf6',
                onSelect = function()
                    TargetManager.handleManage(property, iplData, instanceId)
                end,
                canInteract = function()
                    return not State.inProperty
                end
            })
        end

        local zoneId = exports.ox_target:addSphereZone({
            coords = property.coords.xyz,
            radius = Config.Property.InteractionDistance,
            debug = State.debugMode,
            options = options
        })

        if zoneId then
            State.zones[instanceId] = zoneId
        end

        ::continue::
    end

    State.performanceMetrics.zoneUpdates = State.performanceMetrics.zoneUpdates + 1
end

function TargetManager.handleEnter(property, iplData, instanceId)
    -- Client-side guard: if config coords are obviously broken, refuse before
    -- triggering the server. Server has its own check, this is just UX.
    if not _isValidCoord(iplData.coords) then
        lib.notify({
            title       = L('error'),
            description = 'This property has invalid coordinates — contact an admin',
            type        = 'error',
            icon        = 'triangle-alert',
            iconColor   = '#ef4444',
        })
        return
    end

    if lib.progressBar({
        duration = Config.Property.EnterTime,
        label = L('loading_property'),
        useWhileDead = false,
        canCancel = true,
        disable = {move = true, car = true, combat = true},
        anim = {dict = 'anim@heists@keycard@', clip = 'exit'},
    }) then
        TriggerServerEvent('rde_ipl:server:enterProperty', instanceId)
    end
end

function TargetManager.handleBuy(property, iplData, instanceId)
    local finalPrice = property.price
    if Config.MoneySystem.EnablePurchaseFee then
        finalPrice = finalPrice + math.floor((finalPrice * Config.MoneySystem.PurchaseFeePercent) / 100)
    end

    local alert = lib.alertDialog({
        header  = L('buy_property', finalPrice),
        content = ('%s\n\n**%s:** %s\n**%s:** %d\n\n%s'):format(
            iplData.description or iplData.name,
            'Category', L(iplData.category),
            'Max Capacity', iplData.maxOccupancy,
            L('confirm') .. '?'),
        centered = true,
        cancel   = true,
        labels   = {
            confirm = L('buy_property', finalPrice),
            cancel  = L('cancel'),
        },
    })

    if alert == 'confirm' then
        if lib.progressBar({
            duration     = 2000,
            label        = L('processing'),
            useWhileDead = false,
            canCancel    = false,
            disable      = { move = true, car = true, combat = true },
            anim         = { dict = 'mp_common', clip = 'givetake1_a' },
        }) then
            TriggerServerEvent('rde_ipl:server:buyProperty', instanceId)
        end
    end
end

function TargetManager.handleManage(property, iplData, instanceId)
    local options = {}

    table.insert(options, {
        title     = property.locked and L('unlock_property') or L('lock_property'),
        icon      = property.locked and 'lock-open' or 'lock',
        iconColor = property.locked and '#10b981' or '#ef4444',
        onSelect  = function()
            TriggerServerEvent('rde_ipl:server:toggleLock', instanceId)
        end
    })

    if iplData.customizable and iplData.customization then
        table.insert(options, {
            title     = L('customize_property'),
            icon      = 'palette',
            iconColor = '#8b5cf6',
            onSelect  = function()
                PropertyMenu.showCustomization(property, iplData, instanceId)
            end
        })
    end

    if Config.Property.AllowPropertySale then
        table.insert(options, {
            title       = L('sell_property'),
            description = ('Sell for $%d'):format(property.price),
            icon        = 'circle-dollar-sign',
            iconColor   = '#eab308',
            onSelect    = function()
                local alert = lib.alertDialog({
                    header   = L('sell_property'),
                    content  = L('sale_price', property.price),
                    centered = true,
                    cancel   = true,
                })
                if alert == 'confirm' then
                    TriggerServerEvent('rde_ipl:server:sellProperty', instanceId)
                end
            end
        })
    end

    lib.registerContext({
        id      = 'rde_ipl_manage',
        title   = L('manage_property'),
        options = options,
    })
    lib.showContext('rde_ipl_manage')
    State.performanceMetrics.menuOpens = State.performanceMetrics.menuOpens + 1
end

function TargetManager.clear()
    for instanceId, zoneId in pairs(State.zones) do
        exports.ox_target:removeZone(zoneId)
    end
    State.zones = {}
end

-- ============================================
-- 🏠 PROPERTY MENU
-- ============================================
PropertyMenu = {}

function PropertyMenu.open()
    TriggerServerEvent('rde_ipl:server:requestPlayerProperties')
end

function PropertyMenu.show(properties)
    if not properties or #properties == 0 then
        lib.notify({
            title = L('info'),
            description = 'You do not own any properties',
            type = 'info',
            icon = 'house',
            iconColor = '#3b82f6'
        })
        return
    end

    local options = {}

    for _, property in ipairs(properties) do
        table.insert(options, {
            title       = property.name,
            description = ('%s | Visits: %d | $%d'):format(
                property.locked and L('locked') or L('unlocked'),
                property.totalVisits,
                property.price),
            icon        = 'house',
            iconColor   = '#3b82f6',
            metadata    = {
                { label = L(property.category),  value = property.iplData.description or '' },
                { label = 'Status', value = property.locked and L('locked') or L('unlocked') },
                { label = 'Total Visits',   value = property.totalVisits },
                { label = 'Max Capacity',   value = property.iplData.maxOccupancy },
            },
            onSelect = function()
                PropertyMenu.showPropertyActions(property)
            end
        })
    end

    lib.registerContext({
        id      = 'rde_ipl_myproperties',
        title   = L('player_menu'),
        options = options,
    })
    lib.showContext('rde_ipl_myproperties')
    State.performanceMetrics.menuOpens = State.performanceMetrics.menuOpens + 1
end

function PropertyMenu.showPropertyActions(property)
    local options = {
        {
            title       = L('enter_property'),
            description = L('enter_property_desc') or 'Enter this property',
            icon        = 'door-open',
            iconColor   = '#3b82f6',
            onSelect    = function()
                if lib.progressBar({
                    duration  = Config.Property.EnterTime,
                    label     = L('loading_property'),
                    useWhileDead = false,
                    canCancel = true,
                    disable   = { move = true, car = true, combat = true },
                }) then
                    TriggerServerEvent('rde_ipl:server:enterProperty', property.instanceId)
                end
            end
        },
        {
            title     = property.locked and L('unlock_property') or L('lock_property'),
            icon      = property.locked and 'lock-open' or 'lock',
            iconColor = property.locked and '#10b981' or '#ef4444',
            onSelect  = function()
                TriggerServerEvent('rde_ipl:server:toggleLock', property.instanceId)
            end
        }
    }

    if property.iplData.customizable then
        table.insert(options, {
            title     = L('customize_property'),
            icon      = 'palette',
            iconColor = '#8b5cf6',
            onSelect  = function()
                PropertyMenu.showCustomization(property, property.iplData, property.instanceId)
            end
        })
    end

    if Config.Property.AllowPropertySale then
        local salePrice = property.price
        if Config.MoneySystem.EnableSellDiscount then
            salePrice = salePrice - math.floor((salePrice * Config.MoneySystem.SellDiscountPercent) / 100)
        end

        table.insert(options, {
            title       = L('sell_property'),
            description = ('Sell for $%d'):format(salePrice),
            icon        = 'circle-dollar-sign',
            iconColor   = '#eab308',
            onSelect    = function()
                local alert = lib.alertDialog({
                    header   = L('sell_property'),
                    content  = L('sale_price', salePrice),
                    centered = true,
                    cancel   = true,
                })
                if alert == 'confirm' then
                    TriggerServerEvent('rde_ipl:server:sellProperty', property.instanceId)
                end
            end
        })
    end

    lib.registerContext({
        id      = 'rde_ipl_property_actions',
        title   = property.name,
        menu    = 'rde_ipl_myproperties',
        options = options,
    })
    lib.showContext('rde_ipl_property_actions')
end

function PropertyMenu.showCustomization(property, iplData, instanceId)
    if not iplData.customization then return end

    local options = {}

    for customType, customOptions in pairs(iplData.customization) do
        local typeOptions = {}

        for _, option in ipairs(customOptions) do
            table.insert(typeOptions, {
                title = option.name,
                description = 'Apply this ' .. customType,
                icon = 'palette',
                iconColor = '#8b5cf6',
                onSelect = function()
                    TriggerServerEvent('rde_ipl:server:applyCustomization', instanceId, customType, option.name)
                end
            })
        end

        table.insert(options, {
            title       = customType:gsub("^%l", string.upper),
            description = (#typeOptions) .. ' options available',
            icon        = 'palette',
            iconColor   = '#8b5cf6',
            arrow       = true,
            onSelect    = function()
                lib.registerContext({
                    id      = 'rde_ipl_custom_' .. customType,
                    title   = customType:gsub("^%l", string.upper),
                    menu    = 'rde_ipl_customize',
                    options = typeOptions
                })
                lib.showContext('rde_ipl_custom_' .. customType)
            end
        })
    end

    lib.registerContext({
        id      = 'rde_ipl_customize',
        title   = L('customization'),
        menu    = 'rde_ipl_property_actions',
        options = options,
    })
    lib.showContext('rde_ipl_customize')
end

-- ============================================
-- 👑 ADMIN MENU
-- ============================================
local AdminMenu = {}

function AdminMenu.open()
    if not State.isAdmin then
        lib.notify({
            title = L('error'),
            description = L('admin_only'),
            type = 'error',
            icon = 'shield-off',
            iconColor = '#ef4444'
        })
        return
    end

    local options = {
        {
            title       = L('property_list'),
            description = 'View and manage all properties',
            icon        = 'layout-list',
            iconColor   = '#3b82f6',
            onSelect    = function() AdminMenu.showPropertyList() end,
        },
        {
            title       = L('create_property'),
            description = 'Create a new property at your position',
            icon        = 'circle-plus',
            iconColor   = '#10b981',
            onSelect    = function() AdminMenu.showCreateProperty() end,
        },
        {
            title       = L('statistics'),
            description = 'View server statistics',
            icon        = 'chart-bar',
            iconColor   = '#8b5cf6',
            onSelect    = function() AdminMenu.showStatistics() end,
        },
    }

    lib.registerContext({
        id      = 'rde_ipl_admin',
        title   = L('admin_menu'),
        options = options,
    })
    lib.showContext('rde_ipl_admin')
    State.performanceMetrics.menuOpens = State.performanceMetrics.menuOpens + 1
end

function AdminMenu.showPropertyList()
    local options = {}

    for instanceId, property in pairs(State.properties) do
        local iplData = Config.IPLDatabase[property.iplIndex]
        if iplData then
            table.insert(options, {
                title     = iplData.name,
                description = ('%s | $%d'):format(
                    property.forSale and L('for_sale') or L('owned'),
                    property.price),
                icon      = 'building-2',
                iconColor = property.forSale and '#eab308' or '#10b981',
                metadata  = {
                    { label = 'Instance ID', value = instanceId },
                    { label = 'Category',    value = L(iplData.category) },
                    { label = 'Price',       value = '$' .. property.price },
                    { label = 'Status',      value = property.forSale and L('for_sale') or L('owned') },
                    { label = 'Locked',      value = property.locked and L('locked') or L('unlocked') },
                    { label = 'Visits',      value = property.totalVisits or 0 },
                },
                onSelect = function()
                    AdminMenu.showPropertyAdmin(instanceId, property, iplData)
                end
            })
        end
    end

    lib.registerContext({
        id      = 'rde_ipl_admin_list',
        title   = L('property_list'),
        menu    = 'rde_ipl_admin',
        options = options,
    })
    lib.showContext('rde_ipl_admin_list')
end

function AdminMenu.showPropertyAdmin(instanceId, property, iplData)
    local options = {
        {
            title     = L('teleport_to_property'),
            icon      = 'map-pin',
            iconColor = '#3b82f6',
            onSelect  = function()
                TriggerServerEvent('rde_ipl:server:admin:teleport', instanceId)
            end
        },
        {
            title       = L('change_price'),
            description = L('current_price', property.price),
            icon        = 'circle-dollar-sign',
            iconColor   = '#eab308',
            onSelect    = function()
                local input = lib.inputDialog(L('change_price'), {
                    { type = 'number', label = L('new_price'),
                      description = L('current_price', property.price),
                      required = true, min = 1000 }
                })
                if input then
                    TriggerServerEvent('rde_ipl:server:admin:updateProperty', instanceId, { price = input[1] })
                end
            end
        },
        {
            title       = L('toggle_for_sale'),
            description = property.forSale and 'Mark as owned' or 'Mark for sale',
            icon        = 'arrow-left-right',
            iconColor   = '#8b5cf6',
            onSelect    = function()
                TriggerServerEvent('rde_ipl:server:admin:updateProperty', instanceId, { forSale = not property.forSale })
            end
        },
        {
            title     = L('delete_property'),
            icon      = 'trash-2',
            iconColor = '#ef4444',
            onSelect  = function()
                local alert = lib.alertDialog({
                    header   = L('delete_property'),
                    content  = L('delete_confirm'),
                    centered = true,
                    cancel   = true,
                    labels   = { confirm = L('delete'), cancel = L('cancel') },
                })
                if alert == 'confirm' then
                    TriggerServerEvent('rde_ipl:server:admin:deleteProperty', instanceId)
                end
            end
        },
    }

    lib.registerContext({
        id      = 'rde_ipl_admin_property',
        title   = iplData.name,
        menu    = 'rde_ipl_admin_list',
        options = options,
    })
    lib.showContext('rde_ipl_admin_property')
end

function AdminMenu.showCreateProperty()
    local categoryStyle = {
        apartment   = { icon = 'building-2',    color = '#3b82f6' },
        house       = { icon = 'house',          color = '#10b981' },
        mansion     = { icon = 'landmark',       color = '#8b5cf6' },
        garage      = { icon = 'car',            color = '#f59e0b' },
        warehouse   = { icon = 'warehouse',      color = '#64748b' },
        office      = { icon = 'briefcase',      color = '#0ea5e9' },
        bunker      = { icon = 'shield',         color = '#6b7280' },
        facility    = { icon = 'factory',        color = '#78716c' },
        nightclub   = { icon = 'music',          color = '#ec4899' },
        arcade      = { icon = 'gamepad-2',      color = '#a855f7' },
        casino      = { icon = 'diamond',        color = '#eab308' },
        carmeet     = { icon = 'car-front',      color = '#f97316' },
        heist       = { icon = 'vault',          color = '#ef4444' },
        business    = { icon = 'store',          color = '#22c55e' },
        restaurant  = { icon = 'utensils',       color = '#f97316' },
        police      = { icon = 'shield-check',   color = '#3b82f6' },
        prison      = { icon = 'fence',          color = '#71717a' },
        hospital    = { icon = 'heart-pulse',    color = '#ef4444' },
        stripclub   = { icon = 'star',           color = '#ec4899' },
        yacht       = { icon = 'anchor',         color = '#0ea5e9' },
        ship        = { icon = 'ship',           color = '#0891b2' },
        compound    = { icon = 'island',         color = '#16a34a' },
        special     = { icon = 'sparkles',       color = '#f59e0b' },
        event       = { icon = 'calendar',       color = '#8b5cf6' },
        hidden      = { icon = 'eye-off',        color = '#374151' },
    }

    local categories = {}
    for dbIndex, ipl in ipairs(Config.IPLDatabase) do
        if not categories[ipl.category] then
            categories[ipl.category] = {}
        end
        local entry = {}
        for k, v in pairs(ipl) do entry[k] = v end
        entry.dbIndex = dbIndex
        table.insert(categories[ipl.category], entry)
    end

    local options = {}
    for category, ipls in pairs(categories) do
        local style = categoryStyle[category] or { icon = 'building-2', color = '#3b82f6' }
        table.insert(options, {
            title       = L(category),
            description = (#ipls) .. ' IPLs available',
            icon        = style.icon,
            iconColor   = style.color,
            arrow       = true,
            onSelect    = function()
                AdminMenu.showIPLSelection(category, ipls)
            end
        })
    end

    lib.registerContext({
        id      = 'rde_ipl_admin_create',
        title   = L('create_property'),
        menu    = 'rde_ipl_admin',
        options = options,
    })
    lib.showContext('rde_ipl_admin_create')
end

function AdminMenu.showIPLSelection(category, ipls)
    local options = {}

    for _, ipl in ipairs(ipls) do
        -- Visual flag for entries whose coords haven't been validated yet
        local coordsOk = _isValidCoord(ipl.coords)
        local titlePrefix = coordsOk and '' or '⚠ '

        table.insert(options, {
            title = titlePrefix .. ipl.name,
            description = ('Default Price: $%d | Max: %d players'):format(ipl.price, ipl.maxOccupancy),
            icon = coordsOk and 'house' or 'triangle-alert',
            iconColor = coordsOk and '#3b82f6' or '#f59e0b',
            metadata = {
                {label = 'Category', value = L(ipl.category)},
                {label = 'Default Price', value = '$' .. ipl.price},
                {label = 'Max Occupancy', value = ipl.maxOccupancy},
                {label = 'Customizable', value = ipl.customizable and 'Yes' or 'No'},
                {label = 'Coords OK', value = coordsOk and 'Yes' or 'NO — fix config first'},
            },
            onSelect = function()
                AdminMenu.createPropertyDialog(ipl.dbIndex, ipl)
            end
        })
    end

    lib.registerContext({
        id      = 'rde_ipl_admin_select_' .. category,
        title   = L(category),
        menu    = 'rde_ipl_admin_create',
        options = options,
    })
    lib.showContext('rde_ipl_admin_select_' .. category)
end

function AdminMenu.createPropertyDialog(iplIndex, ipl)
    local ped = cache.ped
    local coords = GetEntityCoords(ped)
    local heading = GetEntityHeading(ped)

    local input = lib.inputDialog('Create Property: ' .. ipl.name, {
        {type = 'number', label = 'Price', description = 'Property price', default = ipl.price, required = true, min = 1000},
        {type = 'checkbox', label = 'For Sale', description = 'Mark as for sale?', checked = true}
    })

    if input then
        local price = input[1]
        local forSale = input[2]

        TriggerServerEvent('rde_ipl:server:admin:createProperty', iplIndex, vector4(coords.x, coords.y, coords.z, heading), price, forSale)
    end
end

function AdminMenu.showStatistics()
    TriggerServerEvent('rde_ipl:server:admin:getStatistics')
end

-- ============================================
-- 📡 STATEBAG & NETWORK EVENTS
-- ============================================

local debouncedRefresh = Performance.debounce(function()
    BlipManager.refresh()
    TargetManager.setup()
end, 500)

AddStateBagChangeHandler('rde_ipl_properties', 'global', function(bagName, key, value)
    if not value then return end

    State.properties = value
    debouncedRefresh()

    if State.debugMode then
        local count = 0
        for _ in pairs(value) do count = count + 1 end
        print(('[RDE | IPL] 📡 Properties synced: %d'):format(count))
    end
end)

RegisterNetEvent('rde_ipl:client:receiveAdminStatus', function(isAdmin)
    State.isAdmin = isAdmin
    if isAdmin and State.debugMode then
        print('[RDE | IPL] ✅ Admin privileges granted')
    end
end)

RegisterNetEvent('rde_ipl:client:receivePlayerProperties', function(properties)
    PropertyMenu.show(properties)
end)

-- ============================================
-- 🚪 ENTER INSTANCE (streaming-safe)
-- ============================================
RegisterNetEvent('rde_ipl:client:enterInstance', function(instanceId, bucketId, iplData, customization)
    if State.isLoading then return end
    State.isLoading = true

    CreateThread(function()
        local ped = cache.ped

        -- Validate config coords BEFORE we change any state, so we can bail cleanly
        if not iplData or not _isValidCoord(iplData.coords) then
            print(('^1[RDE|IPL] ❌ Invalid coords for IPL %s — abort enter^7'):format(
                (iplData and iplData.id) or 'unknown'))
            State.isLoading = false
            lib.notify({
                title       = L('error'),
                description = 'Property has invalid coordinates — contact an admin',
                type        = 'error',
                icon        = 'triangle-alert',
                iconColor   = '#ef4444',
            })
            -- Tell the server to clean up — we never actually entered
            TriggerServerEvent('rde_ipl:server:exitProperty')
            return
        end

        -- Save EXACT world position BEFORE any teleport so we can restore on exit.
        local pos     = GetEntityCoords(ped)
        local heading = GetEntityHeading(ped)
        State.entryCoords   = vector4(pos.x, pos.y, pos.z, heading)
        State.instanceIPLs  = {}

        State.currentInstance = instanceId
        State.currentBucket   = bucketId
        State.inProperty      = true

        -- Fade out first so the player doesn't see the freeze/IPL pop
        DoScreenFadeOut(500)
        Wait(500)

        -- Load IPLs (this waits for IsIplActive)
        Performance.measureTime(function()
            if iplData.ipl then
                IPLManager.loadForInstance(iplData.ipl)
            end
            if customization then
                for customType, customId in pairs(customization) do
                    IPLManager.applyCustomization(iplData, customType, customId)
                end
            end
        end, 'IPL Load: ' .. iplData.name)

        -- Streaming-safe teleport (fade is already done, so doFade=false)
        StreamingSafeTeleport(ped,
            iplData.coords.x, iplData.coords.y, iplData.coords.z,
            iplData.coords.w or 0.0,
            false)

        DoScreenFadeIn(800)
        State.isLoading = false

        if State.debugMode then
            print(('[RDE|IPL] Entered %s (bucket %d) | will return to %.1f %.1f %.1f'):format(
                instanceId, bucketId, pos.x, pos.y, pos.z))
        end

        -- v1.3: Add the in-interior exit ox_target sphere zone.
        -- Position: iplData.interiorExit (optional override) or iplData.coords (default).
        -- Radius:   iplData.interiorExitRadius or Config.Property.InteriorExitRadius (1.5).
        -- Client-side only — invisible to players in other buckets automatically.
        local exitPoint  = iplData.interiorExit       or iplData.coords
        local exitRadius = iplData.interiorExitRadius or Config.Property.InteriorExitRadius or 1.5

        if _isValidCoord(exitPoint) then
            -- Drop any leftover zone (resource reload edge case)
            if State.exitZoneId then
                exports.ox_target:removeZone(State.exitZoneId)
                State.exitZoneId = nil
            end

            State.exitZoneId = exports.ox_target:addSphereZone({
                coords = vec3(exitPoint.x, exitPoint.y, exitPoint.z),
                radius = exitRadius,
                debug  = State.debugMode,
                options = {
                    {
                        name      = 'rde_ipl_exit_zone',
                        icon      = 'door-closed',
                        label     = L('exit_property'),
                        iconColor = '#ef4444',
                        onSelect  = function()
                            if State.inProperty and not State.isLoading then
                                TriggerServerEvent('rde_ipl:server:exitProperty')
                            end
                        end,
                        canInteract = function()
                            return State.inProperty and not State.isLoading
                        end
                    }
                }
            })

            if State.debugMode then
                print(('[RDE|IPL] Exit zone added at %.2f %.2f %.2f (r=%.1f)'):format(
                    exitPoint.x, exitPoint.y, exitPoint.z, exitRadius))
            end
        end

        lib.notify({
            title       = L('success'),
            description = L('property_entered', iplData.name),
            type        = 'success',
            icon        = 'house',
            iconColor   = '#10b981',
        })

        Wait(2000)
        lib.notify({
            title       = L('info'),
            description = L('tip_exit'),
            type        = 'info',
            icon        = 'circle-help',
            iconColor   = '#3b82f6',
            duration    = 7000,
        })
    end)
end)

-- ============================================
-- 🚪 EXIT INSTANCE (streaming-safe)
-- ============================================
RegisterNetEvent('rde_ipl:client:exitInstance', function()
    if not State.inProperty or not State.currentInstance then
        State.isLoading = false
        return
    end

    -- v1.3: Tear down the in-interior exit zone IMMEDIATELY so the player can't
    -- re-trigger it while the exit teleport is still running.
    if State.exitZoneId then
        exports.ox_target:removeZone(State.exitZoneId)
        State.exitZoneId = nil
    end

    CreateThread(function()
        local ped = cache.ped

        DoScreenFadeOut(500)
        Wait(500)

        -- Unload ONLY our instance's IPLs (never touches foreign IPLs)
        IPLManager.unloadInstance()

        -- Determine exit destination — entry coords are the truth, exitCoords/property.coords are fallbacks
        local dest
        if State.entryCoords then
            dest = State.entryCoords
        else
            local property = State.properties[State.currentInstance]
            if property then
                local iplData = Config.IPLDatabase[property.iplIndex]
                if iplData and _isValidCoord(iplData.exitCoords) then
                    dest = iplData.exitCoords
                elseif _isValidCoord(property.coords) then
                    dest = property.coords
                end
            end
        end

        if _isValidCoord(dest) then
            -- Same streaming-safe sequence — collision at the OUTSIDE coord this time
            StreamingSafeTeleport(ped,
                dest.x, dest.y, dest.z,
                dest.w or 0.0,
                false)
        else
            -- Should never happen, but if it does don't leave the player stuck.
            print('^1[RDE|IPL] ⚠ No valid exit dest — leaving player at current coords^7')
        end

        -- Reset state
        State.inProperty      = false
        State.currentInstance = nil
        State.currentBucket   = 0
        State.entryCoords     = nil
        State.instanceIPLs    = {}
        State.isLoading       = false

        DoScreenFadeIn(500)

        if State.debugMode then
            print('[RDE|IPL] Exited instance — restored entry coords')
        end

        lib.notify({
            title       = L('info'),
            description = L('property_exited'),
            type        = 'info',
            icon        = 'log-out',
            iconColor   = '#3b82f6',
        })
    end)
end)

---Apply customization (server-triggered, e.g. after purchase confirmation)
RegisterNetEvent('rde_ipl:client:applyCustomization', function(customType, customId)
    if not State.inProperty or not State.currentInstance then return end

    local property = State.properties[State.currentInstance]
    if not property then return end

    local iplData = Config.IPLDatabase[property.iplIndex]
    if not iplData then return end

    CreateThread(function()
        local success = IPLManager.applyCustomization(iplData, customType, customId)

        if success then
            lib.notify({
                title       = L('success'),
                description = L('customization_applied', customType),
                type        = 'success',
                icon        = 'palette',
                iconColor   = '#8b5cf6',
            })
        end
    end)
end)

---Admin teleport — now also streaming-safe
RegisterNetEvent('rde_ipl:client:admin:teleport', function(coords)
    if not _isValidCoord(coords) then
        lib.notify({
            title       = L('error'),
            description = 'Invalid teleport coords',
            type        = 'error',
            icon        = 'triangle-alert',
            iconColor   = '#ef4444',
        })
        return
    end

    CreateThread(function()
        DoScreenFadeOut(500)
        Wait(500)

        StreamingSafeTeleport(cache.ped,
            coords.x, coords.y, coords.z,
            coords.w or 0.0,
            false)

        DoScreenFadeIn(500)
    end)
end)

---Receive statistics
RegisterNetEvent('rde_ipl:client:admin:receiveStatistics', function(stats)
    local options = {
        {
            title    = L('total_properties'),
            description = stats.totalProperties .. ' properties',
            icon     = 'house',
            iconColor = '#3b82f6',
            progress = math.min((stats.totalProperties / 100) * 100, 100),
            colorScheme = 'blue',
            metadata = {
                { label = L('for_sale'), value = stats.forSale },
                { label = L('owned'),    value = stats.owned },
            },
        },
        {
            title       = L('total_value'),
            description = '$' .. stats.totalValue,
            icon        = 'circle-dollar-sign',
            iconColor   = '#eab308',
        },
        {
            title       = L('active_instances'),
            description = stats.activeInstances .. ' instances',
            icon        = 'layers',
            iconColor   = '#10b981',
            metadata    = {
                { label = 'Players Inside', value = stats.playersInProperties },
                { label = 'Buckets Used',   value = stats.buckets.used .. '/' .. stats.buckets.total },
            },
        },
        {
            title       = 'Performance',
            description = 'Server performance statistics',
            icon        = 'gauge',
            iconColor   = '#8b5cf6',
            metadata    = {
                { label = 'Total Transactions',  value = stats.metrics.totalTransactions },
                { label = 'Successful Purchases',value = stats.metrics.successfulPurchases },
                { label = 'Failed Purchases',    value = stats.metrics.failedPurchases },
                { label = 'Instances Created',   value = stats.metrics.instancesCreated },
                { label = 'Instances Destroyed', value = stats.metrics.instancesDestroyed },
                { label = 'Peak Concurrent',     value = stats.metrics.peakConcurrentInstances },
                { label = 'Total Revenue',       value = '$' .. stats.metrics.totalRevenue },
                { label = 'Players Served',      value = stats.metrics.playersServed },
            },
        },
        {
            title       = 'IPL Database',
            description = stats.iplCount .. ' IPLs available',
            icon        = 'database',
            iconColor   = '#64748b',
            metadata    = (function()
                local meta = {}
                for category, count in pairs(stats.iplByCategory) do
                    table.insert(meta, { label = L(category), value = count })
                end
                return meta
            end)(),
        },
    }

    lib.registerContext({
        id      = 'rde_ipl_admin_stats',
        title   = L('statistics'),
        menu    = 'rde_ipl_admin',
        options = options,
    })
    lib.showContext('rde_ipl_admin_stats')
end)

---Refresh zones
RegisterNetEvent('rde_ipl:client:refreshZones', function()
    TargetManager.setup()
    BlipManager.refresh()
end)

-- ============================================
-- 💬 COMMANDS
-- ============================================
RegisterNetEvent('rde_ipl:client:openAdminMenu', function()
    AdminMenu.open()
end)

RegisterCommand('myproperties', function()
    PropertyMenu.open()
end, false)

RegisterCommand('exitproperty', function()
    if State.inProperty then
        TriggerServerEvent('rde_ipl:server:exitProperty')
    else
        lib.notify({
            title = L('warning'),
            description = L('not_in_property'),
            type = 'warning',
            icon = 'alert-circle',
            iconColor = '#f59e0b'
        })
    end
end, false)

if State.debugMode then
    RegisterCommand('ipldebug', function()
        print('=== RDE IPL v1.0.1-alpha - Debug Info ===')
        print(('Properties: %d'):format((function() local c = 0 for _ in pairs(State.properties) do c = c + 1 end return c end)()))
        print(('Loaded IPLs: %d'):format((function() local c = 0 for _ in pairs(State.loadedIPLs) do c = c + 1 end return c end)()))
        print(('Instance IPLs: %d'):format((function() local c = 0 for _ in pairs(State.instanceIPLs) do c = c + 1 end return c end)()))
        print(('Current Instance: %s'):format(State.currentInstance or 'None'))
        print(('Current Bucket: %d'):format(State.currentBucket))
        print(('In Property: %s'):format(tostring(State.inProperty)))
        print(('Is Admin: %s'):format(tostring(State.isAdmin)))
        print(('Entry Coords: %s'):format(State.entryCoords and tostring(State.entryCoords) or 'None'))
        print(('Exit Zone ID: %s'):format(State.exitZoneId and tostring(State.exitZoneId) or 'None'))
        print(('Zone Updates: %d'):format(State.performanceMetrics.zoneUpdates))
        print(('Blip Updates: %d'):format(State.performanceMetrics.blipUpdates))
        print(('Menu Opens: %d'):format(State.performanceMetrics.menuOpens))
        print('================================')
    end, false)
end

-- ============================================
-- 🎬 INITIALIZATION
-- ============================================
CreateThread(function()
    Wait(1000)

    TriggerServerEvent('rde_ipl:server:requestAdminStatus')
    Wait(500)

    if GlobalState.rde_ipl_properties then
        State.properties = GlobalState.rde_ipl_properties
        BlipManager.refresh()
        TargetManager.setup()
    end

    print('^2╔═══════════════════════════════════════════════════════════╗^7')
    print('^2║  RDE | IPL MANAGER v1.0.1-alpha - CLIENT READY                    ║^7')
    print('^2║  Streaming-safe + interior exit + per-IPL blips           ║^7')
    print('^2╚═══════════════════════════════════════════════════════════╝^7')
end)

-- ============================================
-- 🧹 CLEANUP
-- ============================================
AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end

    BlipManager.clear()
    TargetManager.clear()

    -- v1.3: Remove the in-interior exit zone if it's still around
    if State.exitZoneId then
        exports.ox_target:removeZone(State.exitZoneId)
        State.exitZoneId = nil
    end

    -- Only unload IPLs we loaded — never touch foreign IPLs
    for name in pairs(State.instanceIPLs) do
        RemoveIpl(name)
    end

    -- If the player was inside a property when the resource stops,
    -- unfreeze them — better than leaving them stuck.
    if State.inProperty then
        local ped = PlayerPedId()
        FreezeEntityPosition(ped, false)
        SetEntityCollision(ped, true, true)
        DoScreenFadeIn(0)
    end

    lib.hideTextUI()
    lib.hideContext()

    State.inProperty      = false
    State.entryCoords     = nil
    State.instanceIPLs    = {}
    State.loadedIPLs      = {}
    State.currentInstance = nil
    State.currentBucket   = 0

    print('^2[RDE | IPL v1.0.1-alpha]^7 Client cleanup done')
end)

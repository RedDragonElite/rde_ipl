---@diagnostic disable: undefined-global, lowercase-global
-- ╔═══════════════════════════════════════════════════════════╗
-- ║  RDE | IPL MANAGER v1.0.1-alpha          ║
-- ║  Author: RDE | SerpentsByte                               ║
-- ║  "The most advanced IPL server ever created for FiveM"    ║
-- ║  100% Statebag-First | Triple Admin | Exploit-Proof       ║
-- ╚═══════════════════════════════════════════════════════════╝

-- ============================================
-- 📌 IMPORTS & INITIALIZATION
-- ============================================
local Ox = require '@ox_core/lib/init'
local Config = require 'config'

-- ============================================
-- 🎯 TYPED STATE MANAGEMENT (FULL COVERAGE!)
-- ============================================
---@class RDE_IPL_Property
---@field id number
---@field iplIndex number
---@field owner string|nil
---@field coords vector4
---@field price number
---@field forSale boolean
---@field locked boolean
---@field instanceId string
---@field customization table<string, string>
---@field accessList string[]
---@field lastEntered string|nil
---@field totalVisits number
---@field createdAt number
---@field updatedAt number

---@class RDE_IPL_ActiveInstance
---@field instanceId string
---@field propertyId number
---@field iplIndex number
---@field coords vector4
---@field routingBucket number
---@field players table<number, {joined: number, source: number, identifier: string, name: string}>
---@field created number
---@field lastActivity number
---@field customization table<string, string>
---@field iplData table

---@class RDE_IPL_ServerState
local State = {
    properties = {},           -- instanceId → Property
    activeInstances = {},      -- instanceId → ActiveInstance  
    playerInstances = {},      -- source → instanceId
    propertyOwners = {},       -- identifier → instanceId[]
    routingBuckets = {},       -- bucketId → {used, assignedAt, instanceId}
    rateLimits = {},          -- key → {count, resetAt}
    performanceMetrics = {
        totalTransactions = 0,
        successfulPurchases = 0,
        failedPurchases = 0,
        instancesCreated = 0,
        instancesDestroyed = 0,
        playersServed = 0,
        averageInstanceDuration = 0,
        peakConcurrentInstances = 0,
        totalRevenue = 0
    },
    nextBucketId = Config.RoutingBuckets.StartBucketId,
    debugMode = Config.Statebag.Debug or false,
    initialized = false
}

-- ============================================
-- 🌐 LANGUAGE SYSTEM (BEAUTIFUL!)
-- ============================================
---Get localized string
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
-- 📢 NOTIFICATION SYSTEM (OX_LIB V3!)
-- ============================================
---Send notification to player
---@param source number
---@param title string
---@param description string
---@param type 'success'|'error'|'info'|'warning'
---@param icon string|nil (lucide icon name)
---@param iconColor string|nil (hex color)
---@param duration number|nil (milliseconds)
local function Notify(source, title, description, type, icon, iconColor, duration)
    TriggerClientEvent('ox_lib:notify', source, {
        title = title,
        description = description,
        type = type or 'info',
        icon = icon,
        iconColor = iconColor,
        duration = duration or 5000,
        position = 'top-right'
    })
end

---Send notification to all players
---@param title string
---@param description string
---@param type 'success'|'error'|'info'|'warning'
---@param icon string|nil
local function NotifyAll(title, description, type, icon)
    TriggerClientEvent('ox_lib:notify', -1, {
        title = title,
        description = description,
        type = type or 'info',
        icon = icon,
        duration = 5000
    })
end

-- ============================================
-- 🐉 RDE NOSTR LOGGER (OPTIONAL – GRACEFUL FALLBACK)
-- ============================================
-- Works with or without rde_nostr_log installed.
-- If the resource is not running, all log calls become no-ops.
-- API: exports['rde_nostr_log']:postLog(message, tags)
-- Tags: {{'key', 'value'}, ...}  -- same format as rde_nostr_log EXAMPLES.lua
-- ============================================
local RDELog = {}

-- Internal: check once if nostr log resource is available
local _nostrAvailable = nil
local function _isNostrAvailable()
    if _nostrAvailable ~= nil then return _nostrAvailable end
    -- GetResourceState returns 'started'|'stopped'|'missing'|'uninitialized'
    _nostrAvailable = GetResourceState('rde_nostr_log') == 'started'
    return _nostrAvailable
end

-- Internal: reset availability cache on resource state changes so hot-restarts work
AddEventHandler('onResourceStart', function(res)
    if res == 'rde_nostr_log' then _nostrAvailable = true end
end)
AddEventHandler('onResourceStop', function(res)
    if res == 'rde_nostr_log' then _nostrAvailable = false end
end)

-- Internal: safely call the export, never error
local function _post(msg, tags)
    if not _isNostrAvailable() then return end
    local ok, err = pcall(function()
        exports['rde_nostr_log']:postLog(msg, tags)
    end)
    if not ok and State.debugMode then
        print(('[RDE|IPL] Nostr log failed (non-critical): ' .. tostring(err)))
    end
end

-- ─── Public helpers ────────────────────────────────────────────────────────

---Log a property purchase
---@param player table  ox_core OxPlayer
---@param instanceId string
---@param iplName string
---@param price number
function RDELog.purchase(player, instanceId, iplName, price)
    _post(
        ('💰 PROPERTY PURCHASED | %s bought [%s] for $%d'):format(
            player.username, iplName, price),
        {
            {'event',       'property_purchase'},
            {'resource',    'rde_ipl'},
            {'identifier',  player.identifier},
            {'player',      player.username},
            {'instance_id', instanceId},
            {'ipl_name',    iplName},
            {'price',       tostring(price)},
        }
    )
end

---Log a property sale
---@param player table
---@param instanceId string
---@param iplName string
---@param price number
function RDELog.sale(player, instanceId, iplName, price)
    _post(
        ('💵 PROPERTY SOLD | %s sold [%s] for $%d'):format(
            player.username, iplName, price),
        {
            {'event',       'property_sale'},
            {'resource',    'rde_ipl'},
            {'identifier',  player.identifier},
            {'player',      player.username},
            {'instance_id', instanceId},
            {'ipl_name',    iplName},
            {'payout',      tostring(price)},
        }
    )
end

---Log a player entering a property
---@param player table
---@param instanceId string
---@param iplName string
---@param bucket number
function RDELog.enter(player, instanceId, iplName, bucket)
    _post(
        ('🚪 ENTERED PROPERTY | %s → [%s] (bucket %d)'):format(
            player.username, iplName, bucket),
        {
            {'event',       'property_enter'},
            {'resource',    'rde_ipl'},
            {'identifier',  player.identifier},
            {'player',      player.username},
            {'instance_id', instanceId},
            {'ipl_name',    iplName},
            {'bucket',      tostring(bucket)},
        }
    )
end

---Log a player exiting a property
---@param player table
---@param instanceId string
---@param iplName string
function RDELog.exit(player, instanceId, iplName)
    _post(
        ('🚶 EXITED PROPERTY | %s ← [%s]'):format(player.username, iplName),
        {
            {'event',       'property_exit'},
            {'resource',    'rde_ipl'},
            {'identifier',  player.identifier},
            {'player',      player.username},
            {'instance_id', instanceId},
            {'ipl_name',    iplName},
        }
    )
end

---Log an admin action (create / delete / update / teleport)
---@param admin table
---@param action string
---@param instanceId string
---@param detail string|nil
function RDELog.adminAction(admin, action, instanceId, detail)
    _post(
        ('👑 ADMIN ACTION | %s → %s on [%s]%s'):format(
            admin.username, action, instanceId,
            detail and (' | ' .. detail) or ''),
        {
            {'event',       'admin_action'},
            {'resource',    'rde_ipl'},
            {'identifier',  admin.identifier},
            {'admin',       admin.username},
            {'action',      action},
            {'instance_id', instanceId},
            {'detail',      detail or ''},
        }
    )
end

---Log a property deletion
---@param admin table
---@param instanceId string
---@param iplName string
function RDELog.deleteProperty(admin, instanceId, iplName)
    _post(
        ('🗑️ PROPERTY DELETED | %s deleted [%s] (%s)'):format(
            admin.username, iplName, instanceId),
        {
            {'event',       'property_deleted'},
            {'resource',    'rde_ipl'},
            {'identifier',  admin.identifier},
            {'admin',       admin.username},
            {'instance_id', instanceId},
            {'ipl_name',    iplName},
        }
    )
end

---Log a property creation by admin
---@param admin table
---@param instanceId string
---@param iplName string
---@param price number
function RDELog.createProperty(admin, instanceId, iplName, price)
    _post(
        ('🏗️ PROPERTY CREATED | %s created [%s] @ $%d'):format(
            admin.username, iplName, price),
        {
            {'event',       'property_created'},
            {'resource',    'rde_ipl'},
            {'identifier',  admin.identifier},
            {'admin',       admin.username},
            {'instance_id', instanceId},
            {'ipl_name',    iplName},
            {'price',       tostring(price)},
        }
    )
end

---Log a lock toggle
---@param player table
---@param instanceId string
---@param locked boolean
function RDELog.lockToggle(player, instanceId, locked)
    _post(
        ('%s LOCK TOGGLE | %s %s [%s]'):format(
            locked and '🔒' or '🔓',
            player.username,
            locked and 'locked' or 'unlocked',
            instanceId),
        {
            {'event',       'property_lock_toggle'},
            {'resource',    'rde_ipl'},
            {'identifier',  player.identifier},
            {'player',      player.username},
            {'instance_id', instanceId},
            {'locked',      tostring(locked)},
        }
    )
end

---Log a security violation attempt
---@param source number
---@param action string
---@param detail string|nil
function RDELog.securityViolation(source, action, detail)
    local name = GetPlayerName(source) or 'unknown'
    local steam = GetPlayerIdentifierByType(source, 'steam') or 'unknown'
    _post(
        ('⚠️ SECURITY VIOLATION | src:%d [%s] attempted: %s%s'):format(
            source, name, action,
            detail and (' | ' .. detail) or ''),
        {
            {'event',     'security_violation'},
            {'resource',  'rde_ipl'},
            {'source',    tostring(source)},
            {'player',    name},
            {'steam',     steam},
            {'action',    action},
            {'detail',    detail or ''},
        }
    )
end

---Log custom message (for debugging / misc events)
---@param level 'info'|'warn'|'error'
---@param msg string
---@param tags table|nil
function RDELog.custom(level, msg, tags)
    local prefix = level == 'error' and '❌' or level == 'warn' and '⚠️' or 'ℹ️'
    local combined = { {'event', 'custom'}, {'resource', 'rde_ipl'}, {'level', level} }
    if tags then
        for _, t in ipairs(tags) do table.insert(combined, t) end
    end
    _post(('%s [IPL] %s'):format(prefix, msg), combined)
end


local AdminSystem = {}

---Check if player is admin (ANY of the three methods)
---@param source number
---@return boolean
function AdminSystem.isAdmin(source)
    local player = Ox.GetPlayer(source)
    if not player then return false end

    local adminConfig = Config.AdminSystem
    local identifier = GetPlayerIdentifierByType(source, 'steam')

    -- Check in configured order
    for _, method in ipairs(adminConfig.checkOrder) do
        if method == 'ace' then
            -- ✅ Method 1: ACE Permissions
            if IsPlayerAceAllowed(source, adminConfig.acePermission) then
                if State.debugMode then
                    print(('🔐 [ADMIN] %s verified via ACE: %s'):format(player.username, adminConfig.acePermission))
                end
                return true
            end
        elseif method == 'oxcore' then
            -- ✅ Method 2: ox_core Groups
            if player.getGroups then
                local groups = player.getGroups()
                for groupName, minGrade in pairs(adminConfig.oxGroups) do
                    if groups[groupName] and groups[groupName] >= minGrade then
                        if State.debugMode then
                            print(('🔐 [ADMIN] %s verified via ox_core: %s (grade %s)'):format(player.username, groupName, groups[groupName]))
                        end
                        return true
                    end
                end
            end
        elseif method == 'steam' then
            -- ✅ Method 3: Steam ID Whitelist
            if identifier then
                for _, allowedId in ipairs(adminConfig.steamIds) do
                    if identifier == allowedId then
                        if State.debugMode then
                            print(('🔐 [ADMIN] %s verified via Steam: %s'):format(player.username, identifier))
                        end
                        return true
                    end
                end
            end
        end
    end

    -- ❌ Access denied - log attempt
    if State.debugMode then
        print(('⚠️ [SECURITY] Unauthorized admin attempt: %s [%s]'):format(player.username, identifier or 'unknown'))
    end
    return false
end

---Check if player is admin with detailed reason
---@param source number
---@return boolean isAdmin
---@return string method
---@return string detail
function AdminSystem.isAdminWithReason(source)
    local player = Ox.GetPlayer(source)
    if not player then return false, 'invalid_player', nil end

    local adminConfig = Config.AdminSystem
    local identifier = GetPlayerIdentifierByType(source, 'steam')

    for _, checkMethod in ipairs(adminConfig.checkOrder) do
        if checkMethod == 'ace' and IsPlayerAceAllowed(source, adminConfig.acePermission) then
            return true, 'ace', adminConfig.acePermission
        elseif checkMethod == 'oxcore' then
            if player.getGroups then
                local groups = player.getGroups()
                for groupName, minGrade in pairs(adminConfig.oxGroups) do
                    if groups[groupName] and groups[groupName] >= minGrade then
                        return true, 'oxcore', ('%s:%s'):format(groupName, groups[groupName])
                    end
                end
            end
        elseif checkMethod == 'steam' and identifier then
            for _, allowedId in ipairs(adminConfig.steamIds) do
                if identifier == allowedId then
                    return true, 'steam', identifier
                end
            end
        end
    end

    return false, 'unauthorized', identifier or 'unknown'
end

-- ============================================
-- ⚡ RATE LIMITING SYSTEM (ANTI-SPAM!)
-- ============================================
local RateLimit = {}

---Check if action is allowed (rate limiting)
---@param source number
---@param action string
---@param limit number|nil
---@param window number|nil
---@return boolean allowed
---@return string|nil errorMsg
function RateLimit.check(source, action, limit, window)
    if not Config.Performance.EnableRateLimiting then
        return true
    end

    limit = limit or Config.Performance.RateLimitMax
    window = window or Config.Performance.RateLimitWindow

    local player = Ox.GetPlayer(source)
    local identifier = player and (player.identifier) or tostring(source)
    local key = ('%s:%s'):format(identifier, action)
    local now = os.time() * 1000

    if not State.rateLimits[key] then
        State.rateLimits[key] = { count = 0, resetAt = now + window }
    end

    local limitData = State.rateLimits[key]

    -- Reset if window expired
    if now >= limitData.resetAt then
        limitData.count = 0
        limitData.resetAt = now + window
    end

    -- Check limit
    if limitData.count >= limit then
        if State.debugMode then
            print(('[RDE | IPL] 🚫 Rate limit: %s for %s'):format(action, identifier))
        end
        return false, L('warning') .. ' ' .. ('Rate limit exceeded. Try again in %d seconds'):format(math.ceil((limitData.resetAt - now) / 1000))
    end

    limitData.count = limitData.count + 1
    return true
end

-- ============================================
-- 💰 MONEY SYSTEM (DUAL MODE: INVENTORY OR BANKING!)
-- ============================================
local MoneySystem = {}

---Check if player has enough money
---@param source number
---@param amount number
---@return boolean
function MoneySystem.hasMoney(source, amount)
    local player = Ox.GetPlayer(source)
    if not player then return false end

    if Config.MoneySystem.Source == 'inventory' then
        -- ox_inventory: GetItemCount(inv, itemName) → returns total count
        local count = exports.ox_inventory:GetItemCount(source, Config.MoneySystem.InventoryItemName)
        return (count or 0) >= amount
    elseif Config.MoneySystem.Source == 'banking' then
        -- ox_core: player.getAccount() takes NO param, returns OxAccount object
        -- Use account.get('balance') to read the numeric balance
        local account = player.getAccount()
        if not account then return false end
        local balance = account.get('balance') or 0
        return balance >= amount
    end

    return false
end

---Remove money from player
---@param source number
---@param amount number
---@param reason string|nil
---@return boolean success
function MoneySystem.removeMoney(source, amount, reason)
    local player = Ox.GetPlayer(source)
    if not player then return false end

    local success = false

    if Config.MoneySystem.Source == 'inventory' then
        -- ox_inventory: RemoveItem returns success (boolean), response (string?)
        local ok, _ = exports.ox_inventory:RemoveItem(source, Config.MoneySystem.InventoryItemName, amount)
        success = ok == true
    elseif Config.MoneySystem.Source == 'banking' then
        -- ox_core: account.removeBalance({amount, message}) → {success, message}
        local account = player.getAccount()
        if account then
            local result = account.removeBalance({ amount = amount, message = reason or 'Property Transaction' })
            success = result and result.success == true
        end
    end

    if success and State.debugMode then
        print(('[RDE | IPL] 💰 Money removed: %s - $%d (%s)'):format(player.username, amount, reason or 'Unknown'))
    end

    return success
end

---Add money to player
---@param source number
---@param amount number
---@param reason string|nil
---@return boolean success
function MoneySystem.addMoney(source, amount, reason)
    local player = Ox.GetPlayer(source)
    if not player then return false end

    local success = false

    if Config.MoneySystem.Source == 'inventory' then
        -- ox_inventory: AddItem returns success (boolean), response (string?)
        local ok, _ = exports.ox_inventory:AddItem(source, Config.MoneySystem.InventoryItemName, amount)
        success = ok == true
    elseif Config.MoneySystem.Source == 'banking' then
        -- ox_core: account.addBalance({amount, message}) → {success, message}
        local account = player.getAccount()
        if account then
            local result = account.addBalance({ amount = amount, message = reason or 'Property Transaction' })
            success = result and result.success == true
        end
    end

    if success and State.debugMode then
        print(('[RDE | IPL] 💰 Money added: %s + $%d (%s)'):format(player.username, amount, reason or 'Unknown'))
    end

    return success
end

---Calculate final price with fees/discounts
---@param basePrice number
---@param isSelling boolean
---@return number finalPrice
function MoneySystem.calculatePrice(basePrice, isSelling)
    if isSelling then
        -- Selling: apply discount
        if Config.MoneySystem.EnableSellDiscount then
            local discount = (basePrice * Config.MoneySystem.SellDiscountPercent) / 100
            return math.floor(basePrice - discount)
        end
        return basePrice
    else
        -- Buying: apply fee
        if Config.MoneySystem.EnablePurchaseFee then
            local fee = (basePrice * Config.MoneySystem.PurchaseFeePercent) / 100
            return math.floor(basePrice + fee)
        end
        return basePrice
    end
end

-- ============================================
-- 📊 DATABASE MANAGER (AUTO-CREATE, MIGRATION!)
-- ============================================
local Database = {}

---Initialize database tables
function Database.initialize()
    print('^3[RDE | IPL] 💾 Initializing database...^7')

    -- Create properties table
    MySQL.query.await([[
        CREATE TABLE IF NOT EXISTS `rde_iplproperties` (
            `id` INT(11) NOT NULL AUTO_INCREMENT,
            `instance_id` VARCHAR(64) NOT NULL UNIQUE,
            `ipl_index` INT(11) NOT NULL,
            `owner_identifier` VARCHAR(60) DEFAULT NULL,
            `coords` TEXT NOT NULL,
            `price` INT(11) NOT NULL DEFAULT 100000,
            `for_sale` TINYINT(1) NOT NULL DEFAULT 1,
            `locked` TINYINT(1) NOT NULL DEFAULT 1,
            `customization` TEXT DEFAULT NULL,
            `access_list` TEXT DEFAULT NULL,
            `last_entered` VARCHAR(60) DEFAULT NULL,
            `total_visits` INT(11) NOT NULL DEFAULT 0,
            `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
            PRIMARY KEY (`id`),
            INDEX `idx_owner` (`owner_identifier`),
            INDEX `idx_instance` (`instance_id`),
            INDEX `idx_forsale` (`for_sale`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
    ]])

    -- Create transactions table (for analytics)
    MySQL.query.await([[
        CREATE TABLE IF NOT EXISTS `rde_ipl_transactions` (
            `id` INT(11) NOT NULL AUTO_INCREMENT,
            `instance_id` VARCHAR(64) NOT NULL,
            `buyer_identifier` VARCHAR(60) DEFAULT NULL,
            `seller_identifier` VARCHAR(60) DEFAULT NULL,
            `transaction_type` ENUM('purchase', 'sale', 'transfer') NOT NULL,
            `amount` INT(11) NOT NULL,
            `timestamp` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (`id`),
            INDEX `idx_buyer` (`buyer_identifier`),
            INDEX `idx_seller` (`seller_identifier`),
            INDEX `idx_instance` (`instance_id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
    ]])

    print('^2[RDE | IPL] ✅ Database initialized successfully^7')
end

---Save property to database
---@param property RDE_IPL_Property
---@return boolean success
function Database.saveProperty(property)
    local success = MySQL.query.await(
        'INSERT INTO rde_iplproperties (instance_id, ipl_index, owner_identifier, coords, price, for_sale, locked, customization, access_list, last_entered, total_visits) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?) ON DUPLICATE KEY UPDATE owner_identifier = VALUES(owner_identifier), price = VALUES(price), for_sale = VALUES(for_sale), locked = VALUES(locked), customization = VALUES(customization), access_list = VALUES(access_list), last_entered = VALUES(last_entered), total_visits = VALUES(total_visits)',
        {
            property.instanceId,
            property.iplIndex,
            property.owner,
            json.encode({x = property.coords.x, y = property.coords.y, z = property.coords.z, w = property.coords.w}),
            property.price,
            property.forSale,
            property.locked,
            json.encode(property.customization or {}),
            json.encode(property.accessList or {}),
            property.lastEntered,
            property.totalVisits or 0
        }
    )

    return success ~= nil
end

---Delete property from database
---@param instanceId string
---@return boolean success
function Database.deleteProperty(instanceId)
    -- MySQL.update.await returns affectedRows as a plain number (not a table like MySQL.query.await)
    local affectedRows = MySQL.update.await('DELETE FROM rde_iplproperties WHERE instance_id = ?', {instanceId})
    return type(affectedRows) == 'number' and affectedRows > 0
end

---Log transaction
---@param instanceId string
---@param buyerIdentifier string|nil
---@param sellerIdentifier string|nil
---@param transactionType string
---@param amount number
function Database.logTransaction(instanceId, buyerIdentifier, sellerIdentifier, transactionType, amount)
    MySQL.insert('INSERT INTO rde_ipl_transactions (instance_id, buyer_identifier, seller_identifier, transaction_type, amount) VALUES (?, ?, ?, ?, ?)',
        {instanceId, buyerIdentifier, sellerIdentifier, transactionType, amount})
end

-- ============================================
-- 🌐 ROUTING BUCKET MANAGER (SMART ALLOCATION!)
-- ============================================
local RoutingBuckets = {}

---Allocate a routing bucket
---@return number|nil bucketId
function RoutingBuckets.allocate()
    local startId = Config.RoutingBuckets.StartBucketId
    local maxBuckets = Config.RoutingBuckets.MaxBuckets

    -- Find first available bucket
    for i = startId, startId + maxBuckets - 1 do
        if not State.routingBuckets[i] then
            State.routingBuckets[i] = {
                used = true,
                assignedAt = os.time(),
                instanceId = nil
            }
            if State.debugMode then
                print(('[RDE | IPL] 🌐 Bucket allocated: %d'):format(i))
            end
            return i
        end
    end

    -- No buckets available
    print('^3[RDE | IPL] ⚠️ No routing buckets available!^7')
    return nil
end

---Free a routing bucket
---@param bucketId number
function RoutingBuckets.free(bucketId)
    if State.routingBuckets[bucketId] then
        State.routingBuckets[bucketId] = nil
        if State.debugMode then
            print(('[RDE | IPL] 🌐 Bucket freed: %d'):format(bucketId))
        end
    end
end

---Get bucket statistics
---@return table stats
function RoutingBuckets.getStats()
    local used = 0
    for _ in pairs(State.routingBuckets) do
        used = used + 1
    end

    return {
        used = used,
        total = Config.RoutingBuckets.MaxBuckets,
        available = Config.RoutingBuckets.MaxBuckets - used
    }
end

-- ============================================
-- 🏠 PROPERTY MANAGER (CORE LOGIC!)
-- ============================================
local PropertyManager = {}

---Create a new property
---@param iplIndex number
---@param coords vector4
---@param price number
---@param forSale boolean
---@return string|nil instanceId
function PropertyManager.create(iplIndex, coords, price, forSale)
    local iplData = Config.IPLDatabase[iplIndex]
    if not iplData then return nil end

    -- Generate unique instance ID (timestamp + random suffix to avoid same-second collisions)
    local instanceId = ('ipl_%s_%d_%04x'):format(iplData.id, os.time(), math.random(0, 65535))

    local property = {
        id = 0, -- Will be set by database
        iplIndex = iplIndex,
        owner = nil,
        coords = coords,
        price = price,
        forSale = forSale,
        locked = Config.Property.LockByDefault,
        instanceId = instanceId,
        customization = {},
        accessList = {},
        lastEntered = nil,
        totalVisits = 0,
        createdAt = os.time(),
        updatedAt = os.time()
    }

    -- Save to database
    if not Database.saveProperty(property) then
        print('^1[RDE | IPL] ❌ Failed to save property to database^7')
        return nil
    end

    -- Add to state
    State.properties[instanceId] = property

    if State.debugMode then
        print(('[RDE | IPL] ✅ Property created: %s (%s)'):format(iplData.name, instanceId))
    end

    return instanceId
end

---Update property
---@param instanceId string
---@param updates table
---@return boolean success
function PropertyManager.update(instanceId, updates)
    local property = State.properties[instanceId]
    if not property then return false end

    -- Apply updates
    for key, value in pairs(updates) do
        property[key] = value
    end

    property.updatedAt = os.time()

    -- Save to database
    if not Database.saveProperty(property) then
        return false
    end

    if State.debugMode then
        print(('[RDE | IPL] ✅ Property updated: %s'):format(instanceId))
    end

    return true
end

---Delete property
---@param instanceId string
---@return boolean success
function PropertyManager.delete(instanceId)
    local property = State.properties[instanceId]
    if not property then return false end

    -- Delete from database
    if not Database.deleteProperty(instanceId) then
        return false
    end

    -- Remove from owner list
    if property.owner and State.propertyOwners[property.owner] then
        for i, id in ipairs(State.propertyOwners[property.owner]) do
            if id == instanceId then
                table.remove(State.propertyOwners[property.owner], i)
                break
            end
        end
    end

    -- Remove from state
    State.properties[instanceId] = nil

    if State.debugMode then
        print(('[RDE | IPL] 🗑️ Property deleted: %s'):format(instanceId))
    end

    return true
end

---Purchase property
---@param source number
---@param instanceId string
---@return boolean success
---@return string|nil errorMsg
function PropertyManager.purchase(source, instanceId)
    local player = Ox.GetPlayer(source)
    if not player then return false, 'Player not found' end

    local property = State.properties[instanceId]
    if not property then return false, L('invalid_property') end
    if not property.forSale then return false, 'Property not for sale' end
    if property.owner then return false, 'Property already owned' end

    local identifier = player.identifier

    -- Check max properties
    local ownedCount = 0
    if State.propertyOwners[identifier] then
        ownedCount = #State.propertyOwners[identifier]
    end

    if ownedCount >= Config.Property.MaxPropertiesPerPlayer then
        return false, L('max_properties_reached', ownedCount, Config.Property.MaxPropertiesPerPlayer)
    end

    -- Calculate final price
    local finalPrice = MoneySystem.calculatePrice(property.price, false)

    -- Check money
    if not MoneySystem.hasMoney(source, finalPrice) then
        return false, L('not_enough_money', finalPrice)
    end

    -- Remove money
    if not MoneySystem.removeMoney(source, finalPrice, 'Property Purchase: ' .. instanceId) then
        return false, 'Failed to remove money'
    end

    -- Update property
    property.owner = identifier
    property.forSale = false
    property.updatedAt = os.time()

    -- Save to database
    Database.saveProperty(property)

    -- Update owner list
    State.propertyOwners[identifier] = State.propertyOwners[identifier] or {}
    table.insert(State.propertyOwners[identifier], instanceId)

    -- Log transaction
    Database.logTransaction(instanceId, identifier, nil, 'purchase', finalPrice)

    -- Update metrics
    State.performanceMetrics.successfulPurchases = State.performanceMetrics.successfulPurchases + 1
    State.performanceMetrics.totalTransactions   = State.performanceMetrics.totalTransactions + 1
    State.performanceMetrics.totalRevenue        = State.performanceMetrics.totalRevenue + finalPrice

    -- Log to Nostr
    local iplData = Config.IPLDatabase[property.iplIndex]
    RDELog.purchase(player, instanceId, iplData and iplData.name or instanceId, finalPrice)

    if State.debugMode then
        print(('[RDE | IPL] Property purchased: %s by %s for $%d'):format(instanceId, player.username, finalPrice))
    end

    return true
end

---Sell property
---@param source number
---@param instanceId string
---@return boolean success
---@return string|nil errorMsg
function PropertyManager.sell(source, instanceId)
    if not Config.Property.AllowPropertySale then
        return false, 'Property sales are disabled'
    end

    local player = Ox.GetPlayer(source)
    if not player then return false, 'Player not found' end

    local property = State.properties[instanceId]
    if not property then return false, L('invalid_property') end

    local identifier = player.identifier
    if property.owner ~= identifier then
        return false, L('not_owner')
    end

    -- Calculate sale price
    local salePrice = MoneySystem.calculatePrice(property.price, true)

    -- Add money
    if not MoneySystem.addMoney(source, salePrice, 'Property Sale: ' .. instanceId) then
        return false, 'Failed to add money'
    end

    -- Update property
    property.owner = nil
    property.forSale = true
    property.locked = true
    property.accessList = {}
    property.updatedAt = os.time()

    -- Save to database
    Database.saveProperty(property)

    -- Update owner list
    if State.propertyOwners[identifier] then
        for i, id in ipairs(State.propertyOwners[identifier]) do
            if id == instanceId then
                table.remove(State.propertyOwners[identifier], i)
                break
            end
        end
    end

    -- Log transaction
    Database.logTransaction(instanceId, nil, identifier, 'sale', salePrice)

    -- Update metrics
    State.performanceMetrics.totalTransactions = State.performanceMetrics.totalTransactions + 1
    State.performanceMetrics.totalRevenue      = State.performanceMetrics.totalRevenue + salePrice

    -- Log to Nostr
    local iplData = Config.IPLDatabase[property.iplIndex]
    RDELog.sale(player, instanceId, iplData and iplData.name or instanceId, salePrice)

    if State.debugMode then
        print(('[RDE | IPL] Property sold: %s by %s for $%d'):format(instanceId, player.username, salePrice))
    end

    return true
end

-- ============================================
-- 🌐 INSTANCE MANAGER (ROUTING BUCKETS + PLAYERS!)
-- ============================================
local InstanceManager = {}

---Create property instance
---@param instanceId string
---@param source number
---@return boolean success
---@return number|nil bucketId
function InstanceManager.create(instanceId, source)
    local property = State.properties[instanceId]
    if not property then return false, nil end

    local iplData = Config.IPLDatabase[property.iplIndex]
    if not iplData then return false, nil end

    -- Check if instance already exists
    if State.activeInstances[instanceId] then
        return true, State.activeInstances[instanceId].routingBucket
    end

    -- Allocate routing bucket
    local bucketId = RoutingBuckets.allocate()
    if not bucketId then return false, nil end

    -- Create instance
    local instance = {
        instanceId = instanceId,
        propertyId = property.id,
        iplIndex = property.iplIndex,
        coords = property.coords,
        routingBucket = bucketId,
        players = {},
        created = os.time(),
        lastActivity = os.time(),
        customization = property.customization or {},
        iplData = iplData
    }

    State.activeInstances[instanceId] = instance
    State.routingBuckets[bucketId].instanceId = instanceId

    -- Update metrics
    State.performanceMetrics.instancesCreated = State.performanceMetrics.instancesCreated + 1
    local currentInstances = 0
    for _ in pairs(State.activeInstances) do currentInstances = currentInstances + 1 end
    if currentInstances > State.performanceMetrics.peakConcurrentInstances then
        State.performanceMetrics.peakConcurrentInstances = currentInstances
    end

    if State.debugMode then
        print(('[RDE | IPL] 🌐 Instance created: %s (Bucket: %d)'):format(instanceId, bucketId))
    end

    return true, bucketId
end

---Add player to instance
---@param source number
---@param instanceId string
---@return boolean success
function InstanceManager.addPlayer(source, instanceId)
    local instance = State.activeInstances[instanceId]
    if not instance then return false end

    local property = State.properties[instanceId]
    if not property then return false end

    local player = Ox.GetPlayer(source)
    if not player then return false end

    -- Check capacity
    local currentPlayers = 0
    for _ in pairs(instance.players) do currentPlayers = currentPlayers + 1 end

    if currentPlayers >= instance.iplData.maxOccupancy then
        return false
    end

    -- Add player
    instance.players[source] = {
        joined = os.time(),
        source = source,
        identifier = player.identifier,
        name = player.username
    }

    State.playerInstances[source] = instanceId
    instance.lastActivity = os.time()

    -- Update property visit stats
    property.lastEntered = player.identifier
    property.totalVisits = (property.totalVisits or 0) + 1
    property.updatedAt = os.time()
    Database.saveProperty(property)

    -- Set routing bucket
    SetPlayerRoutingBucket(source, instance.routingBucket)

    -- Update metrics
    State.performanceMetrics.playersServed = State.performanceMetrics.playersServed + 1

    if State.debugMode then
        print(('[RDE | IPL] 👤 Player entered: %s → %s (Bucket: %d)'):format(player.username, instanceId, instance.routingBucket))
    end

    return true
end

---Remove player from instance
---@param source number
---@return boolean success
function InstanceManager.removePlayer(source)
    local instanceId = State.playerInstances[source]
    if not instanceId then return false end

    local instance = State.activeInstances[instanceId]
    if not instance then return false end

    -- Remove player
    instance.players[source] = nil
    State.playerInstances[source] = nil

    -- Reset routing bucket
    SetPlayerRoutingBucket(source, Config.RoutingBuckets.DefaultBucket)

    instance.lastActivity = os.time()

    if State.debugMode then
        print(('[RDE | IPL] 👤 Player exited: Source %d from %s'):format(source, instanceId))
    end

    -- Check if instance is now empty
    local isEmpty = true
    for _ in pairs(instance.players) do
        isEmpty = false
        break
    end

    if isEmpty and Config.RoutingBuckets.AutoCleanup then
        -- Schedule cleanup - but ALWAYS re-check emptiness when the timer fires,
        -- because a new player may have entered before the timeout expires
        SetTimeout(Config.Property.AutoCleanupTime * 1000, function()
            local activeInstance = State.activeInstances[instanceId]
            if not activeInstance then return end -- already destroyed

            local stillEmpty = true
            for _ in pairs(activeInstance.players) do
                stillEmpty = false
                break
            end

            if stillEmpty then
                InstanceManager.destroy(instanceId)
            end
        end)
    end

    return true
end

---Destroy instance
---@param instanceId string
function InstanceManager.destroy(instanceId)
    local instance = State.activeInstances[instanceId]
    if not instance then return end

    -- Kick all players
    for source, _ in pairs(instance.players) do
        if GetPlayerPing(source) > 0 then
            SetPlayerRoutingBucket(source, Config.RoutingBuckets.DefaultBucket)
            TriggerClientEvent('rde_ipl:client:exitInstance', source)
            State.playerInstances[source] = nil
        end
    end

    -- Free routing bucket
    RoutingBuckets.free(instance.routingBucket)

    -- Remove instance
    State.activeInstances[instanceId] = nil

    -- Update metrics
    State.performanceMetrics.instancesDestroyed = State.performanceMetrics.instancesDestroyed + 1
    local duration = os.time() - instance.created
    local avgDuration = State.performanceMetrics.averageInstanceDuration
    State.performanceMetrics.averageInstanceDuration = (avgDuration + duration) / 2

    if State.debugMode then
        print(('[RDE | IPL] 🌐 Instance destroyed: %s (Duration: %ds)'):format(instanceId, duration))
    end
end

---Cleanup empty instances
function InstanceManager.cleanup()
    local now = os.time()
    local cleaned = 0

    for instanceId, instance in pairs(State.activeInstances) do
        local isEmpty = true
        for _ in pairs(instance.players) do
            isEmpty = false
            break
        end

        if isEmpty and (now - instance.lastActivity) >= Config.Property.AutoCleanupTime then
            InstanceManager.destroy(instanceId)
            cleaned = cleaned + 1
        end
    end

    if cleaned > 0 and State.debugMode then
        print(('[RDE | IPL] 🧹 Cleaned up %d empty instances'):format(cleaned))
    end
end

-- ============================================
-- 📡 STATEBAG SYNC (100% COVERAGE!)
-- ============================================
local function SyncAllProperties()
    GlobalState.rde_ipl_properties = State.properties
    -- Broadcast zone + blip refresh to all clients so map markers and
    -- ox_target zones update immediately after buy/sell/create/delete.
    -- Without this, other clients only see changes on their next init.
    TriggerClientEvent('rde_ipl:client:refreshZones', -1)
    if State.debugMode then
        local count = 0
        for _ in pairs(State.properties) do count = count + 1 end
        print(('[RDE | IPL] 📡 Synced %d properties to GlobalState + refreshZones broadcast'):format(count))
    end
end

local function SyncProperty(instanceId)
    local property = State.properties[instanceId]
    if not property then return end

    -- Update global state
    local properties = GlobalState.rde_ipl_properties or {}
    properties[instanceId] = property
    GlobalState.rde_ipl_properties = properties
end

-- ============================================
-- 🎮 SERVER EVENTS (PLAYER ACTIONS!)
-- ============================================

---Request admin status
RegisterNetEvent('rde_ipl:server:requestAdminStatus', function()
    local src = source
    local isAdmin = AdminSystem.isAdmin(src)
    TriggerClientEvent('rde_ipl:client:receiveAdminStatus', src, isAdmin)
end)

---Enter property
RegisterNetEvent('rde_ipl:server:enterProperty', function(instanceId)
    local src = source
    
    -- Rate limiting
    local allowed, errorMsg = RateLimit.check(src, 'enter_property', 3, 10000)
    if not allowed then
        Notify(src, L('warning'), errorMsg, 'warning', 'alert-circle', '#f59e0b')
        return
    end
    
    local player = Ox.GetPlayer(src)
    if not player then return end
    
    local property = State.properties[instanceId]
    if not property then
        Notify(src, L('error'), L('invalid_property'), 'error', 'x-circle', '#ef4444')
        return
    end
    
    -- Check if already in a property
    if State.playerInstances[src] then
        Notify(src, L('warning'), L('already_in_property'), 'warning', 'alert-circle', '#f59e0b')
        return
    end
    
    -- Check if locked and player has access
    local identifier = player.identifier
    local hasAccess = false
    
    if not property.locked then
        hasAccess = true
    elseif property.owner == identifier then
        hasAccess = true
    elseif property.accessList then
        for _, allowedId in ipairs(property.accessList) do
            if allowedId == identifier then
                hasAccess = true
                break
            end
        end
    end
    
    if not hasAccess then
        Notify(src, L('error'), L('property_locked_error'), 'error', 'lock', '#ef4444')
        return
    end
    
    -- Create or get instance
    local success, bucketId = InstanceManager.create(instanceId, src)
    if not success then
        Notify(src, L('error'), 'Failed to create instance', 'error', 'x-circle', '#ef4444')
        return
    end
    
    -- Check capacity
    local instance = State.activeInstances[instanceId]
    local currentPlayers = 0
    for _ in pairs(instance.players) do currentPlayers = currentPlayers + 1 end
    
    if currentPlayers >= instance.iplData.maxOccupancy then
        Notify(src, L('error'), L('instance_full', currentPlayers, instance.iplData.maxOccupancy), 'error', 'users', '#ef4444')
        return
    end
    
    -- Add player to instance
    if not InstanceManager.addPlayer(src, instanceId) then
        Notify(src, L('error'), 'Failed to enter property', 'error', 'x-circle', '#ef4444')
        return
    end
    
    -- Get IPL data
    local iplData = Config.IPLDatabase[property.iplIndex]

    -- Trigger client to enter
    TriggerClientEvent('rde_ipl:client:enterInstance', src, instanceId, bucketId, iplData, property.customization)

    -- Log to Nostr
    RDELog.enter(player, instanceId, iplData and iplData.name or instanceId, bucketId)

    -- Notify success (icon fixed: house, not home)
    Notify(src, L('success'), L('property_entered', iplData.name), 'success', 'house', '#10b981')
end)

---Exit property
RegisterNetEvent('rde_ipl:server:exitProperty', function()
    local src = source
    
    if not State.playerInstances[src] then
        Notify(src, L('warning'), L('not_in_property'), 'warning', 'alert-circle', '#f59e0b')
        return
    end

    local instanceId = State.playerInstances[src]
    local property   = State.properties[instanceId]
    local player     = Ox.GetPlayer(src)

    -- Remove player from instance
    if InstanceManager.removePlayer(src) then
        TriggerClientEvent('rde_ipl:client:exitInstance', src)

        -- Log to Nostr
        if player and property then
            local iplData = Config.IPLDatabase[property.iplIndex]
            RDELog.exit(player, instanceId, iplData and iplData.name or instanceId)
        end
        -- NOTE: property_exited notification is shown client-side in
        -- rde_ipl:client:exitInstance after the teleport completes.
        -- Notifying here too caused a duplicate notification (fixed in v1.0.1).
    end
end)

---Buy property
RegisterNetEvent('rde_ipl:server:buyProperty', function(instanceId)
    local src = source
    
    -- Rate limiting
    local allowed, errorMsg = RateLimit.check(src, 'buy_property', 2, 60000)
    if not allowed then
        Notify(src, L('warning'), errorMsg, 'warning', 'alert-circle', '#f59e0b')
        return
    end
    
    local player = Ox.GetPlayer(src)
    if not player then return end
    
    -- Attempt purchase
    local success, error = PropertyManager.purchase(src, instanceId)
    
    if success then
        local property = State.properties[instanceId]
        local iplData = Config.IPLDatabase[property.iplIndex]
        local finalPrice = MoneySystem.calculatePrice(property.price, false)
        
        Notify(src, L('success'), L('property_purchased', finalPrice), 'success', 'home', '#10b981', 7000)
        
        -- Sync properties
        SyncAllProperties()
        
        -- Notify all players
        NotifyAll(
            'Property Sold!',
            ('%s has purchased %s'):format(player.username, iplData.name),
            'info',
            'home'
        )
    else
        Notify(src, L('error'), error, 'error', 'x-circle', '#ef4444')
        State.performanceMetrics.failedPurchases = State.performanceMetrics.failedPurchases + 1
    end
end)

---Sell property
RegisterNetEvent('rde_ipl:server:sellProperty', function(instanceId)
    local src = source
    
    -- Rate limiting
    local allowed, errorMsg = RateLimit.check(src, 'sell_property', 2, 60000)
    if not allowed then
        Notify(src, L('warning'), errorMsg, 'warning', 'alert-circle', '#f59e0b')
        return
    end
    
    local player = Ox.GetPlayer(src)
    if not player then return end
    
    -- Attempt sale
    local success, error = PropertyManager.sell(src, instanceId)
    
    if success then
        local property = State.properties[instanceId]
        local salePrice = MoneySystem.calculatePrice(property.price, true)
        
        Notify(src, L('success'), L('property_sold', salePrice), 'success', 'dollar-sign', '#10b981', 7000)
        
        -- Sync properties
        SyncAllProperties()
    else
        Notify(src, L('error'), error, 'error', 'x-circle', '#ef4444')
    end
end)

---Toggle lock
RegisterNetEvent('rde_ipl:server:toggleLock', function(instanceId)
    local src = source
    local player = Ox.GetPlayer(src)
    if not player then return end
    
    local property = State.properties[instanceId]
    if not property then
        Notify(src, L('error'), L('invalid_property'), 'error', 'x-circle', '#ef4444')
        return
    end
    
    local identifier = player.identifier
    if property.owner ~= identifier and not AdminSystem.isAdmin(src) then
        RDELog.securityViolation(src, 'toggle_lock', instanceId)
        Notify(src, L('error'), L('no_permission'), 'error', 'shield-off', '#ef4444')
        return
    end

    -- Toggle lock
    property.locked = not property.locked
    property.updatedAt = os.time()
    Database.saveProperty(property)
    SyncProperty(instanceId)

    -- Log to Nostr
    RDELog.lockToggle(player, instanceId, property.locked)

    local status = property.locked and L('property_locked') or L('property_unlocked')
    local icon   = property.locked and 'lock' or 'lock-open'
    Notify(src, L('success'), status, 'success', icon, '#10b981')
end)

---Apply customization
RegisterNetEvent('rde_ipl:server:applyCustomization', function(instanceId, customType, customId)
    local src = source
    local player = Ox.GetPlayer(src)
    if not player then return end
    
    local property = State.properties[instanceId]
    if not property then return end
    
    local identifier = player.identifier
    if property.owner ~= identifier and not AdminSystem.isAdmin(src) then
        RDELog.securityViolation(src, 'apply_customization', instanceId)
        Notify(src, L('error'), L('no_permission'), 'error', 'shield-off', '#ef4444')
        return
    end

    -- Update customization
    property.customization[customType] = customId
    property.updatedAt = os.time()
    Database.saveProperty(property)
    
    -- Update active instance if exists
    if State.activeInstances[instanceId] then
        State.activeInstances[instanceId].customization = property.customization
    end
    
    -- Apply to all players in instance
    if State.activeInstances[instanceId] then
        for playerSource, _ in pairs(State.activeInstances[instanceId].players) do
            TriggerClientEvent('rde_ipl:client:applyCustomization', playerSource, customType, customId)
        end
    end
    
    Notify(src, L('success'), L('customization_applied', customType), 'success', 'palette', '#10b981')
end)

---Request player properties
RegisterNetEvent('rde_ipl:server:requestPlayerProperties', function()
    local src = source
    local player = Ox.GetPlayer(src)
    if not player then return end
    
    local identifier = player.identifier
    local playerProperties = {}
    
    if State.propertyOwners[identifier] then
        for _, instanceId in ipairs(State.propertyOwners[identifier]) do
            local property = State.properties[instanceId]
            if property then
                local iplData = Config.IPLDatabase[property.iplIndex]
                table.insert(playerProperties, {
                    instanceId = instanceId,
                    name = iplData.name,
                    category = iplData.category,
                    price = property.price,
                    locked = property.locked,
                    coords = property.coords,
                    totalVisits = property.totalVisits or 0,
                    iplData = iplData
                })
            end
        end
    end
    
    TriggerClientEvent('rde_ipl:client:receivePlayerProperties', src, playerProperties)
end)

-- ============================================
-- 👑 ADMIN EVENTS (MANAGEMENT!)
-- ============================================

---Admin: Create property
RegisterNetEvent('rde_ipl:server:admin:createProperty', function(iplIndex, coords, price)
    local src = source

    if not AdminSystem.isAdmin(src) then
        RDELog.securityViolation(src, 'admin_create_property', 'iplIndex:' .. tostring(iplIndex))
        Notify(src, L('error'), L('admin_only'), 'error', 'shield-off', '#ef4444')
        return
    end
    
    local instanceId = PropertyManager.create(iplIndex, coords, price, true)
    if instanceId then
        SyncAllProperties()

        -- Log to Nostr
        local admin  = Ox.GetPlayer(src)
        local ipl    = Config.IPLDatabase[iplIndex]
        if admin then
            RDELog.createProperty(admin, instanceId, ipl and ipl.name or tostring(iplIndex), price)
        end

        Notify(src, L('success'), L('property_created'), 'success', 'circle-plus', '#10b981')
    else
        Notify(src, L('error'), 'Failed to create property', 'error', 'x-circle', '#ef4444')
    end
end)

---Admin: Delete property
RegisterNetEvent('rde_ipl:server:admin:deleteProperty', function(instanceId)
    local src = source

    if not AdminSystem.isAdmin(src) then
        RDELog.securityViolation(src, 'admin_delete_property', instanceId)
        Notify(src, L('error'), L('admin_only'), 'error', 'shield-off', '#ef4444')
        return
    end
    
    -- Kick all players from instance
    if State.activeInstances[instanceId] then
        InstanceManager.destroy(instanceId)
    end

    local property = State.properties[instanceId]  -- grab before delete
    if PropertyManager.delete(instanceId) then
        SyncAllProperties()

        -- Log to Nostr
        local admin = Ox.GetPlayer(src)
        if admin then
            local ipl = property and Config.IPLDatabase[property.iplIndex]
            RDELog.deleteProperty(admin, instanceId, ipl and ipl.name or instanceId)
        end

        Notify(src, L('success'), L('property_deleted'), 'success', 'trash-2', '#10b981')
    else
        Notify(src, L('error'), 'Failed to delete property', 'error', 'x-circle', '#ef4444')
    end
end)

---Admin: Update property
RegisterNetEvent('rde_ipl:server:admin:updateProperty', function(instanceId, updates)
    local src = source

    if not AdminSystem.isAdmin(src) then
        RDELog.securityViolation(src, 'admin_update_property', instanceId)
        Notify(src, L('error'), L('admin_only'), 'error', 'shield-off', '#ef4444')
        return
    end
    
    if PropertyManager.update(instanceId, updates) then
        SyncAllProperties()

        -- Log to Nostr
        local admin = Ox.GetPlayer(src)
        if admin then
            local detail = json.encode(updates)
            RDELog.adminAction(admin, 'update_property', instanceId, detail)
        end

        Notify(src, L('success'), L('property_updated'), 'success', 'check-circle', '#10b981')
    else
        Notify(src, L('error'), 'Failed to update property', 'error', 'x-circle', '#ef4444')
    end
end)

---Admin: Teleport to property
RegisterNetEvent('rde_ipl:server:admin:teleport', function(instanceId)
    local src = source

    if not AdminSystem.isAdmin(src) then
        RDELog.securityViolation(src, 'admin_teleport', instanceId)
        Notify(src, L('error'), L('admin_only'), 'error', 'shield-off', '#ef4444')
        return
    end

    local property = State.properties[instanceId]
    if not property then return end

    -- Log to Nostr
    local admin = Ox.GetPlayer(src)
    if admin then
        RDELog.adminAction(admin, 'teleport_to_property', instanceId)
    end

    -- Use property.coords (where the admin placed it) when valid; fall back to
    -- iplData.coords if the property coords ended up corrupted somehow.
    local target = property.coords
    if not target or (math.abs(target.x) < 0.01 and math.abs(target.y) < 0.01) then
        local iplData = Config.IPLDatabase[property.iplIndex]
        if iplData and iplData.coords then
            target = iplData.coords
        end
    end

    if not target then
        Notify(src, L('error'), 'Property has no usable coords', 'error', 'triangle-alert', '#ef4444')
        return
    end

    TriggerClientEvent('rde_ipl:client:admin:teleport', src, target)
    Notify(src, L('info'), L('teleporting'), 'info', 'map-pin', '#3b82f6')
end)

---Admin: Get statistics
RegisterNetEvent('rde_ipl:server:admin:getStatistics', function()
    local src = source
    
    if not AdminSystem.isAdmin(src) then return end
    
    local totalProperties = 0
    local forSaleCount = 0
    local ownedCount = 0
    local totalValue = 0
    local activeInstancesCount = 0
    local totalPlayersInProperties = 0
    
    for _, property in pairs(State.properties) do
        totalProperties = totalProperties + 1
        if property.forSale then
            forSaleCount = forSaleCount + 1
        else
            ownedCount = ownedCount + 1
        end
        totalValue = totalValue + property.price
    end
    
    for _, instance in pairs(State.activeInstances) do
        activeInstancesCount = activeInstancesCount + 1
        for _ in pairs(instance.players) do
            totalPlayersInProperties = totalPlayersInProperties + 1
        end
    end
    
    local bucketStats = RoutingBuckets.getStats()
    
    local stats = {
        totalProperties = totalProperties,
        forSale = forSaleCount,
        owned = ownedCount,
        totalValue = totalValue,
        activeInstances = activeInstancesCount,
        playersInProperties = totalPlayersInProperties,
        buckets = bucketStats,
        metrics = State.performanceMetrics,
        iplCount = GetTotalIPLCount(),
        iplByCategory = GetIPLCategoryCount()
    }
    
    TriggerClientEvent('rde_ipl:client:admin:receiveStatistics', src, stats)
end)

-- ============================================
-- 💬 COMMANDS (PLAYER & ADMIN!)
-- ============================================

-- NOTE: /myproperties and /exitproperty are handled exclusively via
-- client-side RegisterCommand + server-side RegisterNetEvent.
-- lib.addCommand was removed to prevent double execution (client fires
-- TriggerServerEvent; server lib.addCommand was also responding directly,
-- causing the client to receive receivePlayerProperties / exitInstance twice).

---Admin: IPL menu
lib.addCommand('ipl', {
    help = 'Open IPL admin menu',
    restricted = false
}, function(source, args, raw)
    if not AdminSystem.isAdmin(source) then
        RDELog.securityViolation(source, 'open_admin_menu_cmd', nil)
        Notify(source, L('error'), L('admin_only'), 'error', 'shield-off', '#ef4444')
        return
    end

    local admin = Ox.GetPlayer(source)
    if admin then
        RDELog.adminAction(admin, 'open_admin_menu', 'command:/ipl', nil)
    end

    -- Trigger client to open admin menu
    TriggerClientEvent('rde_ipl:client:openAdminMenu', source)
end)

-- ============================================
-- 🔌 PLAYER DISCONNECT (CLEANUP!)
-- ============================================
AddEventHandler('playerDropped', function(reason)
    local src = source

    -- Log forced exit if they were in a property
    local instanceId = State.playerInstances[src]
    if instanceId then
        local player   = Ox.GetPlayer(src)
        local property = State.properties[instanceId]
        if player and property then
            local iplData = Config.IPLDatabase[property.iplIndex]
            RDELog.custom('warn',
                ('DISCONNECT IN PROPERTY | %s dropped from [%s] reason: %s'):format(
                    player.username, iplData and iplData.name or instanceId, reason or 'unknown'),
                {
                    {'event',       'disconnect_in_property'},
                    {'identifier',  player.identifier},
                    {'player',      player.username},
                    {'instance_id', instanceId},
                    {'reason',      reason or 'unknown'},
                }
            )
        end
    end

    -- Remove from instance
    InstanceManager.removePlayer(src)

    -- Clean up rate limits
    local player = Ox.GetPlayer(src)
    if player then
        local identifier = player.identifier
        if identifier then
            for key in pairs(State.rateLimits) do
                if key:find(identifier) then
                    State.rateLimits[key] = nil
                end
            end
        end
    end
end)

-- ============================================
-- ⏰ BACKGROUND THREADS (AUTO-CLEANUP!)
-- ============================================

---Instance cleanup thread
CreateThread(function()
    while true do
        Wait(Config.RoutingBuckets.CleanupInterval * 1000)
        
        if Config.RoutingBuckets.AutoCleanup then
            InstanceManager.cleanup()
        end
        
        -- Clean up expired rate limits
        local now = os.time() * 1000
        for key, data in pairs(State.rateLimits) do
            if now >= data.resetAt then
                State.rateLimits[key] = nil
            end
        end
    end
end)

---Auto-save thread
CreateThread(function()
    while true do
        Wait(Config.Property.SaveIntervalSeconds * 1000)
        
        if State.debugMode then
            print('[RDE | IPL] 💾 Auto-saving all properties...')
        end
        
        for _, property in pairs(State.properties) do
            Database.saveProperty(property)
        end
    end
end)

---Debug metrics thread
if Config.Statebag.Debug then
    CreateThread(function()
        while true do
            Wait(60000) -- Every minute
            
            local bucketStats = RoutingBuckets.getStats()
            local activeInstances = 0
            local totalPlayers = 0
            
            for _, instance in pairs(State.activeInstances) do
                activeInstances = activeInstances + 1
                for _ in pairs(instance.players) do
                    totalPlayers = totalPlayers + 1
                end
            end
            
            local propertyCount = 0
            for _ in pairs(State.properties) do propertyCount = propertyCount + 1 end
            
            print('^2[RDE | IPL] 📊 Performance Report:^7')
            print(('  Properties: %d | Active Instances: %d | Players: %d'):format(
                propertyCount,
                activeInstances,
                totalPlayers
            ))
            print(('  Routing Buckets: %d/%d used'):format(
                bucketStats.used,
                bucketStats.total
            ))
            print(('  Transactions: %d | Purchases: %d success / %d failed'):format(
                State.performanceMetrics.totalTransactions,
                State.performanceMetrics.successfulPurchases,
                State.performanceMetrics.failedPurchases
            ))
            print(('  Instances: %d created | %d destroyed | Peak: %d'):format(
                State.performanceMetrics.instancesCreated,
                State.performanceMetrics.instancesDestroyed,
                State.performanceMetrics.peakConcurrentInstances
            ))
            print(('  Revenue: $%d | Players Served: %d'):format(
                State.performanceMetrics.totalRevenue,
                State.performanceMetrics.playersServed
            ))
        end
    end)
end

-- ============================================
-- 🎬 INITIALIZATION (STARTUP!)
-- ============================================
-- MySQL.ready fires once the DB connection is established.
-- The inner CreateThread gives us a proper coroutine so .await calls work.
MySQL.ready(function()
    CreateThread(function()
        print('^3[RDE | IPL] 🚀 Initializing...^7')
        
        -- Initialize database
        Database.initialize()
        Wait(500)
    
    -- Load all properties from database
    local properties = MySQL.query.await('SELECT * FROM rde_iplproperties', {})
    
    if properties and #properties > 0 then
        for _, prop in ipairs(properties) do
            local coords = json.decode(prop.coords)
            
            State.properties[prop.instance_id] = {
                id = prop.id,
                iplIndex = prop.ipl_index,
                owner = prop.owner_identifier,
                coords = vector4(coords.x, coords.y, coords.z, coords.w or 0.0),
                price = prop.price,
                forSale = prop.for_sale == 1,
                locked = prop.locked == 1,
                instanceId = prop.instance_id,
                customization = json.decode(prop.customization) or {},
                accessList = json.decode(prop.access_list) or {},
                lastEntered = prop.last_entered,
                totalVisits = prop.total_visits or 0,
                createdAt = prop.created_at and os.time() or os.time(),
                updatedAt = prop.updated_at and os.time() or os.time()
            }
            
            -- Build owner index
            if prop.owner_identifier then
                State.propertyOwners[prop.owner_identifier] = State.propertyOwners[prop.owner_identifier] or {}
                table.insert(State.propertyOwners[prop.owner_identifier], prop.instance_id)
            end
        end
    end
    
    -- Sync to clients
    SyncAllProperties()

    -- ─── IPL coord validator (v1.1) ──────────────────────────────────────
    -- Catches the two most common config bugs that drop players into the void:
    --   1. coords and exitCoords identical (= teleporting to the same outside marker)
    --   2. coords near (0,0,0) (= "I forgot to set this", lands under the ocean)
    -- We don't fail the boot — we warn loudly. The client refuses to teleport
    -- when it sees these, so no player gets dropped into the void.
    local function _isValidCoordSrv(v)
        if not v then return false end
        if type(v.x) ~= 'number' or type(v.y) ~= 'number' or type(v.z) ~= 'number' then
            return false
        end
        if math.abs(v.x) < 0.01 and math.abs(v.y) < 0.01 and math.abs(v.z) < 0.01 then
            return false
        end
        return true
    end

    local _coordIssues = { invalid = {}, identical = {} }
    for dbIdx, ipl in ipairs(Config.IPLDatabase) do
        if not _isValidCoordSrv(ipl.coords) then
            table.insert(_coordIssues.invalid, { idx = dbIdx, id = ipl.id, name = ipl.name })
        end
        if ipl.coords and ipl.exitCoords
           and math.abs(ipl.coords.x - ipl.exitCoords.x) < 0.01
           and math.abs(ipl.coords.y - ipl.exitCoords.y) < 0.01
           and math.abs(ipl.coords.z - ipl.exitCoords.z) < 0.01 then
            table.insert(_coordIssues.identical, { idx = dbIdx, id = ipl.id, name = ipl.name })
        end
    end

    if #_coordIssues.invalid > 0 then
        print(('^1[RDE | IPL] ⚠ %d IPL entries have INVALID coords (nil or near 0,0,0):^7'):format(#_coordIssues.invalid))
        for _, e in ipairs(_coordIssues.invalid) do
            print(('^1  [%d] %s — %s^7'):format(e.idx, e.id or '?', e.name or '?'))
        end
    end
    if #_coordIssues.identical > 0 then
        print(('^3[RDE | IPL] ⚠ %d IPL entries have IDENTICAL coords and exitCoords^7'):format(#_coordIssues.identical))
        print('^3  → These will teleport players to the same position on enter AND exit.^7')
        print('^3  → Set coords = interior spawn, exitCoords = outside marker.^7')
        for i, e in ipairs(_coordIssues.identical) do
            if i <= 10 then
                print(('^3  [%d] %s — %s^7'):format(e.idx, e.id or '?', e.name or '?'))
            end
        end
        if #_coordIssues.identical > 10 then
            print(('^3  ... and %d more^7'):format(#_coordIssues.identical - 10))
        end
    end
    -- ─────────────────────────────────────────────────────────────────────

    -- Count admin methods
    local adminMethods = 0
    if Config.AdminSystem.acePermission then adminMethods = adminMethods + 1 end
    if Config.AdminSystem.steamIds and #Config.AdminSystem.steamIds > 0 then adminMethods = adminMethods + 1 end
    if Config.AdminSystem.oxGroups and next(Config.AdminSystem.oxGroups) then adminMethods = adminMethods + 1 end

    local propertyCount = 0
    for _ in pairs(State.properties) do propertyCount = propertyCount + 1 end

    local iplCount = GetTotalIPLCount()

    -- Startup banner
    print('^2╔═══════════════════════════════════════════════════════════╗^7')
    print('^2║  RDE | IPL MANAGER v1.0.1-alpha - SERVER READY                    ║^7')
    print('^2║  Interior exit target + per-IPL map blip definitions      ║^7')
    print('^2╠═══════════════════════════════════════════════════════════╣^7')
    print(('^2║  📦 IPLs Available: ^3%-3d^2 | Properties: ^3%-4d^2       ║^7'):format(iplCount, propertyCount))
    print(('^2║  🛡️  Admin Methods: ^3%-1d^2   | Money: ^3%-11s^2         ║^7'):format(adminMethods, Config.MoneySystem.Source))
    print(('^2║  🌍 Language: ^3%-4s^2    | Debug: ^3%-3s^2               ║^7'):format(
        Config.DefaultLanguage:upper(),
        State.debugMode and 'ON' or 'OFF'
    ))
    print(('^2║  🔧 Config issues: ^3%-2d invalid^2 / ^3%-2d identical^2     ║^7'):format(
        #_coordIssues.invalid, #_coordIssues.identical
    ))
    print('^2╠═══════════════════════════════════════════════════════════╣^7')
    print('^2║  Features: Statebag-First, Triple Admin, Collision-Safe   ║^7')
    print('^2║  By RDE | SerpentsByte                                    ║^7')
    print('^2╚═══════════════════════════════════════════════════════════╝^7')
    
    if adminMethods == 0 then
        print('^3⚠️  WARNING: No admin methods configured! Edit config.lua^7')
    end
    
    if State.debugMode then
        print('^2[RDE | IPL]^7 Debug mode enabled - performance metrics active')
        print('^2[RDE | IPL]^7 IPL Categories:')
        local categories = GetIPLCategoryCount()
        for category, count in pairs(categories) do
            print(('  • %s: %d'):format(category, count))
        end
    end
    
    State.initialized = true

    -- Log startup to Nostr
    RDELog.custom('info', '🐉 RDE IPL Manager v1.0.1-alpha ONLINE | System ready', {
        {'event',   'server_startup'},
        {'version', '1.0.1'},
        {'config_invalid_coords',   tostring(#_coordIssues.invalid)},
        {'config_identical_coords', tostring(#_coordIssues.identical)},
    })

    print('^2[RDE | IPL] System fully initialized and ready!^7')
    end) -- end inner CreateThread
end) -- end MySQL.ready

-- ============================================
-- 🧹 CLEANUP (RESOURCE STOP!)
-- ============================================
AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    
    print('^3[RDE | IPL] 💾 Shutting down...^7')
    
    -- Save all properties
    for _, property in pairs(State.properties) do
        Database.saveProperty(property)
    end
    
    -- Kick all players from instances
    for source, instanceId in pairs(State.playerInstances) do
        if GetPlayerPing(source) > 0 then
            SetPlayerRoutingBucket(source, Config.RoutingBuckets.DefaultBucket)
            TriggerClientEvent('rde_ipl:client:exitInstance', source)
        end
    end
    
    -- Destroy all instances
    for instanceId, _ in pairs(State.activeInstances) do
        InstanceManager.destroy(instanceId)
    end
    
    -- Free all routing buckets
    for bucketId, _ in pairs(State.routingBuckets) do
        RoutingBuckets.free(bucketId)
    end
    
    local propertyCount = 0
    for _ in pairs(State.properties) do propertyCount = propertyCount + 1 end

    -- Log shutdown to Nostr
    RDELog.custom('warn', ('🛑 RDE IPL Manager v1.0.1-alpha SHUTDOWN | %d properties | %d transactions | $%d revenue'):format(
        propertyCount,
        State.performanceMetrics.totalTransactions,
        State.performanceMetrics.totalRevenue),
        { {'event', 'server_shutdown'} }
    )

    print('^2╔═══════════════════════════════════════════════════════════╗^7')
    print('^2║  RDE | IPL MANAGER v1.0.1-alpha - SHUTDOWN COMPLETE               ║^7')
    print(('^2║  Final Stats: %d properties | %d transactions            ║^7'):format(
        propertyCount,
        State.performanceMetrics.totalTransactions
    ))
    print(('^2║  Total Revenue: $%d | Players Served: %d                 ║^7'):format(
        State.performanceMetrics.totalRevenue,
        State.performanceMetrics.playersServed
    ))
    print('^2╚═══════════════════════════════════════════════════════════╝^7')
end)

-- ============================================
-- 📤 EXPORTS (FOR OTHER RESOURCES!)
-- ============================================

---Get property by instance ID
---@param instanceId string
---@return table|nil property
exports('GetProperty', function(instanceId)
    return State.properties[instanceId]
end)

---Get all properties
---@return table properties
exports('GetAllProperties', function()
    return State.properties
end)

---Get properties owned by identifier
---@param identifier string
---@return table properties
exports('GetPlayerProperties', function(identifier)
    local props = {}
    if State.propertyOwners[identifier] then
        for _, instanceId in ipairs(State.propertyOwners[identifier]) do
            local property = State.properties[instanceId]
            if property then
                table.insert(props, property)
            end
        end
    end
    return props
end)

---Check if player is in property
---@param source number
---@return boolean inProperty
---@return string|nil instanceId
exports('IsPlayerInProperty', function(source)
    local instanceId = State.playerInstances[source]
    return instanceId ~= nil, instanceId
end)

---Get active instance
---@param instanceId string
---@return table|nil instance
exports('GetActiveInstance', function(instanceId)
    return State.activeInstances[instanceId]
end)

---Force evict player
---@param source number
---@return boolean success
exports('EvictPlayer', function(source)
    return InstanceManager.removePlayer(source)
end)

---Get server statistics
---@return table stats
exports('GetStatistics', function()
    return State.performanceMetrics
end)
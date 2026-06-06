-- ╔═══════════════════════════════════════════════════════════╗
-- ║  RDE | IPL MANAGER v1.3 - ULTIMATE CONFIG                 ║
-- ║  Author: RDE | SerpentsByte                               ║
-- ║  100+ Native GTA IPLs + ALL DLC Shells Support            ║
-- ║  Full Localization | Triple Admin | Dual Money System     ║
-- ║  COORDS CORRECTED from bob74_ipl v2.6.0                   ║
-- ║  Interior exit target added                               ║
-- ║  Per-IPL blip sprite/color/scale                          ║
-- ╚═══════════════════════════════════════════════════════════╝

Config = {}

-- ============================================
-- 🌐 LOCALIZATION SYSTEM (EN + DE)
-- ============================================
Config.DefaultLanguage = 'en' -- Options: 'en', 'de'

Config.Languages = {
    en = {
        success = '✅ Success',
        error = '❌ Error',
        warning = '⚠️ Warning',
        info = 'ℹ️ Information',
        enter_property = 'Enter Property',
        exit_property = 'Exit Property',
        buy_property = 'Buy for $%s',
        sell_property = 'Sell Property',
        lock_property = 'Lock Property',
        unlock_property = 'Unlock Property',
        customize_property = 'Customize Interior',
        manage_property = 'Manage Property',
        invite_player = 'Invite Player',
        kick_player = 'Kick Player',
        transfer_ownership = 'Transfer Ownership',
        admin_menu = '👑 Admin Control Panel',
        player_menu = '🏠 My Properties',
        property_list = '📋 All Properties',
        create_property = '➕ Create Property',
        edit_property = '⚙️ Edit Property',
        delete_property = '🗑️ Delete Property',
        statistics = '📊 Server Statistics',
        customization = '🎨 Customization',
        access_control = '🔐 Access Control',
        property_entered = '🚪 Entered: %s',
        property_exited = '🚪 Exited property',
        property_locked = '🔒 Property locked',
        property_unlocked = '🔓 Property unlocked',
        property_purchased = '💰 Property purchased for $%s',
        property_sold = '💵 Property sold for $%s',
        property_created = '✅ Property created successfully',
        property_updated = '✅ Property updated',
        property_deleted = '🗑️ Property deleted',
        customization_applied = '🎨 Customization applied: %s',
        player_invited = '👥 %s has been invited',
        player_kicked = '🚫 %s has been kicked',
        ownership_transferred = '🔄 Ownership transferred to %s',
        no_permission = '🚫 You do not have permission',
        not_enough_money = '💸 Not enough money (Need: $%s)',
        property_locked_error = '🔒 This property is locked',
        max_properties_reached = '🏠 Maximum properties owned (%s/%s)',
        already_in_property = '⚠️ You are already in a property',
        not_in_property = '⚠️ You are not in a property',
        instance_full = '🚫 Property is full (%s/%s)',
        invalid_property = '❌ Invalid property',
        player_not_found = '❌ Player not found',
        already_owner = '⚠️ You already own this property',
        not_owner = '⚠️ You are not the owner',
        press_to_interact = '[E] Interact with property',
        processing = '⏳ Processing...',
        loading_property = '⏳ Loading property...',
        saving_data = '💾 Saving data...',
        teleporting = '📍 Teleporting...',
        total_properties = '🏢 Total Properties',
        properties_for_sale = '🟡 For Sale',
        owned_properties = '🟢 Owned',
        total_value = '💰 Total Value',
        active_instances = '🌐 Active Instances',
        players_in_properties = '👥 Players Inside',
        admin_only = '👑 Admin Only',
        teleport_to_property = '📍 Teleport',
        change_price = '💰 Change Price',
        toggle_for_sale = '🔄 Toggle For Sale',
        force_evict = '🚫 Force Evict All',
        delete_confirm = '⚠️ Are you sure you want to delete this property?',
        evict_confirm = '⚠️ Evict all players from this property?',
        current_price = 'Current Price: $%s',
        new_price = 'New Price',
        sale_price = 'Sale Price: $%s',
        purchase_fee = 'Purchase Fee: $%s',
        select_theme = 'Select Theme',
        select_wall_style = 'Select Wall Style',
        select_floor_style = 'Select Floor Style',
        select_furniture = 'Select Furniture',
        preview_changes = 'Preview Changes',
        apply_changes = 'Apply Changes',
        reset_defaults = 'Reset to Defaults',
        owner_access = 'Owner',
        guest_access = 'Guest',
        blocked_access = 'Blocked',
        add_to_access = 'Add to Access List',
        remove_from_access = 'Remove from Access List',
        select_property_type = 'Select Property Type',
        apartment = '🏢 Apartment',
        house = '🏠 House',
        mansion = '🏛️ Mansion',
        garage = '🚗 Garage',
        warehouse = '📦 Warehouse',
        office = '💼 Office',
        bunker = '🏗️ Bunker',
        facility = '🏭 Facility',
        nightclub = '🎭 Nightclub',
        arcade = '🎮 Arcade',
        casino = '🎰 Casino',
        carmeet = '🚗 Car Meet',
        heist = '💰 Heist',
        business = '📊 Business',
        restaurant = '🍔 Restaurant',
        police = '👮 Police',
        prison = '⛓️ Prison',
        hospital = '🏥 Hospital',
        stripclub = '💃 Strip Club',
        yacht = '⛵ Yacht',
        ship = '🚢 Ship',
        compound = '🏝️ Compound',
        special = '🌟 Special',
        event = '🎉 Event',
        hidden = '🕵️ Hidden',
        for_sale = 'For Sale',
        owned = 'Owned',
        locked = 'Locked',
        unlocked = 'Unlocked',
        occupied = 'Occupied',
        vacant = 'Vacant',
        money_source_inventory = '💰 Money from Inventory (Item)',
        money_source_banking = '💳 Money from Bank Account',
        confirm = 'Confirm',
        cancel = 'Cancel',
        back = 'Back',
        close = 'Close',
        save = 'Save',
        delete = 'Delete',
        edit = 'Edit',
        view = 'View',
        next = 'Next',
        previous = 'Previous',
        tip_exit = 'Look at the exit marker or use /exitproperty',
        tip_lock = 'Lock your property to keep it secure',
        tip_customize = 'Customize your interior in the property menu',
        tip_invite = 'Invite friends using the access control menu'
    },
    de = {
        success = '✅ Erfolg',
        error = '❌ Fehler',
        warning = '⚠️ Warnung',
        info = 'ℹ️ Information',
        enter_property = 'Betreten',
        exit_property = 'Verlassen',
        buy_property = 'Kaufen für $%s',
        sell_property = 'Verkaufen',
        lock_property = 'Abschließen',
        unlock_property = 'Aufschließen',
        customize_property = 'Innenausstattung anpassen',
        manage_property = 'Verwalten',
        invite_player = 'Spieler einladen',
        kick_player = 'Spieler rauswerfen',
        transfer_ownership = 'Eigentum übertragen',
        admin_menu = '👑 Admin Kontrollzentrum',
        player_menu = '🏠 Meine Immobilien',
        property_list = '📋 Alle Immobilien',
        create_property = '➕ Immobilie erstellen',
        edit_property = '⚙️ Immobilie bearbeiten',
        delete_property = '🗑️ Immobilie löschen',
        statistics = '📊 Server Statistiken',
        customization = '🎨 Anpassung',
        access_control = '🔐 Zugangskontrolle',
        property_entered = '🚪 Betreten: %s',
        property_exited = '🚪 Immobilie verlassen',
        property_locked = '🔒 Immobilie abgeschlossen',
        property_unlocked = '🔓 Immobilie aufgeschlossen',
        property_purchased = '💰 Immobilie gekauft für $%s',
        property_sold = '💵 Immobilie verkauft für $%s',
        property_created = '✅ Immobilie erfolgreich erstellt',
        property_updated = '✅ Immobilie aktualisiert',
        property_deleted = '🗑️ Immobilie gelöscht',
        customization_applied = '🎨 Anpassung angewendet: %s',
        player_invited = '👥 %s wurde eingeladen',
        player_kicked = '🚫 %s wurde rausgeworfen',
        ownership_transferred = '🔄 Eigentum übertragen an %s',
        no_permission = '🚫 Keine Berechtigung',
        not_enough_money = '💸 Nicht genug Geld (Benötigt: $%s)',
        property_locked_error = '🔒 Diese Immobilie ist abgeschlossen',
        max_properties_reached = '🏠 Maximale Anzahl erreicht (%s/%s)',
        already_in_property = '⚠️ Du bist bereits in einer Immobilie',
        not_in_property = '⚠️ Du bist nicht in einer Immobilie',
        instance_full = '🚫 Immobilie ist voll (%s/%s)',
        invalid_property = '❌ Ungültige Immobilie',
        player_not_found = '❌ Spieler nicht gefunden',
        already_owner = '⚠️ Du besitzt diese Immobilie bereits',
        not_owner = '⚠️ Du bist nicht der Eigentümer',
        press_to_interact = '[E] Mit Immobilie interagieren',
        processing = '⏳ Verarbeite...',
        loading_property = '⏳ Lade Immobilie...',
        saving_data = '💾 Speichere Daten...',
        teleporting = '📍 Teleportiere...',
        total_properties = '🏢 Immobilien Gesamt',
        properties_for_sale = '🟡 Zum Verkauf',
        owned_properties = '🟢 Im Besitz',
        total_value = '💰 Gesamtwert',
        active_instances = '🌐 Aktive Instanzen',
        players_in_properties = '👥 Spieler drinnen',
        admin_only = '👑 Nur für Admins',
        teleport_to_property = '📍 Teleportieren',
        change_price = '💰 Preis ändern',
        toggle_for_sale = '🔄 Verkaufsstatus ändern',
        force_evict = '🚫 Alle rauswerfen',
        delete_confirm = '⚠️ Möchtest du diese Immobilie wirklich löschen?',
        evict_confirm = '⚠️ Alle Spieler aus dieser Immobilie werfen?',
        current_price = 'Aktueller Preis: $%s',
        new_price = 'Neuer Preis',
        sale_price = 'Verkaufspreis: $%s',
        purchase_fee = 'Kaufgebühr: $%s',
        select_theme = 'Thema wählen',
        select_wall_style = 'Wandstil wählen',
        select_floor_style = 'Bodenstil wählen',
        select_furniture = 'Möbel wählen',
        preview_changes = 'Änderungen Vorschau',
        apply_changes = 'Änderungen anwenden',
        reset_defaults = 'Auf Standard zurücksetzen',
        owner_access = 'Eigentümer',
        guest_access = 'Gast',
        blocked_access = 'Blockiert',
        add_to_access = 'Zur Zugangsliste hinzufügen',
        remove_from_access = 'Von Zugangsliste entfernen',
        select_property_type = 'Immobilientyp wählen',
        apartment = '🏢 Apartment',
        house = '🏠 Haus',
        mansion = '🏛️ Villa',
        garage = '🚗 Garage',
        warehouse = '📦 Lagerhaus',
        office = '💼 Büro',
        bunker = '🏗️ Bunker',
        facility = '🏭 Anlage',
        nightclub = '🎭 Nachtclub',
        arcade = '🎮 Arcade',
        casino = '🎰 Casino',
        carmeet = '🚗 Car Meet',
        heist = '💰 Raub',
        business = '📊 Geschäft',
        restaurant = '🍔 Restaurant',
        police = '👮 Polizei',
        prison = '⛓️ Gefängnis',
        hospital = '🏥 Krankenhaus',
        stripclub = '💃 Stripclub',
        yacht = '⛵ Yacht',
        ship = '🚢 Schiff',
        compound = '🏝️ Anwesen',
        special = '🌟 Besonderes',
        event = '🎉 Event',
        hidden = '🕵️ Versteckt',
        for_sale = 'Zum Verkauf',
        owned = 'Im Besitz',
        locked = 'Abgeschlossen',
        unlocked = 'Aufgeschlossen',
        occupied = 'Belegt',
        vacant = 'Frei',
        money_source_inventory = '💰 Geld aus Inventar (Item)',
        money_source_banking = '💳 Geld vom Bankkonto',
        confirm = 'Bestätigen',
        cancel = 'Abbrechen',
        back = 'Zurück',
        close = 'Schließen',
        save = 'Speichern',
        delete = 'Löschen',
        edit = 'Bearbeiten',
        view = 'Ansehen',
        next = 'Weiter',
        previous = 'Zurück',
        tip_exit = 'Schau auf den Exit-Marker oder nutze /exitproperty',
        tip_lock = 'Schließe deine Immobilie ab für Sicherheit',
        tip_customize = 'Passe dein Interieur im Menü an',
        tip_invite = 'Lade Freunde über die Zugangskontrolle ein'
    }
}

function GetLanguageString(key, ...)
    local lang = Config.Languages[Config.DefaultLanguage]
    local str = lang[key] or key
    if ... then return string.format(str, ...) end
    return str
end

-- ============================================
-- 🔐 TRIPLE ADMIN VERIFICATION SYSTEM
-- ============================================
Config.AdminSystem = {
    acePermission = 'rde.ipl.admin',
    steamIds = {
        'steam:110000101605859',
    },
    oxGroups = {
        ['owner'] = 0,
        ['admin'] = 0,
        ['superadmin'] = 0
    },
    checkOrder = {'ace', 'oxcore', 'steam'}
}

-- ============================================
-- 💰 MONEY SYSTEM CONFIGURATION
-- ============================================
Config.MoneySystem = {
    Source = 'inventory',
    InventoryItemName = 'money',
    BankingAccount = 'bank',
    EnablePurchaseFee = false,
    PurchaseFeePercent = 5,
    EnableSellDiscount = true,
    SellDiscountPercent = 10
}

-- ============================================
-- 🏠 PROPERTY SYSTEM CONFIGURATION
-- ============================================
Config.Property = {
    MaxPropertiesPerPlayer = 5,
    AllowPropertySale = true,
    EnablePropertyRent = false,
    DefaultRentPrice = 500,
    RentPaymentInterval = 86400,
    EnterTime = 2000,
    ExitTime = 1500,
    InteractionDistance = 3.0,
    -- v1.2: Interior exit target zone (added next to player's spawn point inside)
    InteriorExitRadius = 1.5,
    RequireKeyToEnter = false,
    LockByDefault = true,
    MaxPlayersPerInstance = 8,
    AutoCleanupTime = 300,
    SaveIntervalSeconds = 300,
    ShowForSaleBlips = true,
    ShowOwnedBlips = true,
    ShowPropertyNames = true,
    EnableCustomization = true,
    ShowPropertyStats = true,
    EnableAccessControl = true,
    ShowOccupancyCount = true
}

-- ============================================
-- 🌐 ROUTING BUCKET CONFIGURATION
-- ============================================
Config.RoutingBuckets = {
    DefaultBucket = 0,
    StartBucketId = 1000,
    MaxBuckets = 1000,
    AutoCleanup = true,
    CleanupInterval = 300,
    PopulationEnabled = false,
    LockToOwner = false
}

-- ============================================
-- 📡 STATEBAG CONFIGURATION
-- ============================================
Config.Statebag = {
    Debug = false,
    SyncInterval = 1000,
    EnableReplication = true,
    BatchUpdates = true
}

-- ============================================
-- 🎨 BLIP & MARKER CONFIGURATION
-- ============================================
Config.BlipColors = {
    forSale = 5,
    owned = 2,
    locked = 1,
    admin = 84
}

Config.BlipSprites = {
    apartment = 475,
    house = 40,
    mansion = 374,
    garage = 50,
    warehouse = 473,
    office = 475,
    bunker = 557,
    facility = 569,
    nightclub = 614,
    arcade = 740,
    casino = 679,
    carmeet = 762,
    heist = 486,
    business = 475,
    restaurant = 93,
    police = 60,
    prison = 188,
    hospital = 61,
    stripclub = 121,
    yacht = 455,
    ship = 455,
    compound = 374,
    special = 478,
    event = 304,
    hidden = 486,
    default = 40
}

-- ============================================
-- ⚡ PERFORMANCE & OPTIMIZATION
-- ============================================
Config.Performance = {
    EnablePerformanceMetrics = true,
    LogSlowQueries = true,
    SlowQueryThreshold = 100,
    EnableRateLimiting = true,
    RateLimitWindow = 60000,
    RateLimitMax = 10,
    OptimizeBlipUpdates = true,
    CacheIPLData = true
}

-- ============================================
-- 🎯 IPL DATABASE — Koordinaten aus bob74_ipl v2.6.0
-- ============================================
-- LEGENDE:
--   coords           = Interior-Spawnpunkt (wo du NACH dem Betreten erscheinst)
--   exitCoords       = Exterior-Marker    (wo du NACH dem Verlassen erscheinst)
--   interiorExit     = OPTIONAL: ox_target Exit-Sphere im Interior, falls woanders
--                      als coords. Default: coords selbst. vector3 oder vector4.
--   interiorExitRadius = OPTIONAL: Radius der Exit-Sphere. Default:
--                        Config.Property.InteriorExitRadius (1.5)
--   blip             = OPTIONAL pro IPL Map-Blip. Schema:
--                          { sprite = <int>, color = <int>, scale = <float> }
--                      • Sprite-IDs: https://docs.fivem.net/docs/game-references/blips/
--                      • Color-IDs : 0=white 1=red 2=green 3=blue 4=lightblue
--                                    5=yellow 6=lightyellow 22=darkgrey 25=pink
--                                    27=purple 29=lightpink 38=darkblue 47=brown
--                      • Wenn nicht gesetzt → Fallback auf Config.BlipSprites[category]
--                        und Config.BlipColors.forSale / .owned
--                      • blip = false → kein Blip rendern
-- coords und exitCoords dürfen NIE identisch sein!
-- ============================================
Config.IPLDatabase = {

    -- ========== 🏢 ECLIPSE TOWER SUITES (Exec & Other Criminals DLC) ==========
    -- bob74_ipl Referenz:
    --   ExecApartment1 (_a) = -787.7805, 334.9232, 215.8384  → Suite 1 (Top Floor)
    --   ExecApartment2 (_b) = -773.2258, 322.8252, 194.8862  → Suite 3 (Lower Floor)
    --   ExecApartment3 (_c) = -787.7805, 334.9232, 186.1134  → Suite 2 (Mid Floor)
    {
        id = 'eclipse_suite_1',
        name = 'Eclipse Tower Suite 1 (Top Floor)',
        category = 'apartment',
        price = 400000,
        ipl = {'apa_v_mp_h_01_a'},
        coords     = vector4(-787.7805, 334.9232, 215.8384, 96.0),
        exitCoords = vector4(-781.85,   341.96,   211.30,   354.0),
        maxOccupancy = 8,
        customizable = true,
        blip         = { sprite = 475, color = 2, scale = 0.85 },
        customization = {
            theme = {
                {name = 'Modern',     ipl = 'apa_v_mp_h_01_a'},
                {name = 'Mody',       ipl = 'apa_v_mp_h_02_a'},
                {name = 'Vibrant',    ipl = 'apa_v_mp_h_03_a'},
                {name = 'Sharp',      ipl = 'apa_v_mp_h_04_a'},
                {name = 'Monochrome', ipl = 'apa_v_mp_h_05_a'},
                {name = 'Seductive',  ipl = 'apa_v_mp_h_06_a'},
                {name = 'Regal',      ipl = 'apa_v_mp_h_07_a'},
                {name = 'Aqua',       ipl = 'apa_v_mp_h_08_a'}
            }
        },
        description = 'Top-floor penthouse suite in Eclipse Towers with selectable themes'
    },
    {
        id = 'eclipse_suite_2',
        name = 'Eclipse Tower Suite 2 (Mid Floor)',
        category = 'apartment',
        price = 380000,
        ipl = {'apa_v_mp_h_01_c'},
        coords     = vector4(-787.7805, 334.9232, 186.1134, 178.0),
        exitCoords = vector4(-779.81,   315.51,   187.30,   270.0),
        maxOccupancy = 8,
        customizable = true,
        blip         = { sprite = 475, color = 2, scale = 0.85 },
        customization = {
            theme = {
                {name = 'Modern',     ipl = 'apa_v_mp_h_01_c'},
                {name = 'Mody',       ipl = 'apa_v_mp_h_02_c'},
                {name = 'Vibrant',    ipl = 'apa_v_mp_h_03_c'},
                {name = 'Sharp',      ipl = 'apa_v_mp_h_04_c'},
                {name = 'Monochrome', ipl = 'apa_v_mp_h_05_c'},
                {name = 'Seductive',  ipl = 'apa_v_mp_h_06_c'},
                {name = 'Regal',      ipl = 'apa_v_mp_h_07_c'},
                {name = 'Aqua',       ipl = 'apa_v_mp_h_08_c'}
            }
        },
        description = 'Mid-floor suite in Eclipse Towers with selectable themes'
    },
    {
        id = 'eclipse_suite_3',
        name = 'Eclipse Tower Suite 3 (Lower Floor)',
        category = 'apartment',
        price = 350000,
        ipl = {'apa_v_mp_h_01_b'},
        coords     = vector4(-773.2258, 322.8252, 194.8862, 92.0),
        exitCoords = vector4(-770.21,   343.61,   196.30,   250.0),
        maxOccupancy = 8,
        customizable = true,
        blip         = { sprite = 475, color = 2, scale = 0.85 },
        customization = {
            theme = {
                {name = 'Modern',     ipl = 'apa_v_mp_h_01_b'},
                {name = 'Mody',       ipl = 'apa_v_mp_h_02_b'},
                {name = 'Vibrant',    ipl = 'apa_v_mp_h_03_b'},
                {name = 'Sharp',      ipl = 'apa_v_mp_h_04_b'},
                {name = 'Monochrome', ipl = 'apa_v_mp_h_05_b'},
                {name = 'Seductive',  ipl = 'apa_v_mp_h_06_b'},
                {name = 'Regal',      ipl = 'apa_v_mp_h_07_b'},
                {name = 'Aqua',       ipl = 'apa_v_mp_h_08_b'}
            }
        },
        description = 'Lower-floor suite in Eclipse Towers with selectable themes'
    },

    -- ========== 🏢 PENTHOUSE (Casino DLC) ==========
    {
        id = 'casino_penthouse',
        name = 'Diamond Casino Penthouse',
        category = 'apartment',
        price = 1500000,
        ipl = {'vw_casino_penthouse'},
        coords     = vector4(976.636, 70.295, 115.164, 60.0),
        exitCoords = vector4(942.5,   55.0,   81.0,   240.0),
        maxOccupancy = 10,
        customizable = true,
        blip         = { sprite = 679, color = 5, scale = 0.9 },
        customization = {
            theme = {
                {name = 'Modern', ipl = 'vw_casino_penthouse'},
                {name = 'Luxury', ipl = 'vw_casino_penthouse_luxury'}
            },
            extras = {
                {name = 'Party Area', ipl = 'vw_casino_penthouse_party'},
                {name = 'Office',     ipl = 'vw_casino_penthouse_office'},
                {name = 'Garage',     ipl = 'vw_casino_penthouse_garage'}
            }
        },
        description = 'Ultra-luxury penthouse atop the Diamond Casino'
    },

    -- ========== 🏠 HÄUSER & MANSIONS ==========
    {
        id = 'franklins_house',
        name = "Franklin's House (Vinewood Hills)",
        category = 'house',
        price = 750000,
        ipl = {'franklins_house'},
        coords     = vector4(-14.0,  -1440.0, 31.0, 180.0),
        exitCoords = vector4(-14.0,  -1452.0, 31.0,   0.0),
        maxOccupancy = 6,
        customizable = false,
        blip         = { sprite = 40, color = 2, scale = 0.85 },
        description = "Franklin's luxurious hillside residence"
    },
    {
        id = 'michaels_house',
        name = "Michael's House (Rockford Hills)",
        category = 'mansion',
        price = 1200000,
        ipl = {'michael_house'},
        coords     = vector4(-802.311, 175.056, 72.8446, 200.0),
        exitCoords = vector4(-795.0,   179.0,   72.0,    20.0),
        maxOccupancy = 8,
        customizable = false,
        blip         = { sprite = 40, color = 5, scale = 0.9 },
        description = 'Upscale family home in exclusive neighborhood'
    },
    {
        id = 'trevors_trailer',
        name = "Trevor's Trailer (Sandy Shores)",
        category = 'house',
        price = 45000,
        ipl = {'trevorstrailer'},
        coords     = vector4(1985.481, 3828.768, 32.5, 30.0),
        exitCoords = vector4(1970.0,   3818.0,   32.5, 210.0),
        maxOccupancy = 2,
        customizable = false,
        blip         = { sprite = 479, color = 47, scale = 0.75 },
        description = "Trevor's... unique living situation"
    },
    {
        id = 'stilt_apartment_1',
        name = 'Stilt Apartment (3655 Wild Oats Drive)',
        category = 'mansion',
        price = 2000000,
        ipl = {'apa_v_mp_h_07_a'},
        coords     = vector4(-169.286, 486.494, 137.444, 190.0),
        exitCoords = vector4(-165.0,   500.0,   137.0,    10.0),
        maxOccupancy = 10,
        customizable = true,
        blip         = { sprite = 40, color = 5, scale = 0.9 },
        customization = {
            theme = {
                {name = 'Modern',       ipl = 'apa_v_mp_h_07_a'},
                {name = 'Contemporary', ipl = 'apa_v_mp_h_07_b'},
                {name = 'Elegant',      ipl = 'apa_v_mp_h_07_c'}
            }
        },
        description = 'Exclusive hillside mansion with panoramic views'
    },
    {
        id = 'stilt_apartment_2',
        name = 'Stilt Apartment (2044 North Conker Avenue)',
        category = 'mansion',
        price = 2100000,
        ipl = {'apa_v_mp_h_08_a'},
        coords     = vector4(340.941, 437.180, 149.393, 190.0),
        exitCoords = vector4(346.0,   449.0,   150.0,    10.0),
        maxOccupancy = 10,
        customizable = true,
        blip         = { sprite = 40, color = 5, scale = 0.9 },
        customization = {
            theme = {
                {name = 'Modern',  ipl = 'apa_v_mp_h_08_a'},
                {name = 'Vibrant', ipl = 'apa_v_mp_h_08_b'},
                {name = 'Sharp',   ipl = 'apa_v_mp_h_08_c'}
            }
        },
        description = 'Premier luxury residence in Vinewood Hills'
    },

    -- ========== 🚗 GARAGEN ==========
    {
        id = 'garage_low_1',
        name = '2-Car Garage (Unit 124 Popular St)',
        category = 'garage',
        price = 50000,
        ipl = {'hei_prop_heist_cheetah'},
        coords     = vector4(179.0,  -1001.0, -99.0, 180.0),
        exitCoords = vector4(179.0,  -989.0,  -99.0,   0.0),
        maxOccupancy = 4,
        customizable = false,
        blip         = { sprite = 357, color = 4, scale = 0.8 },
        description = 'Basic 2-car underground garage'
    },
    {
        id = 'garage_mid_1',
        name = '6-Car Garage (Unit 1 Tinsel Towers)',
        category = 'garage',
        price = 120000,
        ipl = {'hei_prop_heist_apart_garage'},
        coords     = vector4(240.0,  -1005.0, -99.0, 180.0),
        exitCoords = vector4(240.0,  -993.0,  -99.0,   0.0),
        maxOccupancy = 6,
        customizable = false,
        blip         = { sprite = 357, color = 4, scale = 0.8 },
        description = 'Spacious 6-car garage with workbench'
    },
    {
        id = 'garage_high_1',
        name = '10-Car Garage (Eclipse Towers)',
        category = 'garage',
        price = 250000,
        ipl = {'hei_prop_heist_apart_garage_high'},
        coords     = vector4(240.0,  -1004.0, -99.0, 180.0),
        exitCoords = vector4(240.0,  -992.0,  -99.0,   0.0),
        maxOccupancy = 8,
        customizable = false,
        blip         = { sprite = 357, color = 5, scale = 0.85 },
        description = 'Premium 10-car collector garage'
    },

    -- ========== 💼 EXECUTIVE OFFICES (Finance & Felony DLC) ==========
    {
        id = 'office_maze_bank',
        name = 'Maze Bank Tower Office',
        category = 'office',
        price = 4000000,
        ipl = {'ex_dt1_02_office_01a'},
        coords     = vector4(-75.847,  -826.989, 243.386, 160.0),
        exitCoords = vector4(-70.0,    -810.0,   243.0,   340.0),
        maxOccupancy = 10,
        customizable = true,
        blip         = { sprite = 475, color = 5, scale = 0.9 },
        customization = {
            theme = {
                {name = 'Modern',       ipl = 'ex_dt1_02_office_01a'},
                {name = 'Power',        ipl = 'ex_dt1_02_office_01b'},
                {name = 'Conservative', ipl = 'ex_dt1_02_office_01c'}
            },
            extras = {
                {name = 'Cash',  ipl = 'ex_dt1_02_office_cash'},
                {name = 'Weed',  ipl = 'ex_dt1_02_office_weed'},
                {name = 'Safe',  ipl = 'ex_dt1_02_office_safe'}
            }
        },
        description = 'Iconic office at the top of Maze Bank Tower'
    },
    {
        id = 'office_arcadius',
        name = 'Arcadius Business Center Office',
        category = 'office',
        price = 2500000,
        ipl = {'ex_dt1_02_office_02a'},
        coords     = vector4(-141.199, -620.913, 168.821, 70.0),
        exitCoords = vector4(-156.0,   -602.0,   168.6,  250.0),
        maxOccupancy = 10,
        customizable = true,
        blip         = { sprite = 475, color = 27, scale = 0.85 },
        customization = {
            theme = {
                {name = 'Modern',    ipl = 'ex_dt1_02_office_02a'},
                {name = 'Warm',      ipl = 'ex_dt1_02_office_02b'},
                {name = 'Executive', ipl = 'ex_dt1_02_office_02c'}
            }
        },
        description = 'Premium office space in downtown Los Santos'
    },
    {
        id = 'office_lombank',
        name = 'Lombank West Office',
        category = 'office',
        price = 3100000,
        ipl = {'ex_dt1_02_office_03a'},
        coords     = vector4(-1579.756, -565.066, 108.523, 220.0),
        exitCoords = vector4(-1570.0,   -552.0,   108.5,    40.0),
        maxOccupancy = 10,
        customizable = true,
        blip         = { sprite = 475, color = 5, scale = 0.85 },
        customization = {
            theme = {
                {name = 'Modern',   ipl = 'ex_dt1_02_office_03a'},
                {name = 'Contrast', ipl = 'ex_dt1_02_office_03b'},
                {name = 'Rich',     ipl = 'ex_dt1_02_office_03c'}
            }
        },
        description = 'Prestigious office with Del Perro views'
    },
    {
        id = 'office_maze_bank_west',
        name = 'Maze Bank West Office',
        category = 'office',
        price = 1000000,
        ipl = {'ex_dt1_02_office_04a'},
        coords     = vector4(-1392.667, -480.474, 72.042, 100.0),
        exitCoords = vector4(-1380.0,   -471.0,   72.0,   280.0),
        maxOccupancy = 8,
        customizable = true,
        blip         = { sprite = 475, color = 27, scale = 0.8 },
        customization = {
            theme = {
                {name = 'Modern',  ipl = 'ex_dt1_02_office_04a'},
                {name = 'Vintage', ipl = 'ex_dt1_02_office_04b'},
                {name = 'Vibrant', ipl = 'ex_dt1_02_office_04c'}
            }
        },
        description = 'Affordable office space for starting executives'
    },

    -- ========== 📦 WAREHOUSES (CEO) ==========
    {
        id = 'warehouse_small_1',
        name = 'Small Warehouse (Cypress Flats)',
        category = 'warehouse',
        price = 250000,
        ipl = {'ex_dt1_02_warehouse_small'},
        coords     = vector4(994.593,  -3002.594, -39.647, 0.0),
        exitCoords = vector4(994.5,    -2991.0,   -39.6,  180.0),
        maxOccupancy = 6,
        customizable = false,
        blip         = { sprite = 473, color = 4, scale = 0.8 },
        description = 'Compact storage facility for small cargo operations'
    },
    {
        id = 'warehouse_medium_1',
        name = 'Medium Warehouse (El Burro Heights)',
        category = 'warehouse',
        price = 500000,
        ipl = {'ex_dt1_02_warehouse_medium'},
        coords     = vector4(1048.0,  -3097.0, -38.9, 270.0),
        exitCoords = vector4(1048.0,  -3085.0, -38.9,  90.0),
        maxOccupancy = 8,
        customizable = false,
        blip         = { sprite = 473, color = 4, scale = 0.85 },
        description = 'Mid-sized warehouse for expanding businesses'
    },
    {
        id = 'warehouse_large_1',
        name = 'Large Warehouse (LSIA)',
        category = 'warehouse',
        price = 1000000,
        ipl = {'ex_dt1_02_warehouse_large'},
        coords     = vector4(994.0,  -3002.0, -39.6, 0.0),
        exitCoords = vector4(994.0,  -2990.0, -39.6, 180.0),
        maxOccupancy = 10,
        customizable = false,
        blip         = { sprite = 473, color = 4, scale = 0.9 },
        description = 'Massive warehouse near Los Santos International Airport'
    },

    -- ========== 🏗️ BUNKERS (Gunrunning DLC) ==========
    {
        id = 'bunker_paleto',
        name = 'Paleto Forest Bunker',
        category = 'bunker',
        price = 1200000,
        ipl = {'gr_case0_bunkerclosed'},
        coords     = vector4(892.638, -3245.866, -98.265, 90.0),
        exitCoords = vector4(848.618,  2996.567,   45.816, 270.0),
        maxOccupancy = 8,
        customizable = true,
        blip         = { sprite = 557, color = 22, scale = 0.85 },
        customization = {
            upgrades = {
                {name = 'Basic',    ipl = 'gr_case0_bunkerclosed'},
                {name = 'Upgraded', ipl = 'gr_case0_bunkeropen'}
            },
            style = {
                {name = 'Style 1', ipl = 'gr_case0_bunkerstyle1'},
                {name = 'Style 2', ipl = 'gr_case0_bunkerstyle2'},
                {name = 'Style 3', ipl = 'gr_case0_bunkerstyle3'}
            }
        },
        description = 'Underground military bunker with research facilities'
    },
    {
        id = 'bunker_zancudo',
        name = 'Zancudo River Bunker',
        category = 'bunker',
        price = 1550000,
        ipl = {'gr_case10_bunkerclosed'},
        coords     = vector4(892.638,   -3245.866,  -98.265,  90.0),
        exitCoords = vector4(-3058.714,  3329.19,    12.5844, 270.0),
        maxOccupancy = 8,
        customizable = true,
        blip         = { sprite = 557, color = 22, scale = 0.85 },
        customization = {
            upgrades = {
                {name = 'Basic',    ipl = 'gr_case10_bunkerclosed'},
                {name = 'Upgraded', ipl = 'gr_case10_bunkeropen'}
            }
        },
        description = 'Strategic bunker near Fort Zancudo'
    },
    {
        id = 'bunker_route68',
        name = 'Route 68 Bunker',
        category = 'bunker',
        price = 1950000,
        ipl = {'gr_case9_bunkerclosed'},
        coords     = vector4(892.638,  -3245.866, -98.265,  90.0),
        exitCoords = vector4(24.435,    2959.705,   58.355, 270.0),
        maxOccupancy = 8,
        customizable = true,
        blip         = { sprite = 557, color = 22, scale = 0.85 },
        customization = {
            upgrades = {
                {name = 'Basic',    ipl = 'gr_case9_bunkerclosed'},
                {name = 'Upgraded', ipl = 'gr_case9_bunkeropen'}
            }
        },
        description = 'Desert bunker with excellent highway access'
    },

    -- ========== 🏭 FACILITIES (Doomsday Heist DLC) ==========
    {
        id = 'facility_paleto',
        name = 'Paleto Bay Facility',
        category = 'facility',
        price = 1250000,
        ipl = {'xm_x17dlc_int_placement_interior_33_x17dlc_int_02_milo_'},
        coords     = vector4(345.0,  4842.0, -60.0, 180.0),
        exitCoords = vector4(483.0,  4810.0, -58.0,   0.0),
        maxOccupancy = 10,
        customizable = true,
        blip         = { sprite = 569, color = 3, scale = 0.85 },
        customization = {
            graphics = {
                {name = 'Standard', ipl = 'xm_x17dlc_facility'},
                {name = 'Enhanced', ipl = 'xm_x17dlc_facility_2'}
            }
        },
        description = 'High-tech underground facility for special operations'
    },
    {
        id = 'facility_zancudo',
        name = 'Fort Zancudo Facility',
        category = 'facility',
        price = 2950000,
        ipl = {'xm_x17dlc_int_placement_interior_33_x17dlc_int_02_milo_'},
        coords     = vector4(345.0,    4842.0,  -60.0,  240.0),
        exitCoords = vector4(-1838.0,  3238.0,   32.0,   60.0),
        maxOccupancy = 10,
        customizable = true,
        blip         = { sprite = 569, color = 3, scale = 0.85 },
        customization = {
            graphics = {
                {name = 'Standard', ipl = 'xm_x17dlc_facility'},
                {name = 'Enhanced', ipl = 'xm_x17dlc_facility_2'}
            }
        },
        description = 'Premium facility adjacent to military base'
    },

    -- ========== 🎭 NIGHTCLUBS (After Hours DLC) ==========
    {
        id = 'nightclub_downtown',
        name = 'Downtown Vinewood Nightclub',
        category = 'nightclub',
        price = 1500000,
        ipl = {'ba_int_placement_ba_interior_0_dlc_int_01_ba_milo_'},
        coords     = vector4(-1604.664, -3012.583, -78.0, 160.0),
        exitCoords = vector4(760.0,     -1337.0,    27.0, 340.0),
        maxOccupancy = 20,
        customizable = true,
        blip         = { sprite = 614, color = 27, scale = 0.85 },
        customization = {
            style = {
                {name = 'Contemporary', ipl = 'ba_style01'},
                {name = 'Industrial',   ipl = 'ba_style02'},
                {name = 'Glam',         ipl = 'ba_style03'}
            },
            upgrades = {
                {name = 'DJ Booth',  ipl = 'ba_dj'},
                {name = 'Lights',    ipl = 'ba_lights'},
                {name = 'Security',  ipl = 'ba_security'}
            }
        },
        description = 'Popular nightclub in the heart of Vinewood'
    },
    {
        id = 'nightclub_west_vinewood',
        name = 'West Vinewood Nightclub',
        category = 'nightclub',
        price = 1450000,
        ipl = {'ba_int_placement_ba_interior_1_dlc_int_01_ba'},
        coords     = vector4(-1604.664, -3012.583, -78.0, 340.0),
        exitCoords = vector4(9.0,        221.0,    109.0, 160.0),
        maxOccupancy = 20,
        customizable = true,
        blip         = { sprite = 614, color = 27, scale = 0.85 },
        customization = {
            style = {
                {name = 'Contemporary', ipl = 'ba_style01'},
                {name = 'Industrial',   ipl = 'ba_style02'},
                {name = 'Glam',         ipl = 'ba_style03'}
            }
        },
        description = 'Trendy nightclub with great location'
    },
    {
        id = 'nightclub_mission_row',
        name = 'Mission Row Nightclub',
        category = 'nightclub',
        price = 1080000,
        ipl = {'ba_int_placement_ba_interior_2_dlc_int_01_ba'},
        coords     = vector4(-1604.664, -3012.583, -78.0, 160.0),
        exitCoords = vector4(348.0,      -979.0,    30.0, 340.0),
        maxOccupancy = 20,
        customizable = true,
        blip         = { sprite = 614, color = 27, scale = 0.85 },
        customization = {
            style = {
                {name = 'Contemporary', ipl = 'ba_style01'},
                {name = 'Industrial',   ipl = 'ba_style02'},
                {name = 'Glam',         ipl = 'ba_style03'}
            }
        },
        description = 'Downtown nightclub with urban vibe'
    },

    -- ========== 🎮 ARCADES (Diamond Casino Heist DLC) ==========
    {
        id = 'arcade_eight_bit',
        name = 'Eight-Bit Arcade (Vinewood)',
        category = 'arcade',
        price = 1235000,
        ipl = {'ba_int_placement_ba_interior_3_dlc_int_01_ba'},
        coords     = vector4(2732.0,  -380.0, -50.0,   0.0),
        exitCoords = vector4(730.0,  -1070.0,  20.5, 180.0),
        maxOccupancy = 15,
        customizable = true,
        blip         = { sprite = 740, color = 27, scale = 0.85 },
        customization = {
            style = {
                {name = 'Retro',  ipl = 'arcade_style_retro'},
                {name = 'Neon',   ipl = 'arcade_style_neon'},
                {name = 'Modern', ipl = 'arcade_style_modern'}
            }
        },
        description = 'Classic arcade with heist planning room'
    },
    {
        id = 'arcade_insert_coin',
        name = 'Insert Coin Arcade (Rockford Hills)',
        category = 'arcade',
        price = 2135000,
        ipl = {'ba_int_placement_ba_interior_4_dlc_int_01_ba'},
        coords     = vector4(2732.0,   -380.0,  -50.0, 140.0),
        exitCoords = vector4(-1285.0,  -291.0,   37.0, 320.0),
        maxOccupancy = 15,
        customizable = true,
        blip         = { sprite = 740, color = 27, scale = 0.85 },
        customization = {
            style = {
                {name = 'Retro',  ipl = 'arcade_style_retro'},
                {name = 'Neon',   ipl = 'arcade_style_neon'},
                {name = 'Modern', ipl = 'arcade_style_modern'}
            }
        },
        description = 'Upscale arcade in prestigious neighborhood'
    },

    -- ========== 🎰 CASINO ==========
    {
        id = 'casino_main',
        name = 'Diamond Casino & Resort',
        category = 'casino',
        price = 5000000,
        ipl = {'vw_casino_main'},
        coords     = vector4(1110.2,  216.6, -49.45, 180.0),
        exitCoords = vector4(935.0,    47.0,   81.0,   0.0),
        maxOccupancy = 30,
        customizable = false,
        blip         = { sprite = 679, color = 5, scale = 0.95 },
        description = 'The most luxurious casino in Los Santos'
    },

    -- ========== 🚗 CAR MEET (LS Tuners DLC) ==========
    {
        id = 'ls_car_meet',
        name = 'LS Car Meet',
        category = 'carmeet',
        price = 950000,
        ipl = {'carmeet_ipl_0', 'carmeet_ipl_1', 'carmeet_ipl_2'},
        coords     = vector4(-2000.0, 1113.211, -25.362, 135.0),
        exitCoords = vector4(-2000.0, 1128.0,   -25.0,  315.0),
        maxOccupancy = 20,
        customizable = false,
        blip         = { sprite = 762, color = 27, scale = 0.85 },
        description = 'Underground car meet for automotive enthusiasts'
    },
    {
        id = 'auto_shop',
        name = 'LS Auto Shop',
        category = 'garage',
        price = 800000,
        ipl = {'imp_dt1_02_modgarage'},
        coords     = vector4(-146.617, -596.630, 166.0, 135.0),
        exitCoords = vector4(-1143.0,  -1985.0,   13.0, 315.0),
        maxOccupancy = 10,
        customizable = false,
        blip         = { sprite = 72, color = 4, scale = 0.85 },
        description = 'Professional auto shop with customization bay'
    },

    -- ========== 💰 HEIST LOCATIONS ==========
    {
        id = 'pacific_standard',
        name = 'Pacific Standard Bank',
        category = 'heist',
        price = 10000000,
        ipl = {'dt1_03_bank'},
        coords     = vector4(232.0,  228.0, 106.0, 160.0),
        exitCoords = vector4(232.0,  216.0, 106.0, 340.0),
        maxOccupancy = 8,
        customizable = false,
        blip         = { sprite = 107, color = 1, scale = 0.9 },
        description = 'Iconic bank in downtown Los Santos'
    },
    {
        id = 'humane_labs',
        name = 'Humane Labs',
        category = 'facility',
        price = 8000000,
        ipl = {'reh'},
        coords     = vector4(3525.0, 3705.0, 36.0, 180.0),
        exitCoords = vector4(3525.0, 3717.0, 36.0,   0.0),
        maxOccupancy = 8,
        customizable = false,
        blip         = { sprite = 96, color = 1, scale = 0.9 },
        description = 'Research facility in the Alamo Sea area'
    },

    -- ========== 📊 BUSINESSES (Bikers DLC) ==========
    {
        id = 'meth_lab',
        name = 'Meth Lab (Grand Senora Desert)',
        category = 'business',
        price = 650000,
        ipl = {'bkr_biker_interior_placement_interior_2_biker_dlc_int_ware01_milo'},
        coords     = vector4(1009.5,  -3196.6, -38.997, 200.0),
        exitCoords = vector4(1009.5,  -3185.0, -39.0,    20.0),
        maxOccupancy = 6,
        customizable = true,
        blip         = { sprite = 499, color = 25, scale = 0.85 },
        customization = {
            upgrades = {
                {name = 'Basic',    ipl = 'meth_lab_production'},
                {name = 'Upgraded', ipl = 'meth_lab_upgrade'}
            }
        },
        description = 'Production facility in remote desert location'
    },
    {
        id = 'cocaine_lockup',
        name = 'Cocaine Lockup (Alamo Sea)',
        category = 'business',
        price = 975000,
        ipl = {'bkr_biker_interior_placement_interior_4_biker_dlc_int_ware03_milo'},
        coords     = vector4(1088.62, -3187.46, -38.99, 172.52),
        exitCoords = vector4(1088.62, -3187.46, -38.99, 172.52),
        maxOccupancy = 6,
        customizable = true,
        blip         = { sprite = 497, color = 1, scale = 0.85 },
        customization = {
            upgrades = {
                {name = 'Basic',    ipl = 'coke_lockup_production'},
                {name = 'Upgraded', ipl = 'coke_lockup_upgrade'}
            }
        },
        description = 'Secure lockup facility for production'
    },
    {
        id = 'weed_farm',
        name = 'Weed Farm (Grand Senora)',
        category = 'business',
        price = 715000,
        ipl = {'bkr_biker_interior_placement_interior_3_biker_dlc_int_ware02_milo'},
        coords     = vector4(1066.40, -3183.43, -39.16, 91.49),
        exitCoords = vector4(1066.40, -3183.43, -39.16, 180.49),
        maxOccupancy = 6,
        customizable = true,
        blip         = { sprite = 496, color = 2, scale = 0.85 },
        customization = {
            upgrades = {
                {name = 'Basic',    ipl = 'weed_farm_production'},
                {name = 'Upgraded', ipl = 'weed_farm_upgrade'}
            }
        },
        description = 'Agricultural facility in secluded area'
    },
    {
        id = 'counterfeit_cash',
        name = 'Counterfeit Cash Factory',
        category = 'business',
        price = 845000,
        ipl = {'bkr_biker_interior_placement_interior_5_biker_dlc_int_ware04_milo'},
        coords     = vector4(1121.897, -3195.338, -40.403, 0.0),
        exitCoords = vector4(1121.9,   -3183.0,   -40.0,  180.0),
        maxOccupancy = 6,
        customizable = true,
        blip         = { sprite = 500, color = 5, scale = 0.85 },
        customization = {
            upgrades = {
                {name = 'Basic',    ipl = 'counterfeit_production'},
                {name = 'Upgraded', ipl = 'counterfeit_upgrade'}
            }
        },
        description = 'Underground printing facility'
    },
    {
        id = 'document_forgery',
        name = 'Document Forgery Office',
        category = 'business',
        price = 650000,
        ipl = {'bkr_biker_interior_placement_interior_6_biker_dlc_int_ware05_milo'},
        coords     = vector4(1165.0,  -3196.6, -39.013, 90.0),
        exitCoords = vector4(1165.0,  -3185.0, -39.0,  270.0),
        maxOccupancy = 4,
        customizable = true,
        blip         = { sprite = 498, color = 4, scale = 0.85 },
        customization = {
            upgrades = {
                {name = 'Basic',    ipl = 'document_forgery_production'},
                {name = 'Upgraded', ipl = 'document_forgery_upgrade'}
            }
        },
        description = 'Specialized forgery operation'
    },

    -- ========== 💃 STRIPCLUB & BARS ==========
    {
        id = 'vanilla_unicorn',
        name = 'Vanilla Unicorn',
        category = 'stripclub',
        price = 1200000,
        ipl = {'stripclub'},
        coords     = vector4(127.0,  -1285.0, 29.0, 300.0),
        exitCoords = vector4(127.0,  -1275.0, 29.0, 120.0),
        maxOccupancy = 20,
        customizable = false,
        blip         = { sprite = 121, color = 1, scale = 0.9 },
        description = 'Famous strip club in Strawberry'
    },
    {
        id = 'tequilala',
        name = 'Tequi-la-la',
        category = 'nightclub',
        price = 650000,
        ipl = {'tequilala_ipl'},
        coords     = vector4(-564.0,  278.0, 83.0, 175.0),
        exitCoords = vector4(-564.0,  290.0, 83.0, 355.0),
        maxOccupancy = 15,
        customizable = false,
        blip         = { sprite = 93, color = 5, scale = 0.8 },
        description = 'Classic nightclub in West Vinewood'
    },

    -- ========== 👮 POLIZEI & BEHÖRDEN ==========
    {
        id = 'mission_row_pd',
        name = 'Mission Row Police Station',
        category = 'police',
        price = 1000000,
        ipl = {'police_station_ipl'},
        coords     = vector4(441.0,  -982.0, 30.6, 180.0),
        exitCoords = vector4(441.0,  -970.0, 30.6,   0.0),
        maxOccupancy = 15,
        customizable = false,
        blip         = { sprite = 60, color = 38, scale = 0.85 },
        description = 'Main LSPD precinct in downtown Los Santos'
    },
    {
        id = 'vespucci_pd',
        name = 'Vespucci Police Station',
        category = 'police',
        price = 750000,
        ipl = {'vespucci_pd_ipl'},
        coords     = vector4(-1096.0,  -850.0, 13.0, 120.0),
        exitCoords = vector4(-1096.0,  -862.0, 13.0, 300.0),
        maxOccupancy = 12,
        customizable = false,
        blip         = { sprite = 60, color = 38, scale = 0.8 },
        description = 'Beach-side LSPD precinct'
    },
    {
        id = 'sandy_shores_pd',
        name = 'Sandy Shores Sheriff',
        category = 'police',
        price = 400000,
        ipl = {'sandy_pd_ipl'},
        coords     = vector4(1853.0,  3686.0, 34.0, 30.0),
        exitCoords = vector4(1853.0,  3698.0, 34.0, 210.0),
        maxOccupancy = 8,
        customizable = false,
        blip         = { sprite = 60, color = 38, scale = 0.75 },
        description = 'Blaine County Sheriff station'
    },
    {
        id = 'paleto_bay_pd',
        name = 'Paleto Bay Sheriff',
        category = 'police',
        price = 350000,
        ipl = {'paleto_pd_ipl'},
        coords     = vector4(-448.0,  6008.0, 31.0, 315.0),
        exitCoords = vector4(-448.0,  6020.0, 31.0, 135.0),
        maxOccupancy = 6,
        customizable = false,
        blip         = { sprite = 60, color = 38, scale = 0.75 },
        description = 'Small-town sheriff station'
    },
    {
        id = 'bolingbroke_prison',
        name = 'Bolingbroke Penitentiary',
        category = 'prison',
        price = 2000000,
        ipl = {'prison_ipl'},
        coords     = vector4(1845.0,  2605.0, 45.6, 270.0),
        exitCoords = vector4(1845.0,  2617.0, 45.6,  90.0),
        maxOccupancy = 20,
        customizable = false,
        blip         = { sprite = 188, color = 1, scale = 0.85 },
        description = 'Maximum security state prison'
    },
    {
        id = 'fib_building',
        name = 'FIB Building',
        category = 'special',
        price = 1500000,
        ipl = {'FIBlobby'},
        coords     = vector4(135.0,  -745.0, 262.0, 160.0),
        exitCoords = vector4(130.0,  -730.0,  44.0, 340.0),
        maxOccupancy = 10,
        customizable = false,
        blip         = { sprite = 105, color = 29, scale = 0.9 },
        description = 'Federal Investigation Bureau headquarters'
    },

    -- ========== 🏥 KRANKENHÄUSER ==========
    {
        id = 'pillbox_hospital',
        name = 'Pillbox Hill Medical Center',
        category = 'hospital',
        price = 800000,
        ipl = {'rc12b_default'},
        coords     = vector4(307.168,  -590.807, 43.280, 70.0),
        exitCoords = vector4(295.0,    -585.0,   43.0,  250.0),
        maxOccupancy = 15,
        customizable = false,
        blip         = { sprite = 61, color = 1, scale = 0.85 },
        description = 'Main trauma center in downtown Los Santos'
    },
    {
        id = 'mount_zonah',
        name = 'Mount Zonah Medical Center',
        category = 'hospital',
        price = 1000000,
        ipl = {'rc12n_ipl'},
        coords     = vector4(-456.0,  -340.0, 34.0, 115.0),
        exitCoords = vector4(-456.0,  -328.0, 34.0, 295.0),
        maxOccupancy = 15,
        customizable = false,
        blip         = { sprite = 61, color = 1, scale = 0.85 },
        description = 'Premier hospital in Rockford Hills'
    },
    {
        id = 'sandy_shores_medical',
        name = 'Sandy Shores Medical Center',
        category = 'hospital',
        price = 400000,
        ipl = {'shr_int'},
        coords     = vector4(-47.162,  -1115.333, 26.5, 210.0),
        exitCoords = vector4(1835.0,    3675.0,   34.0,  30.0),
        maxOccupancy = 8,
        customizable = false,
        blip         = { sprite = 61, color = 1, scale = 0.75 },
        description = 'Rural medical facility'
    },
    {
        id = 'paleto_bay_medical',
        name = 'Paleto Bay Medical Center',
        category = 'hospital',
        price = 350000,
        ipl = {'paleto_medical_ipl'},
        coords     = vector4(-254.0,  6324.0, 32.0, 315.0),
        exitCoords = vector4(-254.0,  6336.0, 32.0, 135.0),
        maxOccupancy = 6,
        customizable = false,
        blip         = { sprite = 61, color = 1, scale = 0.75 },
        description = 'Small-town clinic'
    },

    -- ========== ⛵ YACHTEN & SCHIFFE ==========
    {
        id = 'yacht_aquarius',
        name = 'Aquarius Super Yacht',
        category = 'yacht',
        price = 7000000,
        ipl = {'hei_yacht_heist', 'hei_yacht_heist_lod'},
        coords     = vector4(-2043.974, -1031.582, 11.981, 125.0),
        exitCoords = vector4(-2030.0,   -1015.0,   10.0,  305.0),
        maxOccupancy = 12,
        customizable = false,
        blip         = { sprite = 455, color = 5, scale = 0.9 },
        description = 'Luxurious super yacht with amenities'
    },
    {
        id = 'yacht_pisces',
        name = 'Pisces Super Yacht (Gunrunning)',
        category = 'yacht',
        price = 7500000,
        ipl = {'gr_heist_yacht2', 'gr_heist_yacht2_lod'},
        coords     = vector4(-1363.724,  6734.108, 2.446, 125.0),
        exitCoords = vector4(-1370.0,    6720.0,   3.0,  305.0),
        maxOccupancy = 12,
        customizable = false,
        blip         = { sprite = 455, color = 5, scale = 0.9 },
        description = 'Premium super yacht with elegant design'
    },
    {
        id = 'yacht_orion',
        name = 'Orion Super Yacht',
        category = 'yacht',
        price = 8000000,
        ipl = {'smboat_03', 'smboat_03_lod'},
        coords     = vector4(-2043.974, -1031.582, 11.981, 125.0),
        exitCoords = vector4(-2027.0,   -1018.0,    5.5,  305.0),
        maxOccupancy = 12,
        customizable = false,
        blip         = { sprite = 455, color = 5, scale = 0.95 },
        description = 'Ultimate luxury yacht with all features'
    },
    {
        id = 'cargo_ship',
        name = 'Dignity Party Yacht (Cargo Ship)',
        category = 'ship',
        price = 800000,
        ipl = {'cargoship', 'ship_occ_grp1'},
        coords     = vector4(-168.183, -2364.826, 20.0, 270.0),
        exitCoords = vector4(-163.0,   -2350.0,   20.0,  90.0),
        maxOccupancy = 10,
        customizable = false,
        blip         = { sprite = 410, color = 47, scale = 0.85 },
        description = 'Converted cargo ship for parties'
    },

    -- ========== 🏝️ CAYO PERICO (Cayo Perico Heist DLC) ==========
    {
        id = 'cayo_perico_compound',
        name = 'Cayo Perico El Rubio Compound',
        category = 'compound',
        price = 5000000,
        ipl = {
            'h4_islandx_mansion',
            'h4_islandx_mansion_props',
            'h4_islandx_mansion_entrance',
            'h4_islandx_mansion_lockup_01',
            'h4_islandx_mansion_lockup_02',
            'h4_islandx_mansion_lockup_03'
        },
        coords     = vector4(4950.0,  -5170.0, 2.0, 125.0),
        exitCoords = vector4(4950.0,  -5158.0, 2.0, 305.0),
        maxOccupancy = 10,
        customizable = false,
        blip         = { sprite = 374, color = 6, scale = 0.9 },
        description = "El Rubio's fortified island compound"
    },
    {
        id = 'cayo_perico_beach_party',
        name = 'Cayo Perico Beach Party (Music Locker)',
        category = 'event',
        price = 2000000,
        ipl = {'h4_islandx_beach_party'},
        coords     = vector4(1550.0,  250.0, -50.0, 200.0),
        exitCoords = vector4(4893.0, -4905.0,  3.0,  20.0),
        maxOccupancy = 20,
        customizable = false,
        blip         = { sprite = 136, color = 27, scale = 0.85 },
        description = 'Private beach party venue'
    },
    {
        id = 'cayo_perico_submarine',
        name = 'Kosatka Submarine',
        category = 'special',
        price = 2200000,
        ipl = {'h4_islandx_submarine'},
        coords     = vector4(1560.0,  400.0, -50.0,   0.0),
        exitCoords = vector4(1561.0,  385.0, -49.0, 180.0),
        maxOccupancy = 4,
        customizable = false,
        blip         = { sprite = 308, color = 3, scale = 0.9 },
        description = 'Nuclear submarine command center'
    },

    -- ========== 🌟 SPEZIELLE LOCATIONS ==========
    {
        id = 'agency',
        name = 'The Agency (Contract DLC)',
        category = 'office',
        price = 2500000,
        ipl = {'v_int_placement_v_int_1_dlc_v_agency'},
        coords     = vector4(-1010.0,  -415.0, 64.0, 120.0),
        exitCoords = vector4(-1010.0,  -403.0, 64.0, 300.0),
        maxOccupancy = 8,
        customizable = true,
        blip         = { sprite = 475, color = 29, scale = 0.85 },
        customization = {
            style = {
                {name = 'Executive', ipl = 'v_agency_executive'},
                {name = 'Classic',   ipl = 'v_agency_classic'},
                {name = 'Urban',     ipl = 'v_agency_urban'}
            }
        },
        description = 'Elite private agency office'
    },
    {
        id = 'lifeinvader_office',
        name = 'Lifeinvader Office',
        category = 'office',
        price = 300000,
        ipl = {'facelobby'},
        coords     = vector4(-1047.9,  -233.0, 39.0, 205.0),
        exitCoords = vector4(-1038.0,  -220.0, 29.0,  25.0),
        maxOccupancy = 8,
        customizable = false,
        blip         = { sprite = 521, color = 3, scale = 0.8 },
        description = 'Tech company headquarters'
    },
    {
        id = 'kortz_center',
        name = 'Kortz Center',
        category = 'special',
        price = 3500000,
        ipl = {'kortz_center'},
        coords     = vector4(-2360.0,  2982.0, 32.0, 270.0),
        exitCoords = vector4(-2360.0,  2994.0, 32.0,  90.0),
        maxOccupancy = 30,
        customizable = false,
        blip         = { sprite = 488, color = 6, scale = 0.85 },
        description = 'Contemporary art museum and event space'
    },
    {
        id = 'comedy_club',
        name = 'Split Sides Comedy Club',
        category = 'special',
        price = 400000,
        ipl = {'comedy_club'},
        coords     = vector4(-430.0,  261.0, 83.0, 90.0),
        exitCoords = vector4(-430.0,  273.0, 83.0, 270.0),
        maxOccupancy = 100,
        customizable = false,
        blip         = { sprite = 102, color = 27, scale = 0.85 },
        description = 'Stand-up comedy venue'
    },
    {
        id = 'north_yankton',
        name = 'North Yankton (Ludendorff)',
        category = 'hidden',
        price = 10000000,
        ipl = {
            'prologue01', 'prologue01c', 'prologue01d', 'prologue01e',
            'prologue01f', 'prologue01g', 'prologue01h', 'prologue01i',
            'prologue01j', 'prologue01k', 'prologue01z', 'prologue02',
            'prologue03', 'prologue03b', 'prologue04', 'prologue04b',
            'prologue05', 'prologue06', 'prologue_occl', 'prologue06_int',
            'prologuerd', 'prologue_DistantLights', 'prologue_LODLights',
            'prologue03_grv_cov'
        },
        coords     = vector4(3217.697, -4834.826, 111.815, 215.0),
        exitCoords = vector4(3217.697, -4834.826, 111.815,  35.0),
        maxOccupancy = 8,
        customizable = false,
        blip         = { sprite = 7, color = 3, scale = 0.9 },
        description = 'Snowy North Yankton town (Prologue location)'
    },
    {
        id = 'aircraft_carrier',
        name = 'USS Luxington ATT-16 (Aircraft Carrier)',
        category = 'ship',
        price = 15000000,
        ipl = {
            'hei_carrier', 'hei_carrier_DistantLights',
            'hei_Carrier_int1', 'hei_Carrier_int2', 'hei_Carrier_int3',
            'hei_Carrier_int4', 'hei_Carrier_int5', 'hei_Carrier_int6'
        },
        coords     = vector4(3082.312, -4717.119, 15.262, 150.0),
        exitCoords = vector4(3082.312, -4717.119, 15.262, 330.0),
        maxOccupancy = 20,
        customizable = false,
        blip         = { sprite = 359, color = 38, scale = 0.95 },
        description = 'Massive military aircraft carrier'
    },
    {
        id = 'zancudo_ufo',
        name = 'Fort Zancudo UFO (Hidden)',
        category = 'hidden',
        price = 99999999,
        ipl = {'ufo'},
        coords     = vector4(2490.477,  3774.844, 2414.035,   0.0),
        exitCoords = vector4(2490.477,  3774.844, 2414.035, 180.0),
        maxOccupancy = 4,
        customizable = false,
        blip         = { sprite = 308, color = 3, scale = 0.8 },
        description = 'Secret UFO crash site (Easter egg)'
    }
}

-- ============================================
-- 🔧 HELPER FUNCTIONS
-- ============================================

function GetIPLById(id)
    for _, ipl in ipairs(Config.IPLDatabase) do
        if ipl.id == id then
            return ipl
        end
    end
    return nil
end

function GetIPLsByCategory(category)
    local ipls = {}
    for _, ipl in ipairs(Config.IPLDatabase) do
        if ipl.category == category then
            table.insert(ipls, ipl)
        end
    end
    return ipls
end

function GetIPLCategoryCount()
    local counts = {}
    for _, ipl in ipairs(Config.IPLDatabase) do
        counts[ipl.category] = (counts[ipl.category] or 0) + 1
    end
    return counts
end

function GetTotalIPLCount()
    return #Config.IPLDatabase
end

return Config

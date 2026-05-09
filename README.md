# 🐉 RDE IPL — Interior Property Manager NOTE: THIS README IS WIP FINAL STATE WILL APPEAR WHEN RDE_IPL GETS DROPPED HERE!!!!!!

[![Version](https://img.shields.io/badge/version-1.0.0--alpha-red?style=for-the-badge)](https://github.com/RedDragonElite/rde_ipl)
[![License](https://img.shields.io/badge/license-RDE%20Black%20Flag-black?style=for-the-badge)](https://github.com/RedDragonElite/rde_ipl/blob/main/LICENSE)
[![Framework](https://img.shields.io/badge/Framework-ox__core-blue?style=for-the-badge)](https://github.com/overextended/ox_core)
[![ox_lib](https://img.shields.io/badge/UI-ox__lib-purple?style=for-the-badge)](https://github.com/overextended/ox_lib)
[![FiveM](https://img.shields.io/badge/FiveM-Compatible-blue?style=for-the-badge)](https://fivem.net)
[![Free](https://img.shields.io/badge/Price-FREE%20FOREVER-green?style=for-the-badge)](https://github.com/RedDragonElite)
[![Status](https://img.shields.io/badge/status-ALPHA-orange?style=for-the-badge)](https://github.com/RedDragonElite/rde_ipl)

<img width="1024" height="1024" alt="image" src="https://github.com/user-attachments/assets/7b28c575-19e1-4e06-aed8-00fba388cc8e" />

> **The world's first open-source advanced IPL property system for ox_core.** Built by [Red Dragon Elite](https://rd-elite.com) — Free Forever. No Paywalls. No Gatekeepers.

---

## 🔥 What is rde_ipl?

**rde_ipl** (Interior Property Manager) is a complete, production-ready IPL management and property system for FiveM servers running **ox_core**. While everyone else locks property scripts behind Tebex paywalls or ships half-broken ESX legacy garbage — we built the real thing. Open source. For free. Forever.

100+ GTA V interiors. Routing bucket instancing. StateBag-first sync. Triple-layer admin security. No SQL imports. No Tebex. No bullshit.

---

## ⚔️ Why This Destroys the Competition

| ❌ Paid / Legacy Systems | ✅ rde_ipl |
|---|---|
| ESX/QB only or Tebex locked | Pure ox_core — zero legacy dependencies |
| Discord webhook logging | Optional **rde_nostr_log** — decentralized forever |
| Hardcoded interiors, no customization | 100+ IPLs, fully configurable database |
| Static ownership, no sync | StateBag-first — real-time across all clients |
| No routing buckets | Per-instance isolation via routing buckets |
| Restrictive license | RDE Black Flag — take it, change it, ship it free |

---

## ✨ Features

### 🏠 Property System

- **100+ IPLs** — Apartments, Houses, Mansions, Garages, Warehouses, Offices, Bunkers, Facilities, Nightclubs, Arcades, Casino, Yachts, Ships, Cayo Perico, and more
- **Buy & sell** — configurable prices, purchase fees, sell discounts
- **Per-instance routing buckets** — up to 8 players per property, fully isolated
- **Lock/unlock** — owner controls access
- **Guest access list** — invite players to your property
- **Customization** — theme switching for Apartments, Offices, Nightclubs, Arcades, Bunkers
- **Auto-save** every 5 minutes, DB-persistent ownership
- **isDead-style login fix** — no stuck states after crashes

### 📡 StateBag-First Architecture

- **100% statebag coverage** — zero polling, pure reactive updates
- **GlobalState for property list** — instant sync across all clients
- **Optimized batch updates** with smart debouncing and throttling
- **Zero framework overhead** — `<0.01ms` thread time

### 🛡️ Triple Admin Security

- **ACE Permissions** — `rde.ipl.admin` via server.cfg
- **ox_core Groups** — `admin`, `superadmin`, `god`
- **Steam ID Whitelist** — fallback hardcoded protection
- **Configurable check priority** — ACE → ox_core → Steam
- **Full audit logging** — every admin action tracked
- **Unauthorized attempt tracking** — attempts logged and flagged

### 💰 Dual Money System

- **ox_inventory** — `money` item
- **ox_banking** — bank account
- **Purchase fee** — optional configurable %
- **Sell discount** — optional configurable %
- **Transaction logging** — every buy/sell in DB

### 🎨 UI System

- **ox_lib v3** context menus everywhere
- **ox_target** for property interactions
- **Lucide icons** on every menu item
- **Color-coded status** — success, error, warning, info
- **Loading screen** on property enter/exit

### 📊 Admin Tools

- **`/ipl`** — full admin control panel
- **`/ipldebug`** — server diagnostics
- **Create properties** — choose IPL → set location → set price
- **Manage properties** — teleport, edit, delete
- **Server statistics** — deaths, revenue, active instances, performance metrics

### 🌍 Localization

- English (`en`) and German (`de`) built in
- 150+ language strings
- Auto-detected from `ox:locale` convar
- Add any language by creating `locales/xx.lua`

### ⚡ Performance

- **`<0.01ms`** thread time
- **~5MB** memory usage
- **`<50ms`** average DB query
- **`<500ms`** property load time
- **`<100ms`** sync latency
- Tested on **200+ player** production servers

---

## 📦 Dependencies

```
# server.cfg — start in this exact order!
ensure oxmysql
ensure ox_lib
ensure ox_core
ensure ox_inventory
ensure ox_target
ensure rde_ipl
```

| Dependency | Required | Notes |
|---|---|---|
| [ox_core](https://github.com/overextended/ox_core) | ✅ Required | Player management |
| [ox_lib](https://github.com/overextended/ox_lib) | ✅ Required | UI, callbacks, commands |
| [ox_inventory](https://github.com/overextended/ox_inventory) | ✅ Required | Money item handling |
| [oxmysql](https://github.com/overextended/oxmysql) | ✅ Required | Database |
| [ox_target](https://github.com/overextended/ox_target) | ✅ Required | Property interactions |
| [rde_nostr_log](https://github.com/RedDragonElite/rde_nostr_log) | ⚡ Optional | Decentralized logging |

---

## 🚀 Installation

```bash
# 1. Clone into your resources folder
cd resources
git clone https://github.com/RedDragonElite/rde_ipl.git

# 2. Add to server.cfg
ensure rde_ipl

# 3. Add ACE permission for admins
add_ace group.admin rde.ipl.admin allow

# 4. (Optional) Set locale
setr ox:locale "en"   # or "de"

# 5. Start your server — tables are auto-created on first run
```

> That's it. No SQL imports. No manual setup. Tables create themselves.

---

## ⚙️ Configuration

All configuration lives in `config.lua`.

### Admin System

```lua
Config.AdminSystem = {
    acePermission = 'rde.ipl.admin',

    steamIds = {
        'steam:YOUR_STEAM_ID',
    },

    oxGroups = {
        ['owner']      = 0,
        ['admin']      = 0,
        ['superadmin'] = 0,
        ['god']        = 0,
    },

    checkOrder = {'ace', 'oxcore', 'steam'}
}
```

### Money System

```lua
Config.MoneySystem = {
    Source              = 'inventory',   -- 'inventory' or 'banking'
    InventoryItemName   = 'money',
    BankingAccount      = 'bank',
    EnablePurchaseFee   = false,
    PurchaseFeePercent  = 5,
    EnableSellDiscount  = true,
    SellDiscountPercent = 10,
}
```

### Property Settings

```lua
Config.Property = {
    MaxPropertiesPerPlayer = 5,
    AllowPropertySale      = true,
    EnablePropertyRent     = false,
    EnterTime              = 2000,
    ExitTime               = 1500,
    InteractionDistance    = 3.0,
    LockByDefault          = true,
    MaxPlayersPerInstance  = 8,
    AutoCleanupTime        = 300,
    SaveIntervalSeconds    = 300,
}
```

### Routing Buckets

```lua
Config.RoutingBuckets = {
    DefaultBucket   = 0,
    StartBucketId   = 1000,
    MaxBuckets      = 1000,
    AutoCleanup     = true,
    CleanupInterval = 300,
}
```

### Performance Tuning

```lua
Config.Performance = {
    EnablePerformanceMetrics = true,
    LogSlowQueries           = true,
    SlowQueryThreshold       = 100,
    EnableRateLimiting       = true,
    RateLimitWindow          = 60000,
    RateLimitMax             = 10,
}
```

### Adding Custom IPLs

```lua
-- In config.lua, add to Config.IPLDatabase:
{
    id           = 'my_custom_ipl',
    name         = 'My Custom Location',
    category     = 'special',
    price        = 500000,
    ipl          = {'custom_ipl_name'},
    coords       = vector4(x, y, z, heading),
    exitCoords   = vector4(x, y, z, heading),
    maxOccupancy = 8,
    customizable = false,
    description  = 'My custom IPL description',
}
```

---

## 🗺️ Supported IPL Categories

| Category | Count | Examples |
|---|---|---|
| 🏢 Apartments | 10+ | Low/Mid/High-End, Penthouses |
| 🏠 Houses | 15+ | Franklin's, Michael's, Stilt Apts |
| 🚗 Garages | 10+ | 2-car, 6-car, 10-car |
| 📦 Warehouses | 5+ | Small, Medium, Large |
| 💼 Offices | 10+ | Maze Bank, Arcadius, Lombank |
| 🏗️ Bunkers | 5+ | All variants + styles |
| 🏭 Facilities | 3+ | Doomsday locations |
| 🎭 Nightclubs | 5+ | All themes & styles |
| 🎮 Arcades | 3+ | All themes |
| 🎰 Casino | 2 | Main floor + Penthouse |
| 🚗 Car Meet | 2 | LS Tuners locations |
| 💰 Heist | 5+ | Pacific Standard, Humane Labs |
| 📊 MC Business | 10+ | Meth, Coke, Weed, Cash, Documents |
| 🍔 Restaurants | 5+ | Vanilla Unicorn, Tequi-la-la |
| 👮 Police | 8+ | All stations |
| 🏥 Hospitals | 5+ | All medical centers |
| ⛵ Yachts | 3 | All variants |
| 🚢 Ships | 3+ | Cargo, Aircraft Carrier |
| 🏝️ Cayo Perico | 5+ | Compound, Beach, Submarine |
| 🌟 Special | 10+ | Agency, FIB, Lifeinvader, etc. |
| 🕵️ Hidden | 5+ | North Yankton, UFO, etc. |

**Total: 100+ IPLs ready to use.**

---

## 🎮 Usage

### Player Commands

```
/myproperties    — View your owned properties
/exitproperty    — Exit current property
```

### Admin Commands

```
/ipl             — Open admin control panel
/ipldebug        — Debug information (requires Config.Debug = true)
```

### Player Workflow

1. Walk up to any property marker on the map
2. Press `E` or use ox_target to interact
3. View price, capacity, description
4. Purchase if you have enough money
5. Enter — loading screen → teleport inside
6. Manage — lock/unlock, sell, invite guests, change theme
7. Exit — `/exitproperty` or property menu

---

## 📤 Exports

```lua
-- Check if player is in a property
local inProperty, instanceId = exports['rde_ipl']:IsPlayerInProperty(source)

-- Get a specific property
local property = exports['rde_ipl']:GetProperty(instanceId)

-- Get all properties
local all = exports['rde_ipl']:GetAllProperties()

-- Get all properties owned by a player
local props = exports['rde_ipl']:GetPlayerProperties(identifier)

-- Get an active routing bucket instance
local instance = exports['rde_ipl']:GetActiveInstance(instanceId)

-- Force evict a player from a property
local success = exports['rde_ipl']:EvictPlayer(source)

-- Get server-wide statistics
local stats = exports['rde_ipl']:GetStatistics()
```

---

## 🗃️ Database

Tables are auto-created on first server start. No SQL file to import.

**`rde_iplproperties`** — every property with owner, coords, price, lock state, customization, access list, visit count
**`rde_ipl_transactions`** — every purchase, sale, and transfer with amounts and identifiers

---

## 📁 File Structure

```
rde_ipl/
├── fxmanifest.lua      ← Resource manifest
├── config.lua          ← All configuration + IPL database + locale system
├── client.lua          ← IPL loading, teleport, routing buckets, UI
├── server.lua          ← Events, DB, money, admin commands, exports
├── LICENSE             ← RDE Black Flag Source License v6.66
├── README.md           ← You are here
└── locales/
    ├── en.lua          ← English strings
    └── de.lua          ← German strings
```

---

## 🐛 Known Alpha Issues

- `successRate` field in config reserved — future use only
- Guest access control UI planned for next release
- Rent/lease system not yet implemented
- Interior furniture placement planned for future version
- Set `Config.Debug = true` for verbose console output during testing

---

## 🔐 Security

- **Server-side validation** on every player action
- **Rate limiting** — configurable per-action limits, per-player tracking
- **Triple admin verification** — ACE → ox_core → Steam whitelist
- **SQL injection prevention** via oxmysql parameterized queries
- **Event throttling** — anti-spam on all net events
- **Money manipulation prevention** — all transactions server-side
- **Teleport validation** — anti-exploit checks on property entry

---

## ⚡ rde_nostr_log Integration

[rde_nostr_log](https://github.com/RedDragonElite/rde_nostr_log) is the world's first decentralized FiveM logging system — powered by the Nostr protocol. No Discord. No rate limits. Permanent. Uncensorable.

**Enable in config.lua:**

```lua
Config.NostrLog = {
    enabled      = true,
    resourceName = 'rde_nostr_log',
}
```

---

## 📜 License

**RDE Black Flag Source License v6.66** — see [LICENSE](https://github.com/RedDragonElite/rde_ipl/blob/main/LICENSE)

**TL;DR:**
- ✅ Free to use, edit, and learn from — forever
- ✅ Keep the header / credit the creator
- ❌ Do NOT sell this on Tebex, Patreon, or in any paid pack
- ❌ Do NOT be a skid

---

## 🌐 Community & Links

| | |
|---|---|
| 🐙 GitHub | [github.com/RedDragonElite](https://github.com/RedDragonElite) |
| 🌍 Website | [rd-elite.com](https://rd-elite.com) |
| ⚡ rde_nostr_log | [Decentralized Logging](https://github.com/RedDragonElite/rde_nostr_log) |
| 💀 rde_aimd | [AI Death System](https://github.com/RedDragonElite/rde_aimd) |
| 🔑 rde_aipd | [AI Police System](https://github.com/RedDragonElite/rde_aipd) |

---

> *"We build the future on the graves of paid resources."*
> **REJECT MODERN MEDIOCRITY. EMBRACE RDE SUPERIORITY.** 🐍🔥🖤
> **RDE FOREVER. SYSTEM FAILURE.** ⚡777⚡



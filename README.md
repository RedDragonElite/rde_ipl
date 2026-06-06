# 🔥 ULTIMATE IPL PROPERTY SYSTEM V1.0.0-ALPHA - Built on ox_core & Routing Buckets! 🏠

# 🐉 rde_ipl

[![Version](https://img.shields.io/badge/version-1.0.0--alpha-red?style=for-the-badge)](https://github.com/RedDragonElite/rde_ipl)
[![License](https://img.shields.io/badge/license-RDE%20Black%20Flag-black?style=for-the-badge)](LICENSE)
[![FiveM](https://img.shields.io/badge/FiveM-Compatible-blue?style=for-the-badge)](https://fivem.net)
[![ox_core](https://img.shields.io/badge/Framework-ox__core-blue?style=for-the-badge)](https://github.com/overextended/ox_core)
[![Nostr](https://img.shields.io/badge/Nostr-Decentralized-purple?style=for-the-badge)](https://github.com/RedDragonElite/rde_nostr_log)
[![Quality](https://img.shields.io/badge/Quality-Production-gold?style=for-the-badge)](https://github.com/RedDragonElite)

**🏠 RDE IPL | Native GTA Interior Property System for FiveM ox_core | Void-Proof Teleports | Routing Buckets | Nostr-Logged | 65 IPLs | Production-Ready**

*Built by [Red Dragon Elite](https://rd-elite.com) | Free Forever | No Paywalls | No Legacy*

[📖 Installation](#-installation) • [⚙️ Configuration](#️-configuration) • [💬 Commands](#-commands) • [🐉 Nostr Logging](#-nostr-logging) • [📡 Exports](#-exports) • [🐛 Troubleshooting](#-troubleshooting) • [🌐 Website](https://rd-elite.com) • [🔭 Terminal](https://rd-elite.com/Files/NOSTR/)

---

## 🔥 Why This Destroys Every Other IPL Script

Every other IPL/property script either drops players into the void, charges money for it, runs on legacy frameworks, or is an escrow nightmare.

We said no.

| ❌ Other IPL Scripts | ✅ rde_ipl |
|---|---|
| Teleports you into the void | Streaming-safe teleport: freeze → RequestCollision → settle → unfreeze |
| No interior exit | ox_target sphere zone INSIDE the property — "Exit Property" right where you spawn |
| Single map marker, same blip for everything | Per-IPL hand-picked blip sprites (bunker → military, submarine → 🚢, FIB → FBI icon) |
| Discord webhooks (deletable, bannable) | Decentralized Nostr logging — permanent & uncensorable |
| ESX / QBCore bloat | ox_core only — the future, not the past |
| One global instance, players see each other | Routing buckets — every property is a private dimension |
| Static property list, no DB | Full CRUD — create, buy, sell, delete, customize, persist |
| Paid or escrow | 100% free forever — RDE Black Flag |
| No admin tools | Triple admin: ACE + ox_core groups + Steam ID whitelist |
| Hard-coded coords, no validation | Coord validator on startup + client-side guard — no more void drops |

### 🎯 Key Features

- 🏠 **65 Native IPLs** — Apartments, Offices, Bunkers, Nightclubs, Casino, Yachts, Cayo Perico, North Yankton, Aircraft Carrier, UFO — all hand-picked
- 🚀 **StreamingSafeTeleport()** — RequestCollisionAtCoord → NewLoadSceneStart → collision settle → SetEntityCoords. Players never fall through the map.
- 🎯 **Interior Exit Zone** — ox_target sphere spawns inside the property on enter, removed on exit. No more `/exitproperty` hunting.
- 📡 **Statebag-First** — GlobalState syncs all properties to every client. One source of truth.
- 🌐 **Routing Buckets** — each property instance gets its own bucket. Guests see only who's in their dimension.
- 🗺️ **Per-IPL Map Blips** — every IPL has a hand-picked sprite/color/scale. Bunker gets military grey, FIB gets FBI icon, Submarine gets ship sprite. Can be disabled per-entry with `blip = false`.
- 🎨 **Interior Customization** — Apartments, Offices, Nightclubs with selectable themes — swap IPL variants on the fly.
- 💰 **Dual Money System** — ox_inventory item or ox_core bank account. Fees and sell discounts configurable.
- 🛡️ **Triple Admin Security** — ACE permissions, ox_core groups, Steam ID whitelist — any combination, configurable priority.
- 🐉 **Nostr Logging** — purchase, sale, enter, exit, admin actions, security violations — all decentralized and cryptographically signed.
- 🌍 **Multilanguage** — EN / DE out of the box, add any language in minutes.
- ⚡ **Rate Limiting** — per-player per-action windows on all destructive events.
- 🔍 **Coord Validator** — startup check catches `(0,0,0)` entries and identical `coords`/`exitCoords` before any player gets voided.
- 📊 **Performance Metrics** — transaction count, revenue, peak concurrent instances, instance duration average.
- 🧹 **Auto-Cleanup** — empty instances auto-destruct after configurable idle time. Routing buckets freed automatically.

---

## 📸 Screenshots

> Coming soon — drop a PR with your screenshots!

---

## 📦 Dependencies

```
oxmysql       → https://github.com/overextended/oxmysql
ox_lib        → https://github.com/overextended/ox_lib
ox_core       → https://github.com/overextended/ox_core
ox_target     → https://github.com/overextended/ox_target

optional:
ox_inventory  → https://github.com/overextended/ox_inventory  (only if MoneySystem.Source = 'inventory')
rde_nostr_log → https://github.com/RedDragonElite/rde_nostr_log
```

---

## 🚀 Installation

### Step 1: Clone or download

```bash
cd resources
git clone https://github.com/RedDragonElite/rde_ipl.git
```

### Step 2: Add to server.cfg

```cfg
# Dependencies first — order matters!
ensure oxmysql
ensure ox_lib
ensure ox_core
ensure ox_target
ensure ox_inventory   # only if MoneySystem.Source = 'inventory'

# Optional: Nostr logging (highly recommended)
ensure rde_nostr_log

# The IPL property system
ensure rde_ipl
```

### Step 3: Configure ACE permissions

```cfg
# server.cfg — grant admin access via ACE
add_ace group.admin rde.ipl.admin allow
add_ace identifier.steam:110000101605859 rde.ipl.admin allow
```

### Step 4: Start your server

That's it. No SQL import needed — tables auto-create on first run. You'll see:

```
╔═══════════════════════════════════════════════════════════╗
║  RDE | IPL MANAGER v1.0.0 - SERVER READY                  ║
║  Interior exit target + per-IPL map blip definitions      ║
╠═══════════════════════════════════════════════════════════╣
║  📦 IPLs Available: 65  | Properties: 0                   ║
║  🛡️  Admin Methods: 3   | Money: inventory                 ║
║  🌍 Language: EN   | Debug: OFF                            ║
╚═══════════════════════════════════════════════════════════╝
```

---

## ⚙️ Configuration

`config.lua` is fully self-documented. Key sections:

### Admin System

```lua
Config.AdminSystem = {
    acePermission = 'rde.ipl.admin',
    steamIds = {
        'steam:110000101605859',  -- Your Steam ID
    },
    oxGroups = {
        ['owner']      = 0,
        ['admin']      = 0,
        ['superadmin'] = 0
    },
    -- Check order is configurable
    checkOrder = {'ace', 'oxcore', 'steam'}
}
```

### Money System

```lua
Config.MoneySystem = {
    Source            = 'inventory',   -- 'inventory' or 'banking'
    InventoryItemName = 'money',       -- ox_inventory item name
    BankingAccount    = 'bank',        -- ox_core account name
    EnablePurchaseFee    = false,
    PurchaseFeePercent   = 5,
    EnableSellDiscount   = true,
    SellDiscountPercent  = 10
}
```

### Property Settings

```lua
Config.Property = {
    MaxPropertiesPerPlayer = 5,
    AllowPropertySale      = true,
    InteractionDistance    = 3.0,      -- ox_target sphere radius
    InteriorExitRadius     = 1.5,      -- exit zone radius inside property
    LockByDefault          = true,
    MaxPlayersPerInstance  = 8,
    AutoCleanupTime        = 300,      -- seconds before empty instance auto-destroys
    SaveIntervalSeconds    = 300,      -- auto-save interval
}
```

### Per-IPL Blip Override

Every entry in `Config.IPLDatabase` can define its own blip:

```lua
{
    id   = 'maze_bank_office',
    -- ...
    blip = { sprite = 475, color = 29, scale = 0.85 },  -- custom per-IPL
    -- or:
    blip = false,   -- no blip for this property
    -- or: omit blip entirely → falls back to Config.BlipSprites[category]
}
```

Sprite IDs: https://docs.fivem.net/docs/game-references/blips/

### Adding a Custom IPL

```lua
-- Add to Config.IPLDatabase in config.lua:
{
    id           = 'my_custom_ipl',
    name         = 'My Custom Location',
    category     = 'special',
    price        = 500000,
    ipl          = {'custom_ipl_name'},
    coords       = vector4(x, y, z, heading),   -- interior spawn point
    exitCoords   = vector4(x, y, z, heading),   -- exterior exit point
    maxOccupancy = 8,
    customizable = false,
    blip         = { sprite = 374, color = 6, scale = 0.85 },
    description  = 'My custom IPL description'
}
```

> **coords and exitCoords must never be identical.** The coord validator warns on startup if they are, and the client refuses to teleport.

---

## 💬 Commands

### Player Commands

| Command | Description |
|---------|-------------|
| `/myproperties` | Open your property list |
| `/exitproperty` | Exit current property (or use interior exit zone) |

### Admin Commands

| Command | Description |
|---------|-------------|
| `/ipl` | Open IPL admin control panel (triple-verified) |
| `/ipldebug` | Dump full client state (debug mode only) |

---

## 🗂 Folder Structure

```
rde_ipl/
├── fxmanifest.lua
├── config.lua          ← Config + locales (EN/DE) + 65-entry IPL database
├── README.md
├── LICENSE
├── server.lua          ← DB, instances, routing buckets, events, admin, Nostr
└── client.lua          ← IPL loading, streaming-safe teleport, blips, ox_target
```

---

## 🌍 Locales

All user-facing text lives in `Config.Languages` inside `config.lua`. Switch language by changing `Config.DefaultLanguage`:

```lua
Config.DefaultLanguage = 'de'   -- 'en' or 'de'
```

**Add a new language:**

1. Copy the `en = { ... }` block → `xx = { ... }`
2. Translate all values (keep the keys!)
3. Set `Config.DefaultLanguage = 'xx'`

Currently supported:

| Code | Language |
|------|----------|
| `en` | 🇬🇧 English |
| `de` | 🇩🇪 Deutsch |

---

## 🐉 Nostr Logging

rde_ipl ships with **first-class [rde_nostr_log](https://github.com/RedDragonElite/rde_nostr_log) integration**.

Every critical property event is logged to the decentralized Nostr network — permanent, cryptographically signed, uncensorable. No Discord. No rate limits. No single point of failure.

### Events logged automatically

| Event | Nostr Tag |
|-------|-----------|
| Property purchased | `property_purchase` |
| Property sold | `property_sale` |
| Player entered property | `property_enter` |
| Player exited property | `property_exit` |
| Admin created property | `property_created` |
| Admin deleted property | `property_deleted` |
| Admin action (update, teleport) | `admin_action` |
| Lock toggled | `property_lock_toggle` |
| Security violation attempt | `security_violation` |
| Player disconnected inside property | `disconnect_in_property` |
| Server startup | `server_startup` |
| Server shutdown | `server_shutdown` |

### Disable Nostr completely

```lua
-- rde_nostr_log simply not started → zero overhead, zero side effects
-- The system runs normally without it
```

---

## 📡 Exports

### Server

```lua
-- Get property by instance ID
local property = exports.rde_ipl:GetProperty(instanceId)

-- Get all properties (full state table)
local all = exports.rde_ipl:GetAllProperties()

-- Get properties owned by identifier
local props = exports.rde_ipl:GetPlayerProperties(identifier)

-- Check if player is inside a property
local inProperty, instanceId = exports.rde_ipl:IsPlayerInProperty(source)

-- Get active instance
local instance = exports.rde_ipl:GetActiveInstance(instanceId)

-- Force evict player from current instance
local success = exports.rde_ipl:EvictPlayer(source)

-- Get performance metrics
local stats = exports.rde_ipl:GetStatistics()
```

---

## 🗄 Database

Tables auto-create on first run — no SQL import needed.

### `rde_iplproperties`

```sql
id                 INT AUTO_INCREMENT PRIMARY KEY
instance_id        VARCHAR(64) UNIQUE NOT NULL
ipl_index          INT NOT NULL
owner_identifier   VARCHAR(60) NULL
coords             TEXT NOT NULL        -- vector4 as JSON
price              INT NOT NULL
for_sale           TINYINT(1) NOT NULL
locked             TINYINT(1) NOT NULL
customization      TEXT NULL            -- JSON
access_list        TEXT NULL            -- JSON
last_entered       VARCHAR(60) NULL
total_visits       INT DEFAULT 0
created_at         TIMESTAMP DEFAULT CURRENT_TIMESTAMP
updated_at         TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
```

### `rde_ipl_transactions`

```sql
id                 INT AUTO_INCREMENT PRIMARY KEY
instance_id        VARCHAR(64) NOT NULL
buyer_identifier   VARCHAR(60) NULL
seller_identifier  VARCHAR(60) NULL
transaction_type   ENUM('purchase','sale','transfer')
amount             INT NOT NULL
timestamp          TIMESTAMP DEFAULT CURRENT_TIMESTAMP
```

---

## 🔧 Debug Commands

Enable debug mode: set `Config.Statebag.Debug = true` in config.lua.

| Command | Description |
|---------|-------------|
| `/ipldebug` | Full client state dump — loaded IPLs, active instance, zones, blips, metrics |

Server-side debug output includes:
- Per-admin auth method confirmation
- Rate limit hits
- Instance creation/destruction with bucket IDs
- IPL load times
- Coord validator results on startup
- Performance report every 60s

---

## 🐛 Troubleshooting

### Player spawns underground / falls through the map

The coord validator caught this at startup — check server console for `⚠ IPL entries have INVALID coords` warnings. The entry has `coords` near `(0,0,0)` which is under the ocean. Fix the vector4 in `Config.IPLDatabase`.

### `coords and exitCoords IDENTICAL` warning on startup

The property would teleport players to the same spot on enter AND exit. Set `coords` to the interior spawn point and `exitCoords` to outside the door.

### "No admin methods configured" warning

Configure at least one in `Config.AdminSystem`:
```lua
steamIds = { 'steam:YOUR_STEAM_ID' }
-- or: add_ace group.admin rde.ipl.admin allow in server.cfg
```

### /ipl not opening admin menu

1. Verify you're in `Config.AdminSystem.steamIds` or have ACE `rde.ipl.admin` or are in an `oxGroups` entry
2. Check server console for `⚠️ [SECURITY] Unauthorized admin attempt` — your identifier will be logged there

### Can't enter property — "instance full"

The `maxOccupancy` for that IPL is reached. Check `Config.IPLDatabase[x].maxOccupancy` and raise it, or wait for a player to exit.

### Money not deducting

Verify `Config.MoneySystem.Source` matches your setup:
- `'inventory'` → requires `ox_inventory` running + item named `Config.MoneySystem.InventoryItemName`
- `'banking'` → requires ox_core bank account `Config.MoneySystem.BankingAccount`

### Nostr logger not connecting

```
[RDE|IPL] Nostr log failed (non-critical): ...
```

Install [rde_nostr_log](https://github.com/RedDragonElite/rde_nostr_log) and ensure it starts before `rde_ipl`. The property system continues to work normally without it — all log calls are no-ops.

### Properties not showing on map after someone buys

Known alpha limitation: other clients refresh their blips/zones on their next resource init. Will be resolved in v1.1 via StateBag change handler.

---

## 📚 Tech Stack

```
ox_core       → Player, groups, character management
ox_lib        → Context menus, progress bars, notifications, alerts, input dialogs
ox_target     → World interaction zones (exterior markers + interior exit zones)
oxmysql       → Async database (auto-create tables)
Routing Buckets → Private dimensions per property instance
StateBags     → Realtime property state sync across all clients
rde_nostr_log → Decentralized event logging (optional)
```

---

## 🤝 Contributing

PRs are always welcome.

1. **Fork** the repository
2. **Create** a branch: `git checkout -b feature/your-feature`
3. **Test** on a live server before submitting
4. **Commit**: `git commit -m 'feat: your feature description'`
5. **Push**: `git push origin feature/your-feature`
6. **Open** a Pull Request with a clear description

**Guidelines:**

- ✅ Keep the RDE header in all files
- ✅ Follow RDE OX Standards v2 — ox_core, ox_lib, StateBags, no legacy shims
- ✅ Run `luac -p` on every modified `.lua` file before pushing
- ✅ Test on a live server — especially teleport and IPL loading (void drops are the #1 issue in this script category)
- ✅ Every IPL entry needs valid, distinct `coords` and `exitCoords` — use the coord validator output
- ✅ New money operations go through `MoneySystem.hasMoney` / `removeMoney` / `addMoney` — never touch ox_inventory or ox_core accounts directly
- ✅ New admin events get `AdminSystem.isAdmin(src)` + `RDELog.securityViolation(src, ...)` on fail — no exceptions
- ✅ `StreamingSafeTeleport()` is the only teleport function — never `SetEntityCoords` naked
- ❌ No Wait() inside NetEvents — always wrap in CreateThread
- ❌ No string concat in SQL — prepared statements only
- ❌ No ESX, no QBCore, no legacy shims
- ❌ No telemetry, no paywalls

---

## 📜 License

**RDE Black Flag Source License v6.66**

```
###################################################################################
#                                                                                 #
#      .:: RED DRAGON ELITE (RDE)  -  BLACK FLAG SOURCE LICENSE v6.66 ::.         #
#                                                                                 #
#   PROJECT:    RDE_IPL (NATIVE GTA INTERIOR PROPERTY SYSTEM FOR FIVEM OX_CORE)   #
#   ARCHITECT:  .:: RDE ⧌ Shin [△ ᛋᛅᚱᛒᛅᚾᛏᛋ ᛒᛁᛏᛅ ▽] ::. | https://rd-elite.com     #
#   ORIGIN:     https://github.com/RedDragonElite                                 #
#                                                                                 #
#   WARNING: THIS CODE IS PROTECTED BY DIGITAL VOODOO AND PURE HATRED FOR LEAKERS #
#                                                                                 #
#   [ THE RULES OF THE GAME ]                                                     #
#                                                                                 #
#   1. // THE "FUCK GREED" PROTOCOL (FREE USE)                                    #
#      You are free to use, edit, and abuse this code on your server.             #
#      Learn from it. Break it. Fix it. That is the hacker way.                   #
#      Cost: 0.00€. If you paid for this, you got scammed by a rat.               #
#                                                                                 #
#   2. // THE TEBEX KILL SWITCH (COMMERCIAL SUICIDE)                              #
#      Listen closely, you parasites:                                             #
#      If I find this script on any paid store, Patreon, or "Premium Pack":       #
#      > I will DMCA your store into oblivion.                                    #
#      > I will publicly shame your community on Nostr. Permanently.              #
#      > I hope every teleport lands you 300 meters under the ocean.              #
#      SELLING FREE WORK IS THEFT. AND I AM THE JUDGE.                            #
#                                                                                 #
#   3. // THE CREDIT OATH                                                         #
#      Keep this header. If you remove my name, you admit you have no skill.      #
#      You can add "Edited by [YourName]", but never erase the original creator.  #
#      Don't be a skid. Respect the architecture.                                 #
#                                                                                 #
#   4. // THE CURSE OF THE COPY-PASTE                                             #
#      This code implements streaming-safe teleports, routing buckets,            #
#      per-IPL blip systems, and triple-layer admin auth. If you copy-paste       #
#      without understanding, you WILL drop players into the void.                #
#      Don't come crying to my DMs. RTFM.                                         #
#                                                                                 #
#   --------------------------------------------------------------------------    #
#   "We build the future on the graves of paid resources."                        #
#   "REJECT MODERN MEDIOCRITY. EMBRACE RDE SUPERIORITY."                          #
#   --------------------------------------------------------------------------    #
###################################################################################
```

**TL;DR:**

- ✅ **Free forever** — use it, edit it, learn from it
- ✅ **Keep the header** — credit where it's due
- ❌ **Don't sell it** — commercial use = instant DMCA + public shaming on Nostr
- ❌ **Don't be a skid** — copy-paste without reading will void your players

---

## ⚡ Related Projects

| Resource | Description |
|----------|-------------|
| [rde_nostr_log](https://github.com/RedDragonElite/rde_nostr_log) | Decentralized FiveM logging via Nostr — replace Discord forever |
| [rde_doors](https://github.com/RedDragonElite/rde_doors) | Full door system — lockpick, passcode, group auth, sliding/automatic |
| [rde_elevators](https://github.com/RedDragonElite/rde_elevators) | Elevator system with statebag sync and per-floor access |
| [rde_aipd](https://github.com/RedDragonElite/rde_aipd) | Next-gen AI Police & Crime System — StateBag-synced, Nostr-logged |
| [awesome-ox-rde](https://github.com/RedDragonElite/awesome-ox-rde) | Curated list of the best ox_core resources |

---

## 🌐 Community & Support

| | |
|---|---|
| 🌍 **Website** | [rd-elite.com](https://rd-elite.com) |
| 🔭 **Nostr Terminal** | [rd-elite.com/Files/NOSTR/Terminal](https://rd-elite.com/Files/NOSTR/Terminal/) |
| 🐙 **GitHub** | [github.com/RedDragonElite](https://github.com/RedDragonElite) |
| 🟣 **Nostr** | `npub1wr4e24zn6zzjqx8kvnelfvktf0pu6l2gx4gvw06zead2eqyn23sq9tsd94` |

**Before opening an issue:**

- ✅ Read this README fully — especially [Troubleshooting](#-troubleshooting)
- ✅ Check server console for coord validator warnings on startup
- ✅ Include your server console output and F8 client logs
- ❌ Don't open issues without logs — we can't help without them

---

**Made with 🔥 and void-proof engineering by [Red Dragon Elite](https://rd-elite.com)**

*The future is ours. We are already inside.*

**REJECT MODERN MEDIOCRITY. EMBRACE RDE SUPERIORITY.**

**RDE FOREVER. SYSTEM FAILURE. ⚡777⚡**

[![Website](https://img.shields.io/badge/Website-Visit-red?style=for-the-badge&logo=google-chrome)](https://rd-elite.com)
[![Nostr](https://img.shields.io/badge/Nostr-Follow-purple?style=for-the-badge&logo=rss)](https://primal.net/p/npub1wr4e24zn6zzjqx8kvnelfvktf0pu6l2gx4gvw06zead2eqyn23sq9tsd94)
[![Terminal](https://img.shields.io/badge/Terminal-Live-green?style=for-the-badge&logo=gnome-terminal)](https://rd-elite.com/Files/NOSTR/)

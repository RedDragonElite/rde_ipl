-- ╔═══════════════════════════════════════════════════════════╗
-- ║  RDE | IPL MANAGER v1.0.1-alpha           ║
-- ║  Author: RDE | SerpentsByte                               ║
-- ║  Statebag-first, collision-safe IPL teleports             ║
-- ║  + ox_target sphere zone inside each property             ║
-- ║  + Per-IPL map blip sprite/color/scale                    ║
-- ║  100+ IPL slots | ox_core exclusive                       ║
-- ╚═══════════════════════════════════════════════════════════╝

fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'RDE | IPL MANAGER'
author 'RDE | SerpentsByte'
description 'IPL property system with collision-safe streaming, interior exit target, per-IPL blips, statebag sync, triple admin, ox_core'
version '1.0.1'

-- 🔧 DEPENDENCIES (ox_core EXCLUSIVE)
dependencies {
    'ox_core',
    'ox_lib',
    'oxmysql',
    'ox_target'
}

-- 📁 RESOURCE FILES
shared_scripts {
    '@ox_lib/init.lua',
    '@ox_core/lib/init.lua',
    'config.lua'
}

client_scripts {
    'client.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server.lua'
}

-- 📊 v1.0.1-alpha CHANGELOG
--[[
    🔥 v1.3.0 — Per-IPL Blips Edition (2026-05)

    ✅ NEW:
    • Each IPL in Config.IPLDatabase can now define its own map blip:
        blip = { sprite = <int>, color = <int>, scale = <float> }
      where sprite/color come from
      https://docs.fivem.net/docs/game-references/blips/
    • blip = false on an entry disables the blip for that property entirely.
    • Omitting `blip` falls back to the old behaviour
      (Config.BlipSprites[category] + Config.BlipColors.owned/forSale),
      so anything you didn't touch keeps working.
    • All 65 shipped IPL entries received hand-picked blip definitions —
      e.g. Weed Farm -> sprite 496 (production_weed) in green, Cocaine
      Lockup -> 497, Counterfeit -> 500, Bunker -> 557 (property_bunker) in
      military grey, FIB -> 105 (fbi_heist), Submarine -> 308 (sub),
      Eclipse Suites -> 475 office, North Yankton -> 7 (radar_north), etc.
    • For-sale blip color stays yellow (Config.BlipColors.forSale)
      regardless of per-IPL color override, so the "buyable" visual cue
      is consistent.

    🔥 v1.2.0 — Interior Exit Target (2026-05)
    • ox_target sphere zone inside the property on enter, removed on exit.
    • Per-IPL interiorExit / interiorExitRadius overrides.

    🔥 v1.1.0 — Streaming-Safe Edition (2026-05)
    • RequestCollisionAtCoord gate + FreezeEntityPosition during teleport.
    • Coord validator at resource start.

    🔧 UPGRADE NOTES (from v1.2):
    • Drop-in replacement. Database schema unchanged.
    • Existing properties get the new blips automatically on next zone refresh
      (or just restart the resource).
    • If you customize an IPL entry yourself, add a blip line like
        blip = { sprite = 374, color = 6, scale = 0.85 },
      directly after `customizable = ...`. Or omit it for category default.
]]

--[[
Base of the ship templates, from here different classes of ships are included to be used within the game.
Each sub-file defines it's own set of ship classes.

These are:
* Stations: For different kinds of space stations, from tiny to huge.
* Starfighters: Smallest ships in the game.
* Frigates: Medium sized ships. Operate on a small crew.
* Covette: Large, slower, less maneuverable ships.
* Dreadnaught: Huge things. Everything in here is really really big, and generally really really deadly.

Player ships are in general large frigates to small corvette class
--]]
require("shipTemplates_Stations.lua")
---[[Until these are ready, they are disabled
require("shipTemplates_StarFighters.lua")
require("shipTemplates_Frigates.lua")
require("shipTemplates_Corvette.lua")
require("shipTemplates_Dreadnaught.lua")
--]]
--For now, we add our old ship templates as well. These should be removed at some point.
require("shipTemplates_OLD.lua")

--Custom
template = ShipTemplate():setName("Pirate Freighter"):setClass("Corvette", "Freighter"):setModel("transport_4_4")
template:setDescription([[Pirate freighters have been adapted to hold a variety of scavenge and plunder.]])
template:setHull(100)
template:setShields(100, 80, 80)
template:setSpeed(60 - 5 * 4, 6, 10)
template:setRadarTrace("radar_transport.png")
--                  Arc, Dir, Range, CycleTime, Dmg
template:setBeam(0, 50,-15, 1000.0, 6.0, 8)
template:setBeam(1, 50, 15, 1000.0, 6.0, 8)
template:setWarpSpeed(750)



template = ShipTemplate():setName("Dalek Saucer"):setClass("Starfighter", "Fighter"):setModel("dalek_saucer")
template:setRadarTrace("radar_fighter.png")
template:setDescription([[Flying saucers were the most common spaceships used by the Daleks from their early history, through the Last Great Time War and beyond, proving to be an integral part of the Dalek war machine.]])
--                  Arc, Dir, Range, CycleTime, Dmg
template:setBeam(0, 360, 0, 1000.0, 4.0, 4)
template:setHull(30)
template:setShields(30)
template:setSpeed(125, 32, 25)
template:setDefaultAI('fighter')	-- set fighter AI, which dives at the enemy, and then flies off, doing attack runs instead of "hanging in your face".


template = ShipTemplate():setName("Dalek Flagship"):setModel("dalek_saucer_large")
template:setDescription([[The Dalek flagship was the main warship of the Dalek Fleet. Like many of the other ships, it was a flying saucer, but was many times larger than the size of the standard Dalek flying saucer.]])
template:setHull(200)
template:setShields(300, 300, 300)
template:setBeam(0, 30,   0, 4000.0, 4.0, 4)
template:setBeam(1, 30,  60, 4000.0, 4.0, 4)
template:setBeam(2, 30, 120, 4000.0, 4.0, 4)
template:setBeam(3, 30, 180, 4000.0, 4.0, 4)
template:setBeam(4, 30, 240, 4000.0, 4.0, 4)
template:setBeam(5, 30, 300, 4000.0, 4.0, 4)
template:setRadarTrace("radartrace_largestation.png")
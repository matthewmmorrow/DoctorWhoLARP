-- Name: Search Party
-- Description: The Doctor and companions are aboard the HMS Pasteur. The TARDIS is missing. 
--- Help the captain of the Reaper to deliver crucial medicine and then find the TARDIS.
-- Type: Mission

require("utils.lua")

function commsSickStation()
    if comms_target.comms_data == nil then
        comms_target.comms_data = {}
    end
    if comms_target:areEnemiesInRange(5000) then
        setCommsMessage("We are under attack! No time for chatting!");
        return true
    end
    if sub_medicine == sub_medicine_deliver then
		setCommsMessage("This station is under quarantine. Do you have the medicine you are set to deliver?")
		addCommsReply("Yes.", function()
            setCommsMessage("Then bring it urgently! People are sick!");
        end)
	elseif sub_medicine == sub_medicine_helped then
		setCommsMessage("Everyone here is feeling much better. We cannot thank you enough!")
	elseif sub_medicine == sub_medicine_sold then
		setCommsMessage("Someone alerted us to a huge sale of medicine on the black market. Looks like we are going to have to get help some other way...")
	else
	end
    return true
end

function pickupTardis()
	has_tardis = true
	globalMessage("TARDIS Materializing...")
end

function pickupSupply()
	player:setEnergy(player:getEnergy() + 200)
end

function addSupply(x,y)
	supply=Artifact():setModel("ammo_box"):setCallSign("?????"):setPosition(x,y):setScanningParameters(1,1):onPickUp(pickupSupply)
	table.insert(supplyList, supply);
end
function lowerWaypoint(x,y)
	--position.y = position.y - 1000
	return x,y+1000
end

function addWaypoints()
	for _, supply in ipairs(supplyList) do
		if supply:isValid() then
			player:commandAddWaypoint(lowerWaypoint(supply:getPosition()))
		end
	end
	
	if tardis:isValid() then
		player:commandAddWaypoint(lowerWaypoint(tardis:getPosition()))
	end
	
	if dalek_flagship:isValid() then
		player:commandAddWaypoint(lowerWaypoint(dalek_flagship:getPosition()))
	end
end

function addNebula(x,y)
	Nebula():setPosition(x,y)
	dalek = addDalek(x,y):orderStandGround()
	table.insert(dalekList, dalek);
end

function powerDown()
    for _, system in ipairs({"reactor", "beamweapons", "missilesystem", "maneuver", "impulse", "warp", "jumpdrive", "frontshield", "rearshield"}) do
        player:setSystemHealth(system, 0.5)
        player:setSystemHeat(system, 0.0)
        player:setSystemPower(system, 0.0)
        player:commandSetSystemPowerRequest(system, 0.0)
        player:setSystemCoolant(system, 0.0)
        player:commandSetSystemCoolantRequest(system, 0.0)
    end
end

function powerUp()
    for _, system in ipairs({"reactor", "beamweapons", "missilesystem", "maneuver", "impulse", "warp", "jumpdrive", "frontshield", "rearshield"}) do
        player:setSystemHealth(system, 1.0)
        player:setSystemHeat(system, 0.0)
        player:setSystemPower(system, 1.0)
        player:commandSetSystemPowerRequest(system, 1.0)
        player:setSystemCoolant(system, 0.0)
        player:commandSetSystemCoolantRequest(system, 0.0)
    end
end

dalek_names = {"Von", "Sin", "Thar", "Daay", "Gaas", "Chay", "Ghar", "Ghis", "Then", "Vaad", "Chok", "Khec", "Gec", "Char", "Ces", "Got", "Chass", "Raas", "Khir", "Cid", "Thok", "Chen", "Dath", "Khess", "Dhan", "Geth", "Kir", "Dest", "Khod", "Chac", "Roc", "Kad", "Choth", "Thaan", "Dhoy", "Kham", "Daass", "Cheth", "Ghith", "Cham", "Saast", "Sey", "Chat", "Dhet", "Dey", "Kest", "Dom", "Chem", "Vac", "Das", "Sem", "Dor", "Kheth", "Khast", "Thass"}
dalek_name_idx = 0
function addDalek(x,y)
	dalek_name_idx = dalek_name_idx + 1
	if(dalek_name_idx >= 55) then
		dalek_name_idx = 0
	end

	return CpuShip():setShipTemplate("Dalek Saucer"):setFaction("Daleks"):setCallSign("Dalek ".. dalek_names[dalek_name_idx] .." Drone"):setPosition(x,y)
end

-- Init is run when the scenario is started. Create your initial world
function init()
    -- Create the main ship for the players.
    player = PlayerSpaceship():setFaction("Human Navy"):setTemplate("Atlantis"):setCallSign("HMS Pasteur"):setCanBeDestroyed(false)
	powerDown();
    
    --Create two stations
    pirate_station = SpaceStation():setTemplate("Medium Station"):setFaction("Independent"):setPosition(23500, 56100):setCallSign("Styx Market"):setScanningParameters(1,1)
    player:commandAddWaypoint(23500-250, 56100-250)

    sick_station = SpaceStation():setTemplate("Large Station"):setFaction("Human Navy"):setPosition(-25200, 52200):setCallSign("Celebration Station"):setCommsScript(""):setCommsFunction(commsSickStation)
	player:addToShipLog("Celebration Station: ...Quarantine...Quarantine...Quarantine...Quarantine...","Green")
	
    --Create nebulae in the system, with daleks.
	dalekList = {}
    addNebula( -8000,-38300)
    addNebula( 24000,-30700)
    addNebula( 42300,  3100)
    addNebula( 49200, 10700)
    addNebula(  3750, 31250)
    addNebula(-39500, 18700)
    addNebula(23500, 16100)

    --Create 100 asteroids.
    for asteroid_counter=1,500 do
        Asteroid():setPosition(random(-35000, -5000), random(-10000, 50000))
        VisualAsteroid():setPosition(random(-35000, -5000), random(-10000, 50000))
    end
    
    reaper=CpuShip():setShipTemplate("Pirate Freighter"):setFaction("Human Navy"):setCallSign("Reaper"):setPosition(1000, 1000):orderDefendTarget(player)
    dalek_test = addDalek(0,-20000):orderIdle()
	
	--Create supplies
	supplyList = {}
	addSupply(-45000,-15000);
	addSupply(50000,0);
	addSupply(35000,10000);
	addSupply(38500, 56100);
	addSupply(-45200, 52200); --near sick station
	
	--Create tardis
    tardis=Artifact():setModel("tardis"):setCallSign("??????"):setPosition(-30000,-50000):setScanningParameters(1,1):onPickUp(pickupTardis)

	--Create 2 mines around tardis
	Mine():setPosition(-40000,-40000):setCallSign("Mine")
	Mine():setPosition(-20000,-40000):setCallSign("Mine")
	
    dalek_flagship = CpuShip():setShipTemplate("Dalek Flagship"):setFaction("Daleks"):setCallSign("Dalek Command"):setPosition(60000, -50000)
    
    resetMedicine();
	
    dalek_delay_time = 300.0
    dalek_delay = dalek_delay_time
	
	sick_comms_delay = 120.0
	
	mission_state = tutorial1
end

function checkAmbush()
	--If player gets close, set ambush
	for _, dalek in ipairs(dalekList) do
		if dalek:isValid() then
			if distance(dalek, player) < 15000 then
				dalek:orderRoaming()
			end
		end
	end
end

function checkScans()
	for _, supply in ipairs(supplyList) do
		if supply:isValid() then
			if supply:isScannedBy(player) then
				supply:setCallSign("Supply")
			end
		end
	end
	if tardis:isValid() then
		if tardis:isScannedBy(player) then
			tardis:setCallSign("TARDIS")
		end
	end
end

function tutorial1(delta)
	reaper:sendCommsMessage(player, "I've added the Styx Market as a waypoint in H6. Please take the medicine straight there.")
	mission_state = tutorial2
end

function tutorial2(delta)
	if(not dalek_test:isValid()) then
		mission_state = main_mission
		reaper:sendCommsMessage(player, "As a show of good faith, we've added waypoints to all the anomolies we've detected in the area. Now take the medicine to Styx.")
		addWaypoints()
	end
end

function main_mission(delta)
	if(delta > 0) then --unpaused
		checkAmbush();
		checkScans();
		checkSpawns(delta);
	end
	
	if(sub_medicine ~= nil) then
		sub_medicine(delta)
	end
	
	if(sub_tardis ~= nil) then
		sub_tardis(delta)
	end
end

function sub_medicine_deliver(delta)
	
	if(sick_comms_delay ~= nil) then
		sick_comms_delay = sick_comms_delay - delta
		if(sick_comms_delay <= 0) then
			sick_station:openCommsTo(player)
			sick_comms_delay = nil
		end
	end
	
	
	if player:isDocked(sick_station) then
		giveMedicine()
	elseif player:isDocked(pirate_station) then
		sellMedicine()
	elseif (not warned_player) and distance(player, sick_station) < 25000 then
		reaper:sendCommsMessage(player, "You are going the wrong way!!! Take the medicine to Styx!")
		warned_player = true
	elseif warned_player and distance(player, sick_station) < 10000 then
		if(reaper:isValid() and reaper:getFaction() == "Human Navy") then
			reaper:setFaction("Kraylor"):orderAttack(player):sendCommsMessage(player, "I can't let you deliver that there, it's worth too much! I guess we will just have to stop you the hard way!")
		end
	end
end

function sub_medicine_sold(delta)
	if player:isDocked(sick_station) then
		sick_station:sendCommsMessage(player, "You cannot dock here, we are under quarantine!")
		player:commandUndock()
		player:commandAbortDock()
    elseif player:isDocked(pirate_station) then
		
	elseif(reaper:isValid() and reaper:getFaction() == "Human Navy") then
		reaper:setFaction("Kraylor"):orderAttack(player):sendCommsMessage(player, "Thanks, you have made us very rich. Now we will be taking your ship too!")
	end
end

function sub_medicine_helped(delta)
	if player:isDocked(sick_station) then
		
    elseif player:isDocked(pirate_station) then
		pirate_station:sendCommsMessage(player, "We have no time for you if you do not have any goods.")
		player:commandUndock()
		player:commandAbortDock()
	elseif(reaper:isValid() and reaper:getFaction() == "Human Navy") then
		reaper:setFaction("Kraylor"):orderAttack(player):sendCommsMessage(player, "What are you doing? You were supposed to take that to Styx! I guess we will just have to take that ship back!")
	end
end

function checkSpawns(delta)
	--Spawn new Daleks every so often
    dalek_delay = dalek_delay - delta
    if(dalek_delay <= 0) then
		if not dalek_flagship:isValid() then
			dalek_delay = 60.0 * 120
		else 
			dalek_delay = random(180.0,300.0)
			dalek=addDalek(60000, -50000):orderRoaming()
		end
    end
end

function playerShipMins()
	if(player:getScanProbeCount() < 2) then
		player:setScanProbeCount(2)
	end
	
	if(player:getEnergy() < 100) then
		player:setEnergy(100)
	end
	
	if(player:getWeaponStorage("Homing") < 2) then
		player:setWeaponStorage("Homing", 2)
	end
end

function update(delta)
	playerShipMins();
	
	if(mission_state ~= nil) then
		mission_state(delta)
	end
end

function resetMedicine()
	sub_medicine = sub_medicine_deliver
	
	clearGMFunctions()
	addGMFunction("Sell Medicine", sellMedicine)
	addGMFunction("Give Medicine", giveMedicine)
	addGMFunction("Power Up", powerUp)
end

function sellMedicine()
	sub_medicine = sub_medicine_sold
	
	pirate_station:sendCommsMessage(player, "That's quite the cargo! It will be worth a pretty penny.")
	
	clearGMFunctions()
	addGMFunction("Sold: Reset Medicine", resetMedicine)

end

function giveMedicine()
	sub_medicine = sub_medicine_helped
		
	sick_station:sendCommsMessage(player, "Thank you so much! You have helped many people today!")

	clearGMFunctions()
	addGMFunction("Delivered: Reset Medicine", resetMedicine)
end

function distance(obj1, obj2)
    local x1, y1 = obj1:getPosition()
    local x2, y2 = obj2:getPosition()
    local xd, yd = (x1 - x2), (y1 - y2)
    return math.sqrt(xd * xd + yd * yd)
end
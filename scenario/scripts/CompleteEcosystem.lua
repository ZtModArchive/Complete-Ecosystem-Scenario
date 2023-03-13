include("scenario/scripts/misc.lua")
include("scenario/scripts/ui.lua")
include("scenario/scripts/entity.lua")
include("scenario/scripts/needs.lua")
include("scenario/scripts/economy.lua")
include("scenario/scripts/token.lua")

HERBIVORE_QUOTA = 6
CARNIVORE_QUOTA = 4
MONTH_QUOTA = 4
SHAREDHABITAT_BUFFER = 3

evaldebugging = function()

----- Debug Entity Pos
    try(
        function ()
            local guest = resolveTable(findType("Guest_Adult_F")[1].value)
            guest:BFG_SET_ATTR_STRING("s_name", "LoliJuicy")
            local pos = guest:BFG_GET_ENTITY_POSITION()
            print("Pos X=" .. pos.x .. " Y=" .. pos.y)
            io.flush()
        end
    )
    
----- Debug giveCash
    if getglobalvar("HERBIVOREIDS") == nil then
        giveCash(500000)
    end
	
----- Setting up IDs... 
    if getglobalvar("HERBIVOREIDS") ~= nil and getglobalvar("CARNIVOREIDS") ~= nil then
        

        local herbivores = split(getglobalvar("HERBIVOREIDS"), ",")
        local carnivores = split(getglobalvar("CARNIVOREIDS"), ",")

        if table.getn(herbivores) >= HERBIVORE_QUOTA and table.getn(carnivores) >= CARNIVORE_QUOTA then
            setRuleState("HugeBiomeoverall", "neutral")
            showRule("HugeBiomeoverall")
            completeshowoverview()
            return 1
        end
    end

	if checkForHerbivoreCarcasses() then
		setRuleState("HugeBiomequota", "failure")	
		return -1
	end
	
    setSavannahAnimalsLists()
    return 0	
end

--- Main evaluation
--- @return number
evalhugebiome = function(l_2_arg0)
	
	if l_2_arg0.quotaDone == nil then
	    if getglobalvar("HERBIVOREIDS") ~= nil and getglobalvar("CARNIVOREIDS") ~= nil then
	
			local herbivores = split(getglobalvar("HERBIVOREIDS"), ",")
			local carnivores = split(getglobalvar("CARNIVOREIDS"), ",")

			if table.getn(herbivores) >= HERBIVORE_QUOTA and table.getn(carnivores) >= CARNIVORE_QUOTA then
				if countSavannahAnimalsInSameHabitat() >= HERBIVORE_QUOTA then				
					genericokpanel(nil, "TheWorld:HugeBiomeoverallquotadone")
					setRuleState("HugeBiomequota", "success")
					showRule("HugeBiomecounter")
					l_2_arg0.quotaDone = 1
				end		
			end
		end	
	end

	if l_2_arg0.quotaDone == 1 and l_2_arg0.counterDone == nil then
	
		local startingMonth = getglobalvar("STARTINGMONTH")
		local allowanceMonth = getglobalvar("ALLOWANCEMONTH")
		local strikes = getglobalvar("SHAREDHABITATSTRIKES")

		if startingMonth == nil then
			setglobalvar("STARTINGMONTH", tostring(getCurrentMonth()))
			startingMonth = getglobalvar("STARTINGMONTH")
		end

		if countSavannahAnimalsInSameHabitat() >= HERBIVORE_QUOTA then
			if (tonumber(startingMonth) + MONTH_QUOTA <= getCurrentMonth()) then
				setRuleState("HugeBiomecounter", "success")
				l_2_arg0.counterDone = 1
				return 1
			end
		elseif tonumber(strikes) >= SHAREDHABITAT_BUFFER then
			setglobalvar("STARTINGMONTH", tostring(getCurrentMonth()))
			setRuleState("HugeBiomequota", "neutral")
			hideRule("HugeBiomecounter")
			genericokpanel(nil, "TheWorld:HugeBiomeoverallquotafailed")
			l_2_arg0.quotaDone = nil
        else
            setglobalvar("SHAREDHABITATSTRIKES", tonumber(strikes) + 1)
		end

		if tostring(getCurrentMonth()) ~= allowanceMonth then
			giveCash(2000)
			setglobalvar("ALLOWANCEMONTH", tostring(getCurrentMonth()))
		end
	end

	if checkForHerbivoreCarcasses() then
		setRuleState("HugeBiomequota", "failure")
		setRuleState("HugeBiomecounter", "failure")

		if guestHasNearbyCarcass() == true then
			failwitnessworldcampaignscen4()
		else
			return -1
		end	
	end
	
    setSavannahAnimalsLists()
    return 0
end

completehugebiome = function()
end

completeworldcampaignscen4 = function()
   BFLOG(SYSTRACE, "completeworldcampaignscen4")
   setuservar("worldcampaignscenario4", "completed")
   setuservar("globelock", "true")
   local l_6_0 = getlocidfromspecies("Statue_Globe_df")
   local l_6_1 = getLocID("itemunlock:newitemgeneral") .. l_6_0
   genericokpaneltext(nil, l_6_1)  
   showscenariowin("TheWorld:HugeBiomeSuccessoverview", nil)  
end

failworldcampaignscen4 = function()
   showscenariofail("TheWorld:HugeBiomeFailureoverview", "worldcampaignscenario4")
end

failwitnessworldcampaignscen4 = function()
   showscenariofail("TheWorld:HugeBiomeFailureWitnessedoverview", "worldcampaignscenario4")
end

--- Sets global variables CARNIVORE_IDS and HERBIVORE_IDS
--- @param disableRelease bool
--- @return void
---- ID List Setup
setSavannahAnimalsLists = function()
    local savannahAnimals = getAnimalsFromBiome("savannah")
    local carnivoreIds = ""
    local herbivoreIds = ""

    if savannahAnimals == nil then
        return
    end

    local herbivoreIndex = 1
    for i = 1, table.getn(savannahAnimals) do
        local animal = resolveTable(savannahAnimals[i].value)

        if animal:BFG_GET_ATTR_BOOLEAN("b_Carnivore") then
            animal:BFG_SET_ATTR_BOOLEAN("b_showAdopt", false)
            animal:BFG_SET_ATTR_BOOLEAN("b_showRelease", false)
            animal:BFG_SET_ATTR_BOOLEAN("b_showCrate", false)

            if carnivoreIds == "" then
                carnivoreIds = carnivoreIds .. getID(animal)
            else
                carnivoreIds = carnivoreIds .. "," .. getID(animal)
            end
        end
		---- Disables Adopt, Release, and Crate to prevent loopholes
        if animal:BFG_GET_ATTR_BOOLEAN("b_Folivore") or animal:BFG_GET_ATTR_BOOLEAN("b_Granivore") or animal:BFG_GET_ATTR_BOOLEAN("b_Graminivore") then
            animal:BFG_SET_ATTR_BOOLEAN("b_showAdopt", false)
            animal:BFG_SET_ATTR_BOOLEAN("b_showRelease", false)
            animal:BFG_SET_ATTR_BOOLEAN("b_showCrate", false)

            if herbivoreIds == "" then
                herbivoreIds = herbivoreIds .. getID(animal)
            else
                herbivoreIds = herbivoreIds .. "," .. getID(animal)
            end

            setglobalvar("HERBIVORE"..herbivoreIndex, animal:BFG_GET_ATTR_STRING("s_name"))
            setglobalvar("HERBIVOREID"..herbivoreIndex, ""..getID(animal))
            herbivoreIndex = herbivoreIndex + 1
        end
    end

    setglobalvar("CARNIVOREIDS", carnivoreIds)
    setglobalvar("HERBIVOREIDS", herbivoreIds)
end

--- Returns how many savannah herbivores share a habitat with a savannah carnivore
--- @return number
countSavannahAnimalsInSameHabitat = function()
    local savannahAnimals = getAnimalsFromBiome("savannah")
    local herbivoresInCarnivoreHabitat = 0
    local carnivores = {}
    local herbivores = {}
    for i = 1, table.getn(savannahAnimals) do
        local animal = resolveTable(savannahAnimals[i].value)
        if animal:BFG_GET_ATTR_BOOLEAN("b_Carnivore") then
            table.insert(carnivores, savannahAnimals[i])
        end
        if animal:BFG_GET_ATTR_BOOLEAN("b_Folivore") or animal:BFG_GET_ATTR_BOOLEAN("b_Granivore") then
            table.insert(herbivores, savannahAnimals[i])
        end
    end

    for i = 1, table.getn(herbivores) do
        local sharesHabitatWithCarnivore = 0
        local herbivore = resolveTable(herbivores[i].value)

        for j = 1, table.getn(carnivores) do
            local carnivore = resolveTable(carnivores[j].value)
            if inSameHabitat(herbivore, carnivore) then
                sharesHabitatWithCarnivore = sharesHabitatWithCarnivore + 1
            end
        end

        if sharesHabitatWithCarnivore >= CARNIVORE_QUOTA then
            herbivoresInCarnivoreHabitat = herbivoresInCarnivoreHabitat + 1
        end
    end
	
    return herbivoresInCarnivoreHabitat
end
	
--- Checks if all there is a carcass belonging to a savannah herbivore present
--- @return bool
checkForHerbivoreCarcasses = function()
    local endOfHerbivoreNames = false
    local carcasses = findType("Carcass_Meat")

    if carcasses == nil then
        return false
    end

    local savannahAnimals = getAnimalsFromBiome("savannah")
    local herbivoreIds = {}
    for i = 1, table.getn(savannahAnimals) do
        local animal = resolveTable(savannahAnimals[i].value)
        if animal:BFG_GET_ATTR_BOOLEAN("b_Folivore") or animal:BFG_GET_ATTR_BOOLEAN("b_Granivore") or animal:BFG_GET_ATTR_BOOLEAN("b_Graminivore") then
            table.insert(herbivoreIds, getID(animal))
        end
    end

    local herbivoreIndex = 1
    while(endOfHerbivoreNames == false) do

        if getglobalvar("HERBIVORE"..herbivoreIndex) == nil or getglobalvar("HERBIVORE"..herbivoreIndex) == "" then
            endOfHerbivoreNames = true
            return false
        end
        
        for i = 1, table.getn(carcasses) do
            local carcass = resolveTable(carcasses[i].value)

            if string.find(carcass:BFG_GET_ATTR_STRING("s_name"), getglobalvar("HERBIVORE"..herbivoreIndex)) then
                local herbivoreWasFound = false
                for j = 1, table.getn(herbivoreIds) do
                    if herbivoreIds[j] == tonumber(getglobalvar("HERBIVOREID"..herbivoreIndex)) then
                        herbivoreWasFound = true
                    end
                end

                if not herbivoreWasFound then
					setglobalvar("CARCASSFOUND", carcass:BFG_GET_ATTR_STRING("s_name"))
					setglobalvar("CARCASSFOUNDID", ""..getID(carcass))	
                    return true
                end
            end
        end

        setglobalvar("HERBIVORE"..herbivoreIndex, "")
        setglobalvar("HERBIVOREID"..herbivoreIndex, "")

        herbivoreIndex = herbivoreIndex + 1
    end
end

--- Checks if all savannah herbivores from the global HERBIVORE_IDS are still present
--- @return bool
checkHerbivoresAlive = function()
    local savedHerbivoreIds = split(getglobalvar("HERBIVOREIDS"), ",")
    local savannahAnimals = getAnimalsFromBiome("savannah")
    local herbivoreIds = {}

    if savedHerbivoreIds == nil or savannahAnimals == nil then
        return false
    end

    for i = 1, table.getn(savannahAnimals) do
        local animal = resolveTable(savannahAnimals[i].value)
        if animal:BFG_GET_ATTR_BOOLEAN("b_Folivore") or animal:BFG_GET_ATTR_BOOLEAN("b_Granivore") or animal:BFG_GET_ATTR_BOOLEAN("b_Graminivore") then
            table.insert(herbivoreIds, getID(animal))
        end
    end

    for i = 1, table.getn(savedHerbivoreIds) do

        local savedHerbivoreId = savedHerbivoreIds[i]
        local stillExists = false

        for j = 1, table.getn(herbivoreIds) do
            if tonumber(herbivoreIds[j]) == tonumber(savedHerbivoreId) then
                stillExists = true
            end
        end

        if not stillExists then
            return false
        end
    end

    return true
end

--- Checks if a guest is near a herbivore carcass
--- @return bool
guestHasNearbyCarcass = function()
    local guests = findType("Guest")
    local carcasses = findType("Carcass_Meat")
	local carcassID
	local carcassPos
	
    if guests == nil or getglobalvar("CARCASSFOUND") == nil or getglobalvar("CARCASSFOUND") == "" then
        return false
	else
		carcassID = tonumber(getglobalvar("CARCASSFOUNDID"))
		carcassPos = findEntityByID(carcassID):BFG_GET_ENTITY_POSITION()	
    end
    
    for i = 1, table.getn(guests) do
        local guest = resolveTable(guests[i].value)
        
        if hasCarcassWithinRange(guest, carcassPos, 5, 30) then
			local luckywinner = guest:BFG_GET_ATTR_STRING("s_name")
		--	print("The lucky winner is..." .. luckywinner .. "!")
		--	io.flush()
            return true
        end
    end
    
    return false
end

--- Checks if a guest is within range of carcass
--- @return bool
hasCarcassWithinRange = function(entity, entitiesToCompare, min, max)
    if entity == nil or entitiesToCompare == nil then
        return false
    end
    
    local guestPos = entity:BFG_GET_ENTITY_POSITION()

    local distance = getDistance(guestPos, entitiesToCompare)
        
--    print(distance)
--    io.flush()

    if distance >= min and distance <= max then
        return true
    end
    
    return false
end

--- Checks if entity is nearby another entity
--- @return bool
HasNearbyEntity = function(e1, e2)
    local type1 = findType("e1")
    local type2 = findType("e2")

    if type2 == nil or type1 == nil then
        return false
    end
    
    for i = 1, table.getn(type1) do
        local et1 = resolveTable(type1[i].value)
        
        if hasEntityWithinRange(et1, e2, 5, 30) then
            return true
        end
    end
    
    return false
end

--- Checks if nearby entity is within range of another entity
--- @return bool
hasEntityWithinRange = function(entity, entitiesToCompare, min, max)
    if entity == nil or entitiesToCompare == nil then
        return false
    end
    
    local originalPos = entity:BFG_GET_ENTITY_POSITION()

    for i = 1, table.getn(entitiesToCompare) do
        local compareEntity = resolveTable(entitiesToCompare[i].value)
        local comparePos = compareEntity:BFG_GET_ENTITY_POSITION()
        local distance = getDistance(originalPos, comparePos)
        
    --    print(distance)
    --    io.flush()

        if distance <= min and distance >= max then
            return true
        end
    end
    
    return false
end

getDistance = function(p1, p2)
    local deltaX = p1.x - p2.x
    local deltaY = p1.y - p2.y
    return math.sqrt(deltaX * deltaX + deltaY * deltaY)
end

function try(func)
    -- Try
    local status, exception = pcall(func)
    -- Catch
    if not status then
        print("ERROR: " .. exception)
        io.flush()
        -- Show exception in the message panel in-game
        local increment = 50
        for i = 0, string.len(exception), increment do
            displayZooMessageTextWithZoom(string.sub(exception, i, i + increment - 1), 1, 30)
        end
    end
end

function split(stringValue, delimiter)
    local result = {}
    local from = 1
    local delim_from, delim_to = string.find(stringValue, delimiter, from)
    while delim_from do
        table.insert(result, string.sub(stringValue, from, delim_from - 1))
        from = delim_to + 1
        delim_from, delim_to = string.find(stringValue, delimiter, from)
    end
    table.insert(result, string.sub(stringValue, from))
    return result
end
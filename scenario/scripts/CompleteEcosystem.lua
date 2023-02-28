include("scenario/scripts/misc.lua")
include("scenario/scripts/ui.lua")
include("scenario/scripts/entity.lua")
include("scenario/scripts/needs.lua")
include("scenario/scripts/economy.lua")
include("scenario/scripts/token.lua")

HERBIVORE_QUOTA = 6
CARNIVORE_QUOTA = 4
MONTH_QUOTA = 4

evalhabitatsetup = function()

----- Debug Entity Pos
--    try(
--        function ()
--            local guest = resolveTable(findType("Guest_Adult_F")[1].value)
--            guest:BFG_SET_ATTR_STRING("s_name", "LoliJuicy")
--            local pos = guest:BFG_GET_ENTITY_POSITION()
--            print("Pos X=" .. pos.x .. " Y=" .. pos.y)
 --           io.flush()
--        end
--    )
    
----- Debug giveCash
--    if getglobalvar("HERBIVOREIDS") == nil then
--        giveCash(500000)
--    end

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
	
    setSavannahAnimalsLists()
    return 0	
end

--- @return number
evalhugebiome = function(l_2_arg0)

    if getglobalvar("HERBIVOREIDS") == nil then
        giveCash(500000)
    end

	if l_2_arg0.quotaDone == nil then
	    if getglobalvar("HERBIVOREIDS") ~= nil and getglobalvar("CARNIVOREIDS") ~= nil then
	
			local herbivores = split(getglobalvar("HERBIVOREIDS"), ",")
			local carnivores = split(getglobalvar("CARNIVOREIDS"), ",")

			if table.getn(herbivores) >= HERBIVORE_QUOTA and table.getn(carnivores) >= CARNIVORE_QUOTA then
				genericokpanel(nil, "TheWorld:HugeBiomeoverallquotadone")
				setRuleState("HugeBiomequota", "success")
				showRule("HugeBiomecounter")
				l_2_arg0.quotaDone = 1	
			end
		end	
	end

	if l_2_arg0.quotaDone == 1 and l_2_arg0.counterDone == nil then
	
		local startingMonth = getglobalvar("STARTINGMONTH")
		local allowanceMonth = getglobalvar("ALLOWANCEMONTH")

		if startingMonth == nil then
			setglobalvar("STARTINGMONTH", tostring(getCurrentMonth()))
			startingMonth = getglobalvar("STARTINGMONTH")
		end

		if checkForHerbivoreCarcasses() then
			setRuleState("HugeBiomequota", "failure")	
			return -1
		end

		if countSavannahAnimalsInSameHabitat() >= HERBIVORE_QUOTA then
			if (tonumber(startingMonth) + MONTH_QUOTA <= getCurrentMonth()) then
				setRuleState("HugeBiomequota", "success")
				l_2_arg0.counterDone = 1
				return 1
			end
		else
			setglobalvar("STARTINGMONTH", tostring(getCurrentMonth()))
			setRuleState("HugeBiomequota", "neutral")
			hideRule("HugeBiomecounter")
			genericokpanel(nil, "TheWorld:HugeBiomeoverallcounterfailed")
			l_2_arg0.quotaDone = nil
			l_2_arg0.counterDone = nil
		end

		if tostring(getCurrentMonth()) ~= allowanceMonth then
			giveCash(2000)
			setglobalvar("ALLOWANCEMONTH", tostring(getCurrentMonth()))
		end
	end
	
    print("QuotaState" .. l_2_arg0.quotaDone)
	print("CounterState" .. l_2_arg0.counterDone)
    io.flush()	
	
    setSavannahAnimalsLists()
    return 0
end

completeworldcampaignscen4 = function()
   BFLOG(SYSTRACE, "completeworldcampaignscen4")
   setuservar("worldcampaignscenario4", "completed")
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

        if animal:BFG_GET_ATTR_BOOLEAN("b_Folivore") or animal:BFG_GET_ATTR_BOOLEAN("b_Granivore") or animal:BFG_GET_ATTR_BOOLEAN("b_Graminivore") then
            table.insert(herbivores, savannahAnimals[i])
        end
    end

    for i = 1, table.getn(herbivores) do
        local sharesHabitatWithCarnivore = false
        local herbivore = resolveTable(herbivores[i].value)

        for j = 1, table.getn(carnivores) do
            local carnivore = resolveTable(carnivores[j].value)
            if inSameHabitat(herbivore, carnivore) then
                sharesHabitatWithCarnivore = true
                break
            end
        end

        if sharesHabitatWithCarnivore == true then
            herbivoresInCarnivoreHabitat = herbivoresInCarnivoreHabitat + 1
        end
    end

    print("HerbinCarnHab=" .. herbivoresInCarnivoreHabitat)
    io.flush()

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
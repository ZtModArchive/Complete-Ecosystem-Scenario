include "scenario/scripts/awards.lua"
include "scenario/scripts/economy.lua"
include "scenario/scripts/entity.lua"
include "scenario/scripts/misc.lua"
include "scenario/scripts/needs.lua"
include "scenario/scripts/token.lua"
include "scenario/scripts/ui.lua"

HERBIVORE_QUOTA = 6
CARNIVORE_QUOTA = 4
MONTH_QUOTA = 4

--- @return number
evalhabitatsetup = function()
    if getglobalvar("HERBIVOREIDS") == nil then
        giveCash(500000)
    end
    
    if getglobalvar("HERBIVOREIDS") ~= nil and getglobalvar("CARNIVOREIDS") ~= nil then
        local herbivores = split(getglobalvar("HERBIVOREIDS"), ",")
        local carnivores = split(getglobalvar("CARNIVOREIDS"), ",")

        if table.getn(herbivores) >= HERBIVORE_QUOTA and table.getn(carnivores) >= CARNIVORE_QUOTA then
            -- setRuleState("HugeBiomeoverall", "neutral")
            -- showRule("HugeBiomeoverall")
            -- completeshowoverview()
            return 1
        end
    end

    setSavannahAnimalsLists(false)
    return 0
end

--- @return number
evalhugebiome = function(argument)
    local monthDiff = getglobalvar("MONTHDIFFERENCE")
    if monthDiff ~= tostring(getCurrentMonth()) then
        giveCash(2000)
        setglobalvar("MONTHDIFFERENCE", tostring(getCurrentMonth()))
    end
        
    if argument.stayopentimer == nil then
        argument.stayopentimer = getCurrentMonth()
        argument.stayopentimerday = getCurrentTimeOfDay()

        setSavannahAnimalsLists(true)
    end

    if not checkHerbivoresAlive() then
        return -1
    end

    if (argument.stayopentimer + MONTH_QUOTA <= getCurrentMonth() and argument.stayopentimerday <= getCurrentTimeOfDay()) then
        if countSavannahAnimalsInSameHabitat() >= HERBIVORE_QUOTA then
            return 1
        end
        return -1
    end

    return 0
end

completeworldcampaignscen4 = function()
    BFLOG(SYSTRACE, "completeworldcampaignscen2")
    setuservar("worldcampaignscenario4", "completed")
    showscenariowin("TheWorld:HugeBiomeSuccessoverview", nil)
end

failworldcampaignscen4 = function()
    showscenariofail("TheWorld:HugeBiomeFailureoverview", "worldcampaignscenario4")

    -- if condition fulfilled, show the alternative message
    -- if ("guest response to animal attack") ~= nil then
    -- 	showscenariofail("TheWorld:HugeBiomeFailureoverview", "worldcampaignscenario4")
    -- else
    -- 	showscenariofail("TheWorld:HugeBiomeFailureWitnessedoverview", "worldcampaignscenario4")
    -- end
end

--- Sets global variables CARNIVORE_IDS and HERBIVORE_IDS
--- @param disableRelease bool
--- @return void
setSavannahAnimalsLists = function(disableRelease)
    local savannahAnimals = getAnimalsFromBiome("savannah")
    local carnivoreIds = ""
    local herbivoreIds = ""

    if savannahAnimals == nil then
        return
    end

    for i = 1, table.getn(savannahAnimals) do
        local animal = resolveTable(savannahAnimals[i].value)

        if animal:BFG_GET_ATTR_BOOLEAN("b_Carnivore") then
            if disableRelease then
                animal:BFG_SET_ATTR_BOOLEAN("b_showAdopt", false)
                animal:BFG_SET_ATTR_BOOLEAN("b_showRelease", false)
            end

            if carnivoreIds == "" then
                carnivoreIds = carnivoreIds .. getID(animal)
            else
                carnivoreIds = carnivoreIds .. "," .. getID(animal)
            end
        end

        if animal:BFG_GET_ATTR_BOOLEAN("b_Folivore") or animal:BFG_GET_ATTR_BOOLEAN("b_Granivore") then
            if disableRelease then
                animal:BFG_SET_ATTR_BOOLEAN("b_showAdopt", false)
                animal:BFG_SET_ATTR_BOOLEAN("b_showRelease", false)
            end

            if herbivoreIds == "" then
                herbivoreIds = herbivoreIds .. getID(animal)
            else
                herbivoreIds = herbivoreIds .. "," .. getID(animal)
            end
        end
    end

    setglobalvar("CARNIVOREIDS", carnivoreIds)
    setglobalvar("HERBIVOREIDS", herbivoreIds)
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
        if animal:BFG_GET_ATTR_BOOLEAN("b_Folivore") or animal:BFG_GET_ATTR_BOOLEAN("b_Granivore") then
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
        local sharesHabitatWithCarnivore = false
        local herbivore = resolveTable(herbivores[i].value)

        for j = 1, table.getn(carnivores) do
            local carnivore = resolveTable(carnivores[j].value)
            if inSameHabitat(herbivore, carnivore) then
                sharesHabitatWithCarnivore = true
                break
            end
        end

        if sharesHabitatWithCarnivore then
            herbivoresInCarnivoreHabitat = herbivoresInCarnivoreHabitat + 1
        end
    end

    return herbivoresInCarnivoreHabitat
end

function try(func)
    -- Try
    local status, exception = pcall(func)
    -- Catch
    if not status then
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

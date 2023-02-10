include "scenario/scripts/entity.lua"
include "scenario/scripts/token.lua"
include "scenario/scripts/ui.lua"
include "scenario/scripts/misc.lua"
include "scenario/scripts/awards.lua"
include "scenario/scripts/economy.lua"

--- Sets global variables CARNIVORE_IDS and HERBIVORE_IDS
--- @return void
setSavannahAnimalsLists = function()
    local savannahAnimals = getAnimalsFromBiome("savannah")
    local carnivoreIds = {}
    local herbivoreIds = {}

    if savannahAnimals == nil then
        return
    end

    for i = 1, table.getn(savannahAnimals) do
        local animal = resolveTable(savannahAnimals[i].value)

        if animal:BFG_GET_ATTR_BOOLEAN("b_Carnivore") then
            table.insert(carnivoreIds, getID(animal))
        end

        if animal:BFG_GET_ATTR_BOOLEAN("b_Folivore") or animal:BFG_GET_ATTR_BOOLEAN("b_Granivore") then
            table.insert(herbivoreIds, getID(animal))
        end
    end

    setglobalvar("CARNIVORE_IDS", carnivoreIds)
    setglobalvar("HERBIVORE_IDS", herbivoreIds)
end

--- Checks if all savannah herbivores from the global HERBIVORE_IDS are still present
--- @return bool
checkHerbivoresAlive = function()
    local savedHerbivoreIds = getglobalvar("HERBIVORE_IDS")
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
            if herbivoreIds[j] == savedHerbivoreId then
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
        local herbivore =  resolveTable(herbivores[i].value)

        for j = 1, table.getn(carnivores) do
            local carnivore =  resolveTable(carnivores[j].value)
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
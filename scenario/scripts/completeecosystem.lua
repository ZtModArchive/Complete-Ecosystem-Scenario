include "scenario/scripts/entity.lua"
include "scenario/scripts/token.lua"
include "scenario/scripts/ui.lua"
include "scenario/scripts/misc.lua"
include "scenario/scripts/awards.lua"
include "scenario/scripts/economy.lua"

getSavannahAnimalsLists = function(shouldCompare, shouldSave)
    local savannahAnimals = getAnimalsFromBiome("savannah")
    local carnivoreIds = {}
    local herbivoreIds = {}

    for i = 1, table.getn(savannahAnimals) do
        local animal = resolveTable(savannahAnimals[i]).value

        if animal:BFG_GET_ATTR_BOOLEAN("b_Carnivore") then
            table.insert(carnivoreIds, getID(animal))
        end

        if animal:BFG_GET_ATTR_BOOLEAN("b_Folivore") or animal:BFG_GET_ATTR_BOOLEAN("b_Granivore") then
            table.insert(herbivoreIds, getID(animal))
        end
    end

    if shouldCompare then
        local savedHerbivoreIds = getglobalvar("HERBIVORE_IDS")
        if savedHerbivoreIds == nil then
            return trued
        end
        for i = 1, table.getn(savedHerbivoreIds) do

            local herbivoreId = savedHerbivoreIds[i]
            local stillExists = false

            for j = 1, table.getn(herbivoreIds) do
                if herbivoreIds[j] == herbivoreId then
                    stillExists = true
                end
            end

            if not stillExists then
                return false
            end
        end
    end

    if shouldSave then
        setglobalvar("CARNIVORE_IDS", carnivoreIds)
        setglobalvar("HERBIVORE_IDS", herbivoreIds)
    end

    return true
end

countSavannahAnimalsInSameHabitat = function()
    local savannahAnimals = getAnimalsFromBiome("savannah")
    local herbivoresInCarnivoreHabitat = 0
    local carnivores = {}
    local herbivores = {}

    for i = 1, table.getn(savannahAnimals) do
        local animal = resolveTable(savannahAnimals[i]).value

        if animal:BFG_GET_ATTR_BOOLEAN("b_Carnivore") then
            table.insert(carnivores, savannahAnimals[i])
        end

        if animal:BFG_GET_ATTR_BOOLEAN("b_Folivore") or animal:BFG_GET_ATTR_BOOLEAN("b_Granivore") then
            table.insert(herbivores, savannahAnimals[i])
        end
    end

    for i = 1, table.getn(herbivores) do
        local sharesHabitatWithCarnivore = false
        local herbivore =  resolveTable(herbivores[i]).value

        for j = 1, table.getn(carnivores) do
            local carnivore =  resolveTable(carnivores[j]).value
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
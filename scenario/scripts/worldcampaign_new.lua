include("scenario/scripts/misc.lua")
include("scenario/scripts/ui.lua")
include("scenario/scripts/entity.lua")
include("scenario/scripts/needs.lua")
include("scenario/scripts/economy.lua")
evalhugebiome = function()
end

completeworldcampaignscen4 = function()
   BFLOG(SYSTRACE, "completeworldcampaignscen2")
   setuservar("worldcampaignscenario4", "completed")
   showscenariowin("TheWorld:HugeBiomeSuccessoverview", nil)  
end

failworldcampaignscen4 = function()
-- if condition fulfilled, show the alternative message
   if ("guest response to animal attack") ~= nil then
		showscenariofail("TheWorld:HugeBiomeFailureoverview", "worldcampaignscenario4")
   else
		showscenariofail("TheWorld:HugeBiomeFailureWitnessedoverview", "worldcampaignscenario4")
   end
end
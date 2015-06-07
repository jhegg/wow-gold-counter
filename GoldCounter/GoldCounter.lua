local addonName, _ = ...

GoldCounter = {
  name = addonName,
  version = GetAddOnMetadata(addonName, "Version"),
  author = GetAddOnMetadata(addonName, "Author"),
  selectedCharacter,
  totalCopper = 0,
  ldb,
}

GoldCounter.addon = LibStub("AceAddon-3.0"):NewAddon(addonName, "AceEvent-3.0")
local addon = GoldCounter.addon

SLASH_GoldCounter1 = "/goldcounter"

SlashCmdList["GoldCounter"] = function()
  GoldCounter:PrintGoldCounter()
end

function GoldCounter:comma_value(n) -- credit http://richard.warburton.it
   local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(.-)$')
   return left..(num:reverse():gsub('(%d%d%d)','%1,'):reverse())..right
end

function GoldCounter:GetTotalGoldForDisplay()
  return GoldCounter:comma_value(floor(GoldCounter.totalCopper / 100 / 100))
end

function GoldCounter:PrintGoldCounter()
  print(format("Total Gold: %sg", GoldCounter:GetTotalGoldForDisplay()))
end

function GoldCounter:UpdateGoldTotal()
  local totalCopper = 0
  for _,character in pairs(GoldCounter.db.factionrealm.character) do
    totalCopper = totalCopper + character.copper
  end
  GoldCounter.totalCopper = totalCopper
  GoldCounter.ldb.text = GoldCounter:GetTotalGoldForDisplay()
end

local function UpdateGoldForThisCharacter()
  addon:UnregisterEvent("PLAYER_ENTERING_WORLD")
  GoldCounter.db.factionrealm.character[UnitName("player")].copper = GetMoney()
  GoldCounter:UpdateGoldTotal()
end

function addon:OnInitialize()
  GoldCounter.db = LibStub("AceDB-3.0"):New("GoldCounterDB")
  GoldCounter.db.factionrealm.character = GoldCounter.db.factionrealm.character or {}
  GoldCounter.db.factionrealm.character[UnitName("player")] =
      GoldCounter.db.factionrealm.character[UnitName("player")] or {}
  GoldCounter.selectedCharacter = UnitName("player")
end

function addon:OnEnable()
  addon:RegisterEvent("PLAYER_ENTERING_WORLD", UpdateGoldForThisCharacter)
  addon:RegisterEvent("PLAYER_MONEY", UpdateGoldForThisCharacter)
end

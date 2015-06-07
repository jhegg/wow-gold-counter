local libDataBroker = LibStub:GetLibrary("LibDataBroker-1.1", true)
if not libDataBroker then return end

local ldb = libDataBroker:NewDataObject("GoldCounter", {
  type = "launcher",
  icon = "Interface\\Icons\\INV_Misc_Coin_01",
  label = "GoldCounter",
  text = "",
})

GoldCounter.ldb = ldb

function ldb:OnTooltipShow()
  GoldCounter:UpdateGoldTotal()
  self:AddLine(format("%s %s", GoldCounter.name, GoldCounter.version))
  self:AddLine("------------------------------")
  for name,character in pairs(GoldCounter.db.factionrealm.character) do
    self:AddLine(format("%s: %sg %ds %dc",
      name,
      GoldCounter:comma_value(round(character.copper / 100 / 100)),
      (character.copper / 100) % 100,
      character.copper % 100))
  end
end

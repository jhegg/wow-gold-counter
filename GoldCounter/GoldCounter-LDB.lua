local libDataBroker = LibStub:GetLibrary("LibDataBroker-1.1", true)
if not libDataBroker then return end

local ldb = libDataBroker:NewDataObject("GoldCounter", {
  type = "launcher",
  icon = "Interface\\Icons\\INV_Misc_Coin_01",
  label = "GoldCounter",
  text = "",
})

GoldCounter.ldb = ldb

-- Courtesy of http://www.lua.org/pil/19.3.html
local function pairsByKeys (t, f)
   local a = {}
   for n in pairs(t) do table.insert(a, n) end
   table.sort(a, f)
   local i = 0      -- iterator variable
   local iter = function ()   -- iterator function
      i = i + 1
      if a[i] == nil then return nil
      else return a[i], t[a[i]]
      end
   end
   return iter
end

function ldb:OnTooltipShow()
  GoldCounter:UpdateGoldTotal()
  self:AddLine(format("%s %s", GoldCounter.name, GoldCounter.version))
  self:AddLine("------------------------------")
  for name,character in pairsByKeys(GoldCounter.db.factionrealm.character) do
    self:AddLine(format("%s: %sg",
      name,
      GoldCounter:comma_value(floor(character.copper / 100 / 100))))
  end
end

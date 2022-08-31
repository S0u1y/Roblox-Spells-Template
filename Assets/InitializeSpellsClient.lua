local lplayer = game.Players.LocalPlayer

local spells = {}

repeat wait() until lplayer.Character
local characterRace = lplayer.Character:GetAttribute("Race")
lplayer.CharacterAdded:Connect(function(newCharacter)
	characterRace = lplayer.Character:GetAttribute("Race")
	if characterRace then
		for _, v in pairs(game.ReplicatedStorage.Spells[characterRace]:GetChildren()) do
			local spellClass = require(v)
			spells[v.Name] = spellClass.new(lplayer)
			spells[v.Name]:Init()
		end
	end
end)

lplayer.CharacterRemoving:Connect(function()
	for _, v in pairs(spells) do
		v:Destroy()
	end
end)




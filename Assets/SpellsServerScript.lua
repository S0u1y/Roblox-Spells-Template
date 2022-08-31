game:GetService("Players").PlayerAdded:Connect(function(player)
	
	local newremote = Instance.new("RemoteEvent", player)
	local spells = {}
	player.CharacterAdded:Connect(function(character)
		local race = character:GetAttribute("Race")
		if race then
			local spellsFolder = game.ReplicatedStorage.Spells:FindFirstChild(race)
			if spellsFolder then
				for _, v in ipairs(spellsFolder:GetChildren()) do
					local Spell = require(v)
					table.insert(spells, Spell.InitServer(newremote))
				end
			end
		end
		player.CharacterAppearanceLoaded:Wait()
		for _, v in pairs(character:GetChildren()) do
			v:SetAttribute("Draggable", true)
		end
	end)
	
	player.CharacterRemoving:Connect(function(oldCharacter)
		
		for _, v in ipairs(spells) do
			v:Disconnect()
		end
		
		print(spells)
		
	end)
	
end)




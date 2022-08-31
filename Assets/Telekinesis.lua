local UserInputService = game:GetService("UserInputService")
local runService = game:GetService("RunService")
local KeysEnums = Enum.KeyCode

local Telekinesis = {}
Telekinesis.__index = Telekinesis

function Telekinesis.new(player)
	local self = setmetatable({}, Telekinesis)
	self.Player = player
	self.Dragging = false
	self.Remote = player.RemoteEvent
	
	return self
end

function Telekinesis:Init()
	
	local player:Player = self.Player
	local mouse = player:GetMouse()
	self.Target = nil
	self.InputConnect = UserInputService.InputBegan:Connect(function(key, procc)
		if procc then return end
		key = key.KeyCode

		if key == KeysEnums.E then
			if mouse.Target and mouse.Target:GetAttribute("Draggable") == true then
				self.Target = mouse.Target
				local model = self.Target:FindFirstAncestorWhichIsA("Model")
				if model then
					local humanoid = model:FindFirstChild("Humanoid")
					if humanoid then
						self.Target = model:FindFirstChild("HumanoidRootPart")
						if not self.Target then return end --because that would be a probably dead person
					else
						self.Target = mouse.Target --if no humanoid, then it's prolly just a model, so return the hit part
					end

				end

				self.Remote:FireServer("Telekinesis", self.Target, true)
				local ActiveSpellInputEndConnect = nil
				ActiveSpellInputEndConnect = UserInputService.InputEnded:Connect(function(key)
					key = key.KeyCode
					if key == KeysEnums.E then
						self.Remote:FireServer("Telekinesis", self.Target, false)
						self.Dragging = false
						self.Target = nil
						ActiveSpellInputEndConnect:Disconnect()
					end
				end)
				self.Dragging = true

				self:DoSpell(self.Target)
			end

		end

	end)
end

function Telekinesis:DoSpell(part)
	local newPoint = Instance.new("Part", workspace)
	newPoint.Name = "ATTRACTION POINT"
	newPoint.Anchored = true
	newPoint.Size = Vector3.new(1,1,1)
	--newPoint.Transparency = 1
	newPoint.CanTouch = false
	newPoint.CanCollide = false
	local pointBAttachment = Instance.new("Attachment", newPoint)
	local pointAAttachment = Instance.new("Attachment", part)
	local AlignPosition = Instance.new("AlignPosition", newPoint)
	AlignPosition.Attachment0 = pointAAttachment
	AlignPosition.Attachment1 = pointBAttachment
	local ChangeAttractionPointPos 
	ChangeAttractionPointPos = runService.RenderStepped:Connect(function()

		if self.Dragging then
			local mouse = UserInputService:GetMouseLocation()
			local ray = game.Workspace.CurrentCamera:ViewportPointToRay(mouse.X, mouse.Y)
			--newPoint.Position = workspace.CurrentCamera + (mouse.Hit.Position - lplayerChar.HumanoidRootPart.Position).Unit * 10
			newPoint.Position = self.Player.Character.HumanoidRootPart.Position + ray.Direction * 10
		else

			newPoint:Destroy()
			pointAAttachment:Destroy()
			ChangeAttractionPointPos:Disconnect()

		end

	end)
end


function Telekinesis:Destroy()
	self.InputConnect:Disconnect()
	self.Player = nil
	self.Target = nil
	self.Remote = nil
	
	
	
end

local function ConnectListener(Event, spell, callback)
	
	local connection = Event.OnServerEvent:Connect(function(player,Spell,...)
		if spell == Spell then
			callback(player,...)
		end
	end)
	return connection
end

local function TelekinesisServer(player, target, isActive)
	if isActive and target:GetAttribute("Draggable") == true then
		target:SetNetworkOwner(player)
	else
		if not target:IsA("Player") then
			target:SetNetworkOwner(nil)
		else
			target:SetNetworkOwner(target)
		end
		
	end
end

Telekinesis.InitServer = function(Event)
	return ConnectListener(Event,"Telekinesis", TelekinesisServer)
end



return Telekinesis

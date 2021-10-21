
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

local ACF = ACF

--===============================================================================================--
-- Local Funcs and Vars
--===============================================================================================--

local ActiveSensors	= ACF.ActiveSensors

local CheckLegal  = ACF_CheckLegal
local Sensors	  = ACF.Classes.Sensors

local TimerExists = timer.Exists
local TimerCreate = timer.Create
local TimerRemove = timer.Remove
local HookRun     = hook.Run

local function ScanForEntities(Entity)
	if not Entity.GetDetected then return end

	local Origin = Entity:LocalToWorld(Entity.Origin)
	local Triggered = Entity.GetDetected(Origin,Entity) or false

	WireLib.TriggerOutput(Entity, "Triggered", Triggered and 1 or 0)

	if Triggered ~= Entity.SensorTriggered then
		Entity.SensorTriggered = Triggered
		if Triggered then Entity:EmitSound(Entity.SoundPath, 70, 100, ACF.Volume) end

		Entity:UpdateOverlay()
	end
end

local function SetSensorScan(Entity, Active)
	Entity:UpdateOverlay()

	ActiveSensors[Entity] = Active or nil

	WireLib.TriggerOutput(Entity, "Scanning", Active and 1 or 0)

	if Active then
		TimerCreate("ACF Sensor Scan " .. Entity:EntIndex(), Entity.ThinkDelay, 0, function()
			if IsValid(Entity) and Entity.Active then
				return ScanForEntities(Entity)
			end

			TimerRemove("ACF Sensor Scan " .. Entity:EntIndex())
		end)
	end
end

local function SetActive(Entity, Active)
	if Entity.Active == Active then return end

	Entity.Active = Active

	Entity:UpdateOverlay()

	if TimerExists("ACF Sensor Switch " .. Entity:EntIndex()) then
		TimerRemove("ACF Sensor Switch " .. Entity:EntIndex())
	end

	if not Active then return SetSensorScan(Entity, Active) end

	TimerCreate("ACF Sensor Switch " .. Entity:EntIndex(), 1, 1, function()
		if IsValid(Entity) then
			return SetSensorScan(Entity, Active)
		end
	end)
end

--===============================================================================================--

do -- Spawn and Update functions
	local function VerifyData(Data)
		if not Data.Sensor then
			Data.Sensor = Data.Sensor or Data.Id
		end

		local Class = ACF.GetClassGroup(Sensors, Data.Sensor)

		if not Class or Class.Entity ~= "acf_sensor" then
			Data.Sensor = "LWR"

			Class = ACF.GetClassGroup(Sensors, "LWR")
		end

		do -- External verifications
			if Class.VerifyData then
				Class.VerifyData(Data, Class)
			end

			HookRun("ACF_VerifyData", "acf_sensor", Data, Class)
		end
	end

	local function CreateInputs(Entity, Data, Class, Sensor)
		local List = {}

		if Class.SetupInputs then
			Class.SetupInputs(List, Entity, Data, Class, Sensor)
		end

		HookRun("ACF_OnSetupInputs", "acf_sensor", List, Entity, Data, Class, Sensor)

		if Entity.Inputs then
			Entity.Inputs = WireLib.AdjustInputs(Entity, List)
		else
			Entity.Inputs = WireLib.CreateInputs(Entity, List)
		end
	end

	local function CreateOutputs(Entity, Data, Class, Sensor)
		local List = { "Scanning (Whether or not the sensor is active)", "Triggered (Whether or not the sensor was triggered)", "Entity (The sensor itself) [ENTITY]" }

		if Class.SetupOutputs then
			Class.SetupOutputs(List, Entity, Data, Class, Sensor)
		end

		HookRun("ACF_OnSetupOutputs", "acf_sensor", List, Entity, Data, Class, Sensor)

		if Entity.Outputs then
			Entity.Outputs = WireLib.AdjustOutputs(Entity, List)
		else
			Entity.Outputs = WireLib.CreateOutputs(Entity, List)
		end
	end

	local function UpdateSensor(Entity, Data, Class, Sensor)
		Entity.ACF = Entity.ACF or {}
		Entity.ACF.Model = Sensor.Model -- Must be set before changing model

		Entity:SetModel(Sensor.Model)

		Entity:PhysicsInit(SOLID_VPHYSICS)
		Entity:SetMoveType(MOVETYPE_VPHYSICS)

		-- Storing all the relevant information on the entity for duping
		for _, V in ipairs(Entity.DataStore) do
			Entity[V] = Data[V]
		end

		Entity.Name         = Sensor.Name
		Entity.ShortName    = Sensor.Name
		Entity.EntType      = Class.Name
		Entity.ClassType    = Class.ID
		Entity.ClassData    = Class
		Entity.SoundPath    = Class.Sound or ACFM.DefaultSensorSound
		Entity.DefaultSound = Entity.SoundPath
		Entity.SensorType	= Sensor.SensorType
		Entity.ThinkDelay   = Sensor.ThinkDelay
		Entity.GetDetected  = Sensor.Detect or Class.Detect
		Entity.Origin		= Sensor.Origin or Vector()
		Entity.DetectAngle	= Sensor.DetectAngle

		Entity:SetNWString("WireName", "ACF " .. Entity.Name)

		CreateInputs(Entity, Data, Class, Sensor)
		CreateOutputs(Entity, Data, Class, Sensor)

		ACF.Activate(Entity, true)

		Entity.ACF.Model		= Sensor.Model
		Entity.ACF.LegalMass	= Sensor.Mass

		local Phys = Entity:GetPhysicsObject()
		if IsValid(Phys) then Phys:SetMass(Sensor.Mass) end
	end

	function MakeACF_Sensor(Player, Pos, Angle, Data)
		VerifyData(Data)

		local Class = ACF.GetClassGroup(Sensors, Data.Sensor)
		local SensorData = Class.Lookup[Data.Sensor]
		local Limit = Class.LimitConVar.Name

		if not Player:CheckLimit(Limit) then return false end

		local Sensor = ents.Create("acf_sensor")

		if not IsValid(Sensor) then return end

		Sensor:SetPlayer(Player)
		Sensor:SetAngles(Angle)
		Sensor:SetPos(Pos)
		Sensor:Spawn()

		Player:AddCleanup("acf_sensor", Sensor)
		Player:AddCount(Limit, Sensor)

		Sensor.Owner       = Player -- MUST be stored on ent for PP
		Sensor.Active      = false
		Sensor.SensorTriggered = false
		Sensor.Spread      = 0
		Sensor.DataStore   = ACF.GetEntityArguments("acf_sensor")

		UpdateSensor(Sensor, Data, Class, SensorData)

		if Class.OnSpawn then
			Class.OnSpawn(Sensor, Data, Class, SensorData)
		end

		HookRun("ACF_OnEntitySpawn", "acf_sensor", Sensor, Data, Class, SensorData)

		WireLib.TriggerOutput(Sensor, "Entity", Sensor)

		Sensor:UpdateOverlay(true)

		do -- Mass entity mod removal
			local EntMods = Data and Data.EntityMods

			if EntMods and EntMods.mass then
				EntMods.mass = nil
			end
		end

		CheckLegal(Sensor)

		TimerCreate("ACF Sensor Clock " .. Sensor:EntIndex(), 1, 0, function()
			if not IsValid(Sensor) then return end
		end)

		timer.Simple(1,function() SetActive(Sensor,true) end)

		return Sensor
	end

	ACF.RegisterEntityClass("acf_sensor", MakeACF_Sensor, "Sensor")

	------------------- Updating ---------------------

	function ENT:Update(Data)
		VerifyData(Data)

		local Class    = ACF.GetClassGroup(Sensors, Data.Sensor)
		local Sensor    = Class.Lookup[Data.Sensor]
		local OldClass = self.ClassData

		if OldClass.OnLast then
			OldClass.OnLast(self, OldClass)
		end

		HookRun("ACF_OnEntityLast", "acf_sensor", self, OldClass)

		ACF.SaveEntity(self)

		UpdateSensor(self, Data, Class, Sensor)

		ACF.RestoreEntity(self)

		if Class.OnUpdate then
			Class.OnUpdate(self, Data, Class, Sensor)
		end

		HookRun("ACF_OnEntityUpdate", "acf_sensor", self, Data, Class, Sensor)

		self:UpdateOverlay(true)

		net.Start("ACF_UpdateEntity")
			net.WriteEntity(self)
		net.Broadcast()

		return true, "Sensor updated successfully!"
	end
end

--===============================================================================================--
-- Meta Funcs
--===============================================================================================--

function ENT:ACF_OnDamage(Bullet, Trace)
	local HitRes = ACF.PropDamage(Bullet, Trace)

	self.Spread = ACF.MaxDamageInaccuracy * (1 - math.Round(self.ACF.Health / self.ACF.MaxHealth, 2))

	return HitRes
end

function ENT:Enable()
	if not CheckLegal(self) then return end

	self.Disabled		= nil
	self.DisableReason	= nil

	self.Active 		= true

	self:UpdateOverlay()
end

function ENT:Disable()
	self.Disabled 	= true
	self.Active		= false
end

local Text = "%s\n\nType : %s"

function ENT:UpdateOverlayText()
	local Status

	if self.SensorTriggered then
		Status = "Being triggered!"
	else
		Status = self.Active and "Active" or "Idle"
	end

	return Text:format(Status, self.SensorType)
end

function ENT:OnRemove()
	local OldClass = self.ClassData

	if OldClass.OnLast then
		OldClass.OnLast(self, OldClass)
	end

	HookRun("ACF_OnEntityLast", "acf_sensor", self, OldClass)

	if Sensors[self] then
		Sensors[self] = nil
	end

	TimerRemove("ACF Sensor Clock " .. self:EntIndex())
	TimerRemove("ACF Sensor Switch " .. self:EntIndex())
	TimerRemove("ACF Sensor Scan " .. self:EntIndex())

	WireLib.Remove(self)
end

ACF.RegisterSensorClass("SENS", {
	Name	= "Sensors",
	Entity	= "acf_sensor",
	CreateMenu	= ACF.CreateSensorMenu,
	LimitConVar = {
		Name	= "_acf_sensor",
		Amount	= 6,
		Text	= "Maximum amount of ACF Sensors a player can create."
	}
})

local TraceLine = util.TraceLine
local TraceData	  = { start = true, endpos = true, mask = MASK_SOLID_BRUSHONLY }

local function CheckLOS(Start, End)
	TraceData.start = Start
	TraceData.endpos = End

	return not TraceLine(TraceData).Hit
end

do
	ACF.RegisterSensor("LWR", "SENS", {
		Name		= "Laser Warning Receiver",
		Description	= "A sensor array capable of detecting when a laser is pointed at or near it.",
		Model		= "models/jaanus/wiretool/wiretool_siren.mdl",
		Mass		= 25,
		DetectAngle = 1.5,
		SensorType	= "Laser receiver",
		ThinkDelay	= 0.2,
		Origin = Vector(0,0,5),
		Detect = function(Origin,SensorEnt) -- Check for whatever the sensor is going to check, and return true if the sensor should be triggered
			local LaserSources = ACF.LaserSources
			if not next(LaserSources) then return false end
			local Lasers = ACF.ActiveLasers

			for ent in pairs(LaserSources) do
				if not IsValid(ent) then continue end

				if ent.Lasing == true then
					local trace = Lasers[ent].Trace
					if CheckLOS(Origin,trace.StartPos) then
						local Dir2Sensor = (Origin - trace.StartPos):GetNormalized()
						local LaserDir = (trace.HitPos - trace.StartPos):GetNormalized()

						if Dir2Sensor:Dot(LaserDir) >= math.cos(math.rad(SensorEnt.DetectAngle)) then
							return true
						end
					end
				end
			end

			return false
		end,
		Bounds = {
			Pitch = 10,
			Yaw = 15,
		},
		Preview = {
			FOV = 110,
		},
	})
end

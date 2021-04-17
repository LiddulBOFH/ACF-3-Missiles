
ACF.RegisterMissileClass("FFAR", {
	Name		= "Folding-Fin Aerial Rockets",
	Description	= "Small rockets which fit in tubes or pods. Rapid-firing and versatile.",
	Sound		= "acf_missiles/missiles/missile_rocket.mp3",
	Effect		= "Rocket Motor",
	Spread		= 1,
	Blacklist	= { "AP", "APHE", "HP", "FL" }
})

ACF.RegisterMissile("40mmFFAR", "FFAR", {
	Name		= "40mm Pod Rocket",
	Description	= "A tiny, unguided rocket. Useful for anti-infantry, smoke and suppression. Folding fins allow the rocket to be stored in pods, which defend them from damage.",
	Model		= "models/missiles/ffar_40mm.mdl",
	Caliber		= 40,
	Mass		= 4,
	Length		= 2,
	Year		= 1960,
	ReloadTime	= 7.5,
	Racks		= { ["40mm7xPOD"] = true },
	Guidance	= { Dumb = true },
	Fuzes		= { Contact = true, Timed = true },
	ArmDelay	= 0.3,
	Round = {
		Model			= "models/missiles/ffar_40mm.mdl",
		RackModel		= "models/missiles/ffar_40mm_closed.mdl",
		MaxLength		= 25,
		Armor			= 5,
		PropMass		= 0.2,
		Thrust			= 10000, -- in kg*in/s^2
		BurnRate		= 120, -- in cm^3/s
		StarterPercent	= 0.15,
		MinSpeed		= 5000,
		DragCoef		= 0.001,
		DragCoefFlight	= 0.02,
		FinMul			= 0.003,
		PenMul			= math.sqrt(4),
		ActualLength 	= 26.5,
		ActualWidth		= 1.6
	},
})

ACF.RegisterMissile("57mmFFAR", "FFAR", {
	Name		= "57mm Pod Rocket",
	Description	= "A small, spammy rocket with light anti-armor capabilities. Works well on technicals.",
	Model		= "models/missiles/ffar_40mm.mdl",
	Caliber		= 57,
	Mass		= 4,
	Length		= 2,
	Year		= 1956,
	ReloadTime	= 0.0000000000001,
	ROFMod      = 0.01,
	Spread		= 50,
	Racks		= { ["57mm32xPOD"] = true , ["57mm16xPOD"] = true},
	Guidance	= { Dumb = true },
	Fuzes		= { Contact = true, Timed = true },
	ArmDelay	= 0.3,
	Round = {
		Model			= "models/missiles/ffar_70mm.mdl",
		RackModel		= "models/missiles/ffar_70mm_closed.mdl",
		MaxLength		= 25,
		Armor			= 5,
		PropMass		= 0.4,
		Thrust			= 12000, -- in kg*in/s^2
		BurnRate		= 160, -- in cm^3/s
		StarterPercent	= 0.15,
		MinSpeed		= 5000,
		DragCoef		= 0.001,
		DragCoefFlight	= 0.02,
		FinMul			= 0.003,
		PenMul			= math.sqrt(4),
		ActualLength 	= 26.5,
		ActualWidth		= 1.6
	},
})

ACF.RegisterMissile("70mmFFAR", "FFAR", {
	Name		= "70mm Pod Rocket",
	Description	= "A small, unguided rocket. Useful against light vehicles and infantry. Folding fins allow the rocket to be stored in pods, which defend them from damage.",
	Model		= "models/missiles/ffar_70mm.mdl",
	Caliber		= 70,
	Mass		= 6,
	Length		= 15,
	Year		= 1960,
	ReloadTime	= 10,
	Racks		= { ["70mm7xPOD"] = true, ["70mm19xPOD"] = true },
	Guidance	= { Dumb = true },
	Fuzes		= { Contact = true, Timed = true },
	Agility		= 0.05,
	ArmDelay	= 0.3,
	Round = {
		Model			= "models/missiles/ffar_70mm.mdl",
		RackModel		= "models/missiles/ffar_70mm_closed.mdl",
		MaxLength		= 25,
		Armor			= 5,
		PropMass		= 0.7,
		Thrust			= 15000, -- in kg*in/s^2
		BurnRate		= 300, -- in cm^3/s
		StarterPercent	= 0.15,
		MinSpeed		= 4000,
		DragCoef		= 0.001,
		DragCoefFlight	= 0.02,
		FinMul			= 0.015,
		PenMul			= math.sqrt(6),
		ActualLength 	= 46,
		ActualWidth		= 2.6
	},
})


ACF.RegisterMissile("80mmFFAR", "FFAR", {
	Name		= "80mm Rocket Pod",
	Description	= "A large aerial rocket designed for use against ground targets. Good HEAT performance.",
	Model		= "models/missiles/ffar_70mm.mdl",
	Caliber		= 80,
	Mass		= 6,
	Length		= 15,
	Year		= 1960,
	ReloadTime	= 0.1,
	Racks		= { ["80mm20xPOD"] = true },
	Guidance	= { Dumb = true },
	Fuzes		= { Contact = true, Timed = true },
	Agility		= 0.05,
	ArmDelay	= 0.3,
	Round = {
		Model			= "models/missiles/ffar_70mm.mdl",
		RackModel		= "models/missiles/ffar_70mm_closed.mdl",
		MaxLength		= 30,
		Armor			= 5,
		PropMass		= 0.8,
		Thrust			= 15000, -- in kg*in/s^2
		BurnRate		= 300, -- in cm^3/s
		StarterPercent	= 0.15,
		MinSpeed		= 4000,
		DragCoef		= 0.001,
		DragCoefFlight	= 0.02,
		FinMul			= 0.015,
		PenMul			= math.sqrt(6),
		ActualLength 	= 46,
		ActualWidth		= 2.6
	},
})

ACF.RegisterMissile("Zuni ASR", "FFAR", {
	Name		= "127mm Pod Rocket",
	Description	= "A heavy 5in air to surface unguided rocket, able to provide heavy suppressive fire in a single pass.",
	Model		= "models/ghosteh/zuni.mdl",
	Caliber		= 127,
	Mass		= 45,
	Length		= 80,
	Year		= 1957,
	ReloadTime	= 15,
	Racks		= { ["127mm4xPOD"] = true },
	Guidance	= { Dumb = true },
	Fuzes		= { Contact = true, Timed = true, Optical = true, Radio = true },
	Agility		= 0.05,
	ArmDelay	= 0.1,
	Round = {
		Model			= "models/ghosteh/zuni.mdl",
		RackModel		= "models/ghosteh/zuni_folded.mdl",
		MaxLength		= 60,
		Armor			= 5,
		PropMass		= 0.7,
		Thrust			= 18000, -- in kg*in/s^2
		BurnRate		= 600, -- in cm^3/s
		StarterPercent	= 0.15,
		MinSpeed		= 6000,
		DragCoef		= 0.001,
		DragCoefFlight	= 0.02,
		FinMul			= 0.015,
		PenMul			= math.sqrt(2),
		ActualLength 	= 118,
		ActualWidth		= 4.8
	},
})

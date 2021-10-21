local Text = "Receiver Type : %s\nMass : %s\n"

function ACF.CreateSensorMenu(Data, Menu)
	Menu:AddLabel("These sensors are always active.")
	Menu:AddLabel(Text:format(Data.SensorType, Data.Mass))

	ACF.SetClientData("PrimaryClass", "acf_sensor")
end

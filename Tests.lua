local AddonName, Addon = ...
local Options = Addon.Options
local Events = CreateFrame("Frame", nil, UIParent)

local function ADDON_LOADED(frame, event, ...)
	if ... == AddonName then
		Options:CreatePanel()

		local testButton1 = Options:AddButton("TestButton1")
		testButton1:SetPoint("TOPLEFT", 10, -70)

		local testButton2 = Options:AddButton("TestButton2")
		testButton2:AttachBelow(testButton1)

		local testCheckButton1 = Options:AddCheckButton("TestCheckButton1", "Hello checkbutton")
		testCheckButton1:AttachRight(testButton2, 70)

		local testSlider1 = Options:AddSlider("TestSlider1", 1, 100, 1, 1)
		testSlider1:AttachBelow(testCheckButton1)

		local testEditBox1 = Options:AddEditBox("TestEditBox1")
		testEditBox1:AttachAbove(testCheckButton1)

		local menu = {
			"Alpha",
			"Beta",
			"Gamma",
			"Delta",
		 }

		local testDropDownMenu1 = Options:AddDropDownMenu("TestDropDownMenu1", menu)
		testDropDownMenu1:AttachBelow(testSlider1)

		local testRadioButton1 = Options:AddCheckButton("TestRadioButton1", "A Radio", "UIRadioButtonTemplate")
		testRadioButton1:AttachRight(testSlider1, 70)
	end
end

function Addon:OnTestCheckButton1Clicked(enabled)
	if enabled then
		print("OnTestCheckButton1Clicked: is enabled")
	else
		print("OnTestCheckButton1Clicked: is disabled")
	end
end

function Addon:OnTestRadioButton1Clicked(enabled)
	if enabled then
		print("OnTestRadioButton1Clicked: is enabled")
	else
		print("OnTestRadioButton1Clicked: is disabled")
	end
end

function Addon:OnTestButton1Clicked()
	print("TestButton1 clicked!")
end

function Addon:OnTestButton2Clicked()
	print("TestButton2 clicked!")
end

function Addon:OnTestButton3Clicked()
	print("TestButton3 clicked!")
end

function Addon:OnTestSlider1ValueChanged(value)
	print("TestSlider1 value changed: " .. tostring(floor(value)))
end

function Addon:OnTestEditBox1ValueChanged(value)
	if value ~= "" then
		print("TestEditbox1 value changed: ", value)
	end
end

function Addon:OnTestEditBox1EnterPressed(value)
	print("TestEditbox1 Enter pressed: ", value)
end

function Addon:OnTestDropDownMenu1ValueChanged(value, id)
	print("TestDropDownMenu1 value changed: ", value, id)
end

function Addon:OnOptionsOkayButtonClicked()
	print("Addon:OnOptionsOkayButtonClicked clicked")
end

function Addon:OnOptionsCancelButtonClicked()
	print("Addon:OnOptionsCancelButtonClicked clicked")
end

Events:RegisterEvent("ADDON_LOADED")
Events:SetScript("OnEvent", ADDON_LOADED)

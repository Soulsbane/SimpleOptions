local AddonName, Addon = ...
local Options = Addon.Options
local Events = CreateFrame("Frame", nil, UIParent)

local function ADDON_LOADED(frame, event, ...)
	if ... == AddonName then
		Options:CreatePanel()

		local testButton1 = Options:AddButton("TestButton1")
		testButton1:SetPoint("TOPLEFT", 12, -72)

		local testButton2 = Options:AddButton("TestButton2")
		Options:AttachBelow(testButton2, testButton1)

		local testCheckButton1 = Options:AddCheckButton("TestCheckButton1", "Hello checkbutton")
		Options:AttachRight(testCheckButton1, testButton2, 70)

		local testSlider1 = Options:AddSlider("TestSlider1", 1, 100, 1, 1)
		Options:AttachBelow(testSlider1, testCheckButton1)

		local testEditBox1 = Options:AddEditBox("TestEditBox1")
		Options:AttachAbove(testEditBox1, testCheckButton1)

		local menu = {
			"Alpha",
			"Beta",
			"Gamma",
			"Delta",
		 }

		local testDropDownMenu1 = Options:AddDropDownMenu("TestDropDownMenu1", menu)
		Options:AttachBelow(testDropDownMenu1, testSlider1)
	end
end

function Addon:OnTestCheckButton1Clicked(enabled)
	if enabled then
		print("OnTestCheckButton1Clicked: is enabled")
	else
		print("OnTestCheckButton1Clicked: is disabled")
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

function Addon:OnInterfaceOptionsOkayButtonClicked()
	print("Addon:OnInterfaceOptionsOkayButtonClicked clicked")
end

function Addon:OnInterfaceOptionsCancelButtonClicked()
	print("Addon:OnInterfaceOptionsCancelButtonClicked clicked")
end

Events:RegisterEvent("ADDON_LOADED")
Events:SetScript("OnEvent", ADDON_LOADED)

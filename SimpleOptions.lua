--NOTE: This is very much a work in progress. Some features may be added/changed etc at any time.
local AddonName, Addon = ...

local Options = {}
local OptionsFrame

local FrameObject = {}
FrameObject.__index = FrameObject

local function DispatchMethod(func, ...)
	if type(func) == "string" and Addon[func] then
		Addon[func](Addon, ...)
	elseif type(func) == "function" then
		func(...)
	end
end

local function CreateWidgetFrame(frameType, name, template)
	return CreateFrame(frameType, OptionsFrame:GetName() .. name, OptionsFrame, template)
end

function FrameObject:New(frameType, name, template)
	local self = {}

	setmetatable(self, FrameObject)
	self.frame = CreateFrame(frameType, OptionsFrame:GetName() .. name, OptionsFrame, template)

	return self
end

function FrameObject:AttachRight(attachedTo, offsetX, offsetY)
	local offsetX = offsetX or -30
	local offsetY = offsetY or 0

	self.frame:SetPoint("CENTER", attachedTo.frame, "RIGHT", offsetX, offsetY)
end

function FrameObject:AttachLeft(attachedTo, offsetX, offsetY)
	local offsetX = offsetX or 30
	local offsetY = offsetY or 0

	self.frame:SetPoint("CENTER", attachedTo.frame, "LEFT", offsetX, offsetY)
end

function FrameObject:AttachAbove(attachedTo, offsetX, offsetY)
	local offsetX = offsetX or 0
	local offsetY = offsetY or 60

	self.frame:SetPoint("CENTER", attachedTo.frame, "TOP", offsetX, offsetY)
end

function FrameObject:AttachBelow(attachedTo, offsetX, offsetY)
	local offsetX = offsetX or 0
	local offsetY = offsetY or -60

	self.frame:SetPoint("CENTER", attachedTo.frame, "BOTTOM", offsetX, offsetY)
end

function Options:AddButton(name, width, height)
	local button = FrameObject:New("Button", name, "UIPanelButtonTemplate")

	button.frame:SetText(name)
	button.frame:SetWidth(button.frame:GetTextWidth() + 20)
	button.frame:SetScript("OnClick", function(self)
		DispatchMethod("On" .. name .. "Clicked")
	end)

	return button
end

function Options:AddCheckButton(name, label)
	local button = FrameObject:New("CheckButton", name, "InterfaceOptionsCheckButtonTemplate")
	local label = label or name

	_G[button.frame:GetName() .. "Text"]:SetText(label)
	button.frame:SetScript("OnClick", function(self)
		DispatchMethod("On" .. name .. "Clicked", button.frame:GetChecked())
	end)

	return button
end

function Options:AddEditBox(name, width, height)
	local width = width or 30
	local height = height or 20
	local editBox = FrameObject:New("EditBox", name, "InputBoxTemplate")

	editBox.frame:SetWidth(width)
	editBox.frame:SetHeight(height)
	editBox.frame:SetAutoFocus(false)

	editBox.frame:SetScript("OnTextChanged", function(self, userInput)
		DispatchMethod("On" .. name .. "ValueChanged", editBox.frame:GetText())
	end)

	editBox.frame:SetScript("OnEnterPressed", function(self, userInput)
		DispatchMethod("On" .. name .. "EnterPressed", editBox.frame:GetText())
	end)

	return editBox
end

function Options:AddSlider(name, min, max, startValue, step)
	local frameName = OptionsFrame:GetName() .. name
	local slider = FrameObject:New("Slider", name, "OptionsSliderTemplate")

	slider.frame:SetMinMaxValues(min, max)
	slider.frame:SetValue(startValue)
	slider.frame:SetValueStep(step)
	_G[frameName.."Low"]:SetText(tostring(min)) --FIXME: We should really add parameters for these three.
	_G[frameName.."High"]:SetText(tostring(max))
	_G[frameName.."Text"]:SetText(name)

	slider.frame:SetScript("OnValueChanged", function(self, value)
		DispatchMethod("On" .. name .. "ValueChanged", value)
	end)

	return slider
end

function Options:AttachRight(frame, attachedTo, offsetX, offsetY)
	local offsetX = offsetX or -30
	local offsetY = offsetY or 0

	frame:SetPoint("CENTER", attachedTo, "RIGHT", offsetX, offsetY)
end

function Options:AttachLeft(frame, attachedTo, offsetX, offsetY)
	local offsetX = offsetX or 30
	local offsetY = offsetY or 0

	frame:SetPoint("CENTER", attachedTo, "LEFT", offsetX, offsetY)
end

function Options:AttachAbove(frame, attachedTo, offsetX, offsetY)
	local offsetX = offsetX or 0
	local offsetY = offsetY or 60

	frame:SetPoint("CENTER", attachedTo, "TOP", offsetX, offsetY)
end

function Options:AttachBelow(frame, attachedTo, offsetX, offsetY)
	local offsetX = offsetX or 0
	local offsetY = offsetY or -60

	frame:SetPoint("CENTER", attachedTo, "BOTTOM", offsetX, offsetY)
end

function Options:CreatePanel(title, icon) -- TODO: Possible add a bool for a slash command that opens to options panel
	local name = AddonName .. "OptionsFrame"
	local version = GetAddOnMetadata(AddonName, "Version") or ""
	local title = title or AddonName

	OptionsFrame = CreateFrame("Frame", name, InterfaceOptionsFramePanelContainer)
	OptionsFrame.name = AddonName

	local text = OptionsFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	text:SetPoint("TOPLEFT", 16, -16)

	if icon then
		text:SetFormattedText("|T%s:%d|t %s %s", icon, 16, title, version)
	else
		text:SetText(title .. version)
	end

	OptionsFrame.okay = function() DispatchMethod("OnInterfaceOptionsOkayButtonClicked") end
	OptionsFrame.cancel = function() DispatchMethod("OnInterfaceOptionsCancelButtonClicked") end

	InterfaceOptions_AddCategory(OptionsFrame)
	return OptionsFrame
end

function Options:AddDropDownMenu(name, menuList)
	local frameName = OptionsFrame:GetName() .. name
	local dropDownMenuFrame = CreateFrame("Button", frameName, OptionsFrame, "UIDropDownMenuTemplate")

 	UIDropDownMenu_Initialize(dropDownMenuFrame, function(self)
		local info = UIDropDownMenu_CreateInfo()

		for k,v in pairs(menuList) do
			info = UIDropDownMenu_CreateInfo()
			info.text = v
			info.value = v
			info.func = function(self)
				UIDropDownMenu_SetSelectedID(dropDownMenuFrame, self:GetID())
				DispatchMethod("On" .. name .. "ValueChanged", self:GetText(), self:GetID())
			end
			UIDropDownMenu_AddButton(info, level)
		end
	end)

	return dropDownMenuFrame
end

Addon.Options = Options

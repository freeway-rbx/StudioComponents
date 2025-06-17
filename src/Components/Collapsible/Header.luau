local CommonProps = require(script.Parent.Parent.Parent.CommonProps)
local React = require("@pkg/@jsdotlua/react")

local e = React.createElement
local useTheme = require("../../Hooks/useTheme")
local useToggleState = require("../../Hooks/useToggleState")

local HEADER_HEIGHT = 24
local ARROW_RIGHT = "rbxasset://textures/ui/MenuBar/arrow_right.png"
local ARROW_DOWN = "rbxasset://textures/ui/MenuBar/arrow_down.png"

local function HeaderIcon(props: CommonProps.T & { Icon: { Image: string, UseThemeColor: boolean? } })
	local theme = useTheme()

	return e("ImageLabel", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = props.LayoutOrder,
		Size = props.Size or UDim2.fromOffset(HEADER_HEIGHT, HEADER_HEIGHT),
		ImageColor3 = if props.Icon.UseThemeColor ~= true
			then Color3.fromRGB(255, 255, 255)
			else theme:GetColor(Enum.StudioStyleGuideColor.MainText),
		ImageTransparency = if props.Disabled then 0.6 else 0,
		Image = props.Icon.Image,
	})
end

local function Header(props: CommonProps.T & {
	Selected: boolean?,
	Expanded: boolean?,
	IsBlockStyle: boolean?,
	OnActivated: () -> (),
	Text: string,
	Icon: {
		Image: string?,
		UseThemeColor: boolean?,
	},
})
	local theme = useTheme()
	local hovering = useToggleState(false)

	local modifier = Enum.StudioStyleGuideModifier.Default

	return e("TextButton", {
		AutomaticSize = Enum.AutomaticSize.X,
		AutoButtonColor = false,
		BackgroundColor3 = if hovering.on
			then theme:GetColor(Enum.StudioStyleGuideColor.ViewPortBackground)
			elseif props.IsBlockStyle then theme:GetColor(Enum.StudioStyleGuideColor.Titlebar)
			else theme:GetColor(Enum.StudioStyleGuideColor.MainBackground),
		BackgroundTransparency = 0,
		BorderSizePixel = if props.IsBlockStyle then 1 else 0,
		BorderColor3 = theme:GetColor(Enum.StudioStyleGuideColor.Border, modifier),
		Size = UDim2.new(1, 0, 0, HEADER_HEIGHT),
		LayoutOrder = props.LayoutOrder,
		Text = "",
		ClipsDescendants = true,

		[React.Event.MouseEnter] = if not props.Disabled then hovering.enable else nil,
		[React.Event.MouseLeave] = if not props.Disabled then hovering.disable else nil,
		[React.Event.Activated] = if not props.Disabled then props.OnActivated else nil,
	}, {
		Layout = e("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			Padding = UDim.new(0, 0),
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
		}),

		UIPadding = e("UIPadding", {
			PaddingLeft = UDim.new(0, 5),
		}),

		ArrowIconFrame = e(HeaderIcon, {
			Icon = {
				Image = if props.Expanded then ARROW_DOWN else ARROW_RIGHT,
				UseThemeColor = true,
			},
			Disabled = props.Disabled,
			LayoutOrder = 1,
			Size = UDim2.fromOffset(HEADER_HEIGHT * 0.75, HEADER_HEIGHT * 0.75),
		}),

		IconFrame = props.Icon and e(HeaderIcon, {
			Icon = props.Icon,
			Disabled = props.Disabled,
			LayoutOrder = 2,
		}),

		Title = e("TextLabel", {
			AutomaticSize = Enum.AutomaticSize.X,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = 3,
			TextTransparency = if props.Disabled then 0.5 else 0,
			Size = UDim2.fromOffset(0, HEADER_HEIGHT),
			Text = props.Text,
			TextColor3 = theme:GetColor(Enum.StudioStyleGuideColor.MainText),
			TextXAlignment = Enum.TextXAlignment.Left,
		}, {
			UIPadding = e("UIPadding", {
				PaddingLeft = UDim.new(0, 4),
			}),
		}),
	})
end

return Header

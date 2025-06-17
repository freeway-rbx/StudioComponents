--[=[
	@class Collapsible
	A simple collapsible component that reveals content when clicked. 

	| Dark | Light |
	| - | - |
	| ![Dark](/StudioComponents/components/collapsible/dark.png) | ![Light](/StudioComponents/components/collapsible/light.png) |

	```lua
	local function MySettingsPage()
		return React.createElement(StudioComponents.Background, {}, {
			General = e(StudioComponents.Collapsible, {
				Title = "General",
				Icon = { 
					Image = "path.to.icon",
					UseThemeColor = false, 
				},
				IsBlockStyle = true,
				LayoutOrder = 1
			}, {
				-- general settings here

				-- collapsibles can also be nested to create tree structures
				AnotherCollapsible = e(StudioComponents.Collapsible, {
					Title = "Another Collapsible",
					IsBlockStyle = false, -- for this nested collapsible let's not use the block style
				}),
			}),

			Graphics = e(StudioComponents.Collapsible, {
				Title = "Graphics",
				IsBlockStyle = true,
				LayoutOrder = 2
			}, {
				-- graphics settings here
			}),

			Audio = e(StudioComponents.Collapsible, {
				Title = "Audio",
				IsBlockStyle = true,
				LayoutOrder = 3
			}, {
				-- audio settings here
			}),
		})
	end
	```
]=]

local React = require("@pkg/@jsdotlua/react")

local e = React.createElement
local CommonProps = require(script.Parent.Parent.CommonProps)
local Header = require(script.Header)
local useToggleState = require("../Hooks/useToggleState")

--[=[
	@within Collapsible
	@interface IconProps

	@field Image string
	@field UseThemeColor boolean?
]=]

--[=[
	@within Collapsible
	@interface Props
	@tag Component Props

	@field ... CommonProps
	@field Title string
	@field IsBlockStyle boolean?
	@field KeepContentMounted boolean? -- if true, uses `Visible` based rendering instead of re-mounting
	@field Icon IconProps?
	@field Layout React.Element<UILayout>?
	@field ContentPadding React.Element<UIPadding>?
]=]

local function Collapsible(props: CommonProps.T & {
	Title: string,
	IsBlockStyle: boolean?,
	KeepContentMounted: boolean?,
	Icon: {
		Image: string?,
		UseThemeColor: boolean?,
	},
	Layout: React.Element<UILayout>?,
	ContentPadding: React.Element<UIPadding>?,
	children: React.ReactNode,
})
	local collapsible = useToggleState(false)

	return e("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = props.LayoutOrder,
	}, {
		UIListLayout = e("UIListLayout", {
			Padding = UDim.new(0, 0),
			SortOrder = Enum.SortOrder.LayoutOrder,
		}),

		Header = e(Header, {
			OnActivated = collapsible.toggle,
			IsBlockStyle = props.IsBlockStyle or false,
			Expanded = collapsible.on,
			Disabled = props.Disabled,
			Icon = props.Icon,
			Text = props.Title,
			LayoutOrder = 1,
		}),

		Content = if not props.KeepContentMounted and not (collapsible.on and props.Disabled ~= true)
			then nil
			else e("Frame", {
				BackgroundTransparency = 1,
				Position = UDim2.fromOffset(30, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.fromScale(1, 0),
				AnchorPoint = Vector2.new(0, 0),
				Visible = if props.KeepContentMounted then (collapsible.on and props.Disabled ~= true) else true,
				LayoutOrder = 2,
			}, {
				UIListLayout = props.Layout or e("UIListLayout", {
					Padding = UDim.new(0, 5),
					SortOrder = Enum.SortOrder.LayoutOrder,
				}),

				UIPadding = props.ContentPadding or e("UIPadding", {
					PaddingLeft = UDim.new(0, 10),
					PaddingTop = UDim.new(0, 5),
				}),
			}, props.children),
	})
end

return Collapsible

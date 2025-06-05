--[=[
	@class Collapsible
	A simple collapsible component that reveals content when clicked. 

	| Dark | Light |
	| - | - |
	| ![Dark](/StudioComponents/components/collapsible/dark.png) | ![Light](/StudioComponents/components/collapsible/light.png) |

	```lua
	local function MySettingsPage()
		return React.createElement(StudioComponents.Background, {
		}, {
			General = e(StudioComponents.Collapsible, {
				Title = "General",
				IsBlockStyle = true,
				LayoutOrder = 1
			}, {
				... content here
			}),

			Graphics = e(StudioComponents.Collapsible, {
				Title = "Graphics",
				IsBlockStyle = true,
				LayoutOrder = 2
			}, {
				... content here
			}),

			Audio = e(StudioComponents.Collapsible, {
				Title = "Audio",
				IsBlockStyle = true,
				LayoutOrder = 3
			}, {
				... content here
			}),
		})
	end
	```

	Collapsibles can also be nested. Pass custom children in at any level or continue to pass `Collapsisble`s as children to create a tree structure (like a file explorer):
	```lua
	local function MyPluginExplorer()
		return e(StudioComponents.Collapsible, {
			Title = "Tree Level 1",
			IsBlockStyle = true,
		}, {
			Workspace = e(StudioComponents.Collapsible, {
				Title = "Workspace",
				Icon = { Image = "path.to.icon" },
				IsBlockStyle = true,
			}, {
				-- fill with Workspace contents here
			}),

			Players = e(StudioComponents.Collapsible, {
				Title = "Players",
				Icon = { Image = "path.to.icon" },
				IsBlockStyle = true,
			}, {
				-- fill with Players here
			}),

			ReplicatedStorage = e(StudioComponents.Collapsible, {
				Title = "ReplicatedStorage",
				Icon = { Image = "path.to.icon" },
				IsBlockStyle = true,
			}, {
				-- A collapsible within a collapsible!
				Assets = e(StudioComponents.Collapsible, {
					Title = "Assets",
				}, {
					-- fill with Assets contents here
				})
			}),

			Lighting = e(StudioComponents.Collapsible, {
				Title = "Lighting",
				Icon = { Image = "path.to.icon" },
				Disabled = true,
				IsBlockStyle = true,
			}, {
				-- fill with Lighting contents here
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
	@field KeepContentMounted boolean?
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

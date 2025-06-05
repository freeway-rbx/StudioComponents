local Checkbox = require("../Components/Checkbox")
local React = require("@pkg/@jsdotlua/react")

local Collapsible = require("../Components/Collapsible")
local createStory = require("./Helpers/createStory")

local e = React.createElement

local function Content()
	local checked, setChecked = React.useState(false)

	return e(Checkbox, {
		Value = checked,
		Label = "Test",
		OnChanged = function()
			setChecked(not checked)
		end,
	})
end

local function RecursiveCollapsible(props: { number: number })
	return e(Collapsible, {
		Title = if props.number == 1 then "Recursive Collapsible (Tree)" else `Collapsible {props.number - 1}`,
		LayoutOrder = 3,
	}, e(RecursiveCollapsible, { number = props.number + 1 }))
end

local function Story()
	return e("Frame", {
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BorderSizePixel = 0,
	}, {
		UIListLayout = e("UIListLayout", {
			Padding = UDim.new(0, 30),
			SortOrder = Enum.SortOrder.LayoutOrder,
		}),

		BlockCollapsible = e(Collapsible, {
			Title = "Block Collapsible",
			LayoutOrder = 1,
			IsBlockStyle = true,
		}, {
			Content = e(Content),
		}),

		CollapsibleWithIcon = e(Collapsible, {
			Title = "Block Collapsible w/ Icon",
			LayoutOrder = 1,
			Icon = {
				Image = "rbxasset://textures/TerrainTools/icon_shape_cube.png",
			},
			IsBlockStyle = true,
		}, {
			Content = e(Content),
		}),

		Collapsible = e(Collapsible, {
			Title = "Collapsible",
			LayoutOrder = 2,
		}, {
			EnabledCollapsible = e(Collapsible, {
				Title = "Enabled Collapsible",
			}, {
				Content = e(Content),
			}),

			DisabledCollapsible = e(Collapsible, {
				Title = "Disabled Collapsible",
				LayoutOrder = 2,
				Disabled = true,
			}),
		}),

		CollapsibleTree = e(RecursiveCollapsible, {
			number = 1,
		}),
	})
end

return createStory(Story)

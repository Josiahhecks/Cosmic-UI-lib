--[[ 
    Nebula UI Library
    Created by josiahhecks
    Version 2.0.0
]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

local Nebula = {
    Icons = {
        Square = "rbxassetid://14635164959",
        Circle = "rbxassetid://14635165511",
        Star = "rbxassetid://14635166105"
    },
    Theme = {
        Primary = Color3.fromRGB(20, 20, 30),
        Secondary = Color3.fromRGB(30, 30, 45),
        Accent = Color3.fromRGB(96, 130, 255),
        Text = Color3.fromRGB(240, 240, 255),
        Divider = Color3.fromRGB(40, 40, 60)
    }
}

-- Utility Functions
function Nebula:Create(class, properties)
    local instance = Instance.new(class)
    for prop, value in pairs(properties) do
        instance[prop] = value
    end
    return instance
end

function Nebula:Tween(instance, properties, duration)
    return TweenService:Create(instance, TweenInfo.new(duration, Enum.EasingStyle.Quart), properties)
end

function Nebula:CreateWindow(title)
    local Window = {}
    
    -- Main GUI
    Window.Screen = self:Create("ScreenGui", {
        Name = "NebulaUI",
        Parent = CoreGui,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })
    
    Window.Main = self:Create("Frame", {
        Name = "Main",
        Parent = Window.Screen,
        BackgroundColor3 = self.Theme.Primary,
        BorderSizePixel = 0,
        Position = UDim2.new(0.5, -300, 0.5, -200),
        Size = UDim2.new(0, 600, 0, 400),
        ClipsDescendants = true
    })
    
    -- Add Gradient
    local UIGradient = self:Create("UIGradient", {
        Parent = Window.Main,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, self.Theme.Primary),
            ColorSequenceKeypoint.new(1, self.Theme.Secondary)
        }),
        Rotation = 45
    })
    
    -- Title Bar with Premium Design
    Window.TitleBar = self:Create("Frame", {
        Name = "TitleBar",
        Parent = Window.Main,
        BackgroundColor3 = self.Theme.Secondary,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 30)
    })
    
    -- Title with Icon
    Window.TitleIcon = self:Create("ImageLabel", {
        Parent = Window.TitleBar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 5, 0, 5),
        Size = UDim2.new(0, 20, 0, 20),
        Image = self.Icons.Star
    })
    
    Window.Title = self:Create("TextLabel", {
        Parent = Window.TitleBar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 30, 0, 0),
        Size = UDim2.new(1, -30, 1, 0),
        Font = Enum.Font.GothamBold,
        Text = title,
        TextColor3 = self.Theme.Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    -- Content Area
    Window.ContentArea = self:Create("Frame", {
        Name = "ContentArea",
        Parent = Window.Main,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 30),
        Size = UDim2.new(1, 0, 1, -30)
    })
    
    -- Tab System
    Window.TabHolder = self:Create("Frame", {
        Name = "TabHolder",
        Parent = Window.ContentArea,
        BackgroundColor3 = self.Theme.Secondary,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 5, 0, 5),
        Size = UDim2.new(0, 120, 1, -10)
    })
    
    Window.TabContent = self:Create("Frame", {
        Name = "TabContent",
        Parent = Window.ContentArea,
        BackgroundColor3 = self.Theme.Secondary,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 130, 0, 5),
        Size = UDim2.new(1, -135, 1, -10)
    })
    
    -- Make Window Draggable
    local dragging, dragInput, dragStart, startPos
    
    Window.TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Window.Main.Position
        end
    end)
    
    Window.TitleBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    RunService.RenderStepped:Connect(function()
        if dragging then
            local delta = dragInput.Position - dragStart
            Window.Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    -- Tab Creation
    function Window:AddTab(name, icon)
        local Tab = {}
        
        Tab.Button = Nebula:Create("TextButton", {
            Parent = Window.TabHolder,
            BackgroundColor3 = Nebula.Theme.Primary,
            BorderSizePixel = 0,
            Size = UDim2.new(1, -10, 0, 30),
            Text = name,
            Font = Enum.Font.GothamSemibold,
            TextColor3 = Nebula.Theme.Text,
            TextSize = 12
        })
        
        if icon then
            local Icon = Nebula:Create("ImageLabel", {
                Parent = Tab.Button,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 5, 0.5, -8),
                Size = UDim2.new(0, 16, 0, 16),
                Image = Nebula.Icons[icon]
            })
            Tab.Button.TextPadding = UDim.new(0, 25)
        end
        
        Tab.Container = Nebula:Create("ScrollingFrame", {
            Parent = Window.TabContent,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            ScrollBarThickness = 2,
            Visible = false
        })
        
        -- Add Elements Functions
        function Tab:AddDivider(text)
            local Divider = Nebula:Create("Frame", {
                Parent = Tab.Container,
                BackgroundColor3 = Nebula.Theme.Divider,
                BorderSizePixel = 0,
                Size = UDim2.new(1, -20, 0, 2),
                Position = UDim2.new(0, 10, 0, #Tab.Container:GetChildren() * 35)
            })
            
            if text then
                local Label = Nebula:Create("TextLabel", {
                    Parent = Divider,
                    BackgroundColor3 = Nebula.Theme.Secondary,
                    Position = UDim2.new(0.5, -25, -0.5, 0),
                    Size = UDim2.new(0, 50, 0, 16),
                    Font = Enum.Font.GothamBold,
                    Text = text,
                    TextColor3 = Nebula.Theme.Text,
                    TextSize = 10
                })
            end
        end
        
        function Tab:AddButton(text, callback)
            local Button = Nebula:Create("TextButton", {
                Parent = Tab.Container,
                BackgroundColor3 = Nebula.Theme.Secondary,
                BorderSizePixel = 0,
                Position = UDim2.new(0, 10, 0, #Tab.Container:GetChildren() * 35),
                Size = UDim2.new(1, -20, 0, 30),
                Font = Enum.Font.GothamSemibold,
                Text = text,
                TextColor3 = Nebula.Theme.Text,
                TextSize = 12
            })
            
            Button.MouseButton1Click:Connect(callback)
            return Button
        end
        
        -- Add more element functions here (Toggle, Slider, etc.)
        
        return Tab
    end
    
    return Window
end

return Nebula

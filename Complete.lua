local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

local Library = {
    Flags = {},
    Theme = {
        Background = Color3.fromRGB(30, 30, 30),
        Accent = Color3.fromRGB(0, 255, 128),
        Text = Color3.fromRGB(255, 255, 255),
        DarkContrast = Color3.fromRGB(20, 20, 20),
        LightContrast = Color3.fromRGB(40, 40, 40)
    }
}

function Library:Create(class, properties)
    local instance = Instance.new(class)
    
    for property, value in pairs(properties) do
        instance[property] = value
    end
    
    return instance
end

function Library:CreateWindow(title)
    local Window = {}
    
    -- Main GUI Creation
    Window.Screen = Library:Create("ScreenGui", {
        Name = title,
        Parent = CoreGui
    })
    
    Window.Main = Library:Create("Frame", {
        Name = "Main",
        Parent = Window.Screen,
        BackgroundColor3 = Library.Theme.Background,
        BorderSizePixel = 0,
        Position = UDim2.new(0.5, -300, 0.5, -200),
        Size = UDim2.new(0, 600, 0, 400)
    })
    
    -- Add Corner
    Library:Create("UICorner", {
        Parent = Window.Main,
        CornerRadius = UDim.new(0, 6)
    })
    
    -- Title Bar
    Window.TitleBar = Library:Create("Frame", {
        Name = "TitleBar",
        Parent = Window.Main,
        BackgroundColor3 = Library.Theme.DarkContrast,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 30)
    })
    
    Library:Create("UICorner", {
        Parent = Window.TitleBar,
        CornerRadius = UDim.new(0, 6)
    })
    
    -- Title Text
    Window.Title = Library:Create("TextLabel", {
        Parent = Window.TitleBar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 0),
        Size = UDim2.new(1, -20, 1, 0),
        Font = Enum.Font.GothamBold,
        Text = title,
        TextColor3 = Library.Theme.Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    -- Tab Container
    Window.TabContainer = Library:Create("Frame", {
        Name = "TabContainer",
        Parent = Window.Main,
        BackgroundColor3 = Library.Theme.DarkContrast,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 10, 0, 40),
        Size = UDim2.new(0, 150, 1, -50)
    })
    
    Library:Create("UICorner", {
        Parent = Window.TabContainer,
        CornerRadius = UDim.new(0, 6)
    })
    
    -- Content Container
    Window.ContentContainer = Library:Create("Frame", {
        Name = "ContentContainer",
        Parent = Window.Main,
        BackgroundColor3 = Library.Theme.DarkContrast,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 170, 0, 40),
        Size = UDim2.new(1, -180, 1, -50)
    })
    
    Library:Create("UICorner", {
        Parent = Window.ContentContainer,
        CornerRadius = UDim.new(0, 6)
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
    
    function Window:AddTab(name)
        local Tab = {}
        
        -- Tab Button
        Tab.Button = Library:Create("TextButton", {
            Name = name,
            Parent = Window.TabContainer,
            BackgroundColor3 = Library.Theme.LightContrast,
            BorderSizePixel = 0,
            Size = UDim2.new(1, -10, 0, 30),
            Font = Enum.Font.Gotham,
            Text = name,
            TextColor3 = Library.Theme.Text,
            TextSize = 14
        })
        
        Library:Create("UICorner", {
            Parent = Tab.Button,
            CornerRadius = UDim.new(0, 6)
        })
        
        -- Tab Content
        Tab.Content = Library:Create("ScrollingFrame", {
            Name = name,
            Parent = Window.ContentContainer,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 1, 0),
            CanvasSize = UDim2.new(0, 0, 0, 0),
            ScrollBarThickness = 4,
            Visible = false
        })
        
        -- Add Elements Functions
        function Tab:AddToggle(text, default, callback)
            local Toggle = {}
            
            Toggle.Button = Library:Create("TextButton", {
                Parent = Tab.Content,
                BackgroundColor3 = Library.Theme.LightContrast,
                BorderSizePixel = 0,
                Size = UDim2.new(1, -20, 0, 30),
                Font = Enum.Font.Gotham,
                Text = text,
                TextColor3 = Library.Theme.Text,
                TextSize = 14
            })
            
            Toggle.Indicator = Library:Create("Frame", {
                Parent = Toggle.Button,
                BackgroundColor3 = default and Library.Theme.Accent or Library.Theme.DarkContrast,
                BorderSizePixel = 0,
                Position = UDim2.new(1, -40, 0.5, -10),
                Size = UDim2.new(0, 20, 0, 20)
            })
            
            Library:Create("UICorner", {
                Parent = Toggle.Indicator,
                CornerRadius = UDim.new(0, 4)
            })
            
            Toggle.Button.MouseButton1Click:Connect(function()
                default = not default
                Toggle.Indicator.BackgroundColor3 = default and Library.Theme.Accent or Library.Theme.DarkContrast
                callback(default)
            end)
            
            return Toggle
        end
        
        function Tab:AddSlider(text, min, max, default, callback)
            local Slider = {}
            
            Slider.Container = Library:Create("Frame", {
                Parent = Tab.Content,
                BackgroundColor3 = Library.Theme.LightContrast,
                BorderSizePixel = 0,
                Size = UDim2.new(1, -20, 0, 50)
            })
            
            -- Add slider implementation here
            
            return Slider
        end
        
        -- Tab Button Click Handler
        Tab.Button.MouseButton1Click:Connect(function()
            for _, tab in pairs(Window.ContentContainer:GetChildren()) do
                if tab:IsA("ScrollingFrame") then
                    tab.Visible = tab == Tab.Content
                end
            end
        end)
        
        return Tab
    end
    
    return Window
end

return Library

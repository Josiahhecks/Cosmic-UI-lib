# Nebula UI Library

A powerful, modern UI library for Roblox exploiting, featuring a sleek space-themed design and smooth animations.

## 🚀 Getting Started

Load the library:
```lua
local Nebula = loadstring(game:HttpGet('https://raw.githubusercontent.com/YourRepo/Nebula/main.lua'))()

Create a window:

local Window = Nebula:CreateWindow("My First Script")

📋 Features
Create tabs:
local MainTab = Window:AddTab("Main")

Add toggles:
MainTab:AddToggle("Toggle Feature", false, function(state)
    print("Toggle state:", state)
end)

Add sliders:
MainTab:AddSlider("Walk Speed", 16, 500, 16, function(value)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
end)

🎨 Customization
Change theme colors:

Nebula.Theme = {
    Background = Color3.fromRGB(30, 30, 30),
    Accent = Color3.fromRGB(0, 255, 128),
    Text = Color3.fromRGB(255, 255, 255)
}

⚡ Key Features
Modern Space Theme
Smooth Animations
Draggable Interface
Multiple Tabs Support
Toggle Animations
Slider Functionality
Theme Customization
Responsive Design
🛠️ Examples
Create a full featured window:

local Window = Nebula:CreateWindow("Nebula Example")
local MainTab = Window:AddTab("Main")

MainTab:AddToggle("Feature", false, function(state)
    print("Toggled:", state)
end)

MainTab:AddSlider("Speed", 0, 100, 16, function(value)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
end)

📝 Credits
Created by josiahhecks Version 1.0.0


This README provides clear instructions, examples, and showcases the library's key features in a professional format.

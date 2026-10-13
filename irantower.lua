
-- Iran Tower - Mobile UI Demo
-- UI demonstration for your own project

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "IranTowerDemo"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local panel = Instance.new("Frame")
panel.Size = UDim2.fromOffset(240, 220)
panel.Position = UDim2.new(0, 12, 0.3, 0)
panel.BackgroundColor3 = Color3.fromRGB(25, 30, 45)
panel.Parent = gui

Instance.new("UICorner", panel).CornerRadius =
    UDim.new(0, 14)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -12, 0, 42)
title.Position = UDim2.fromOffset(6, 5)
title.BackgroundTransparency = 1
title.Text = "🇮🇷 ایران تاور"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextScaled = true
title.Parent = panel

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -12, 0, 32)
status.Position = UDim2.fromOffset(6, 48)
status.BackgroundTransparency = 1
status.Text = "پنل تمرین آماده است"
status.TextColor3 = Color3.fromRGB(120, 220, 255)
status.TextScaled = true
status.Parent = panel

local function addButton(text, y, callback)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -20, 0, 38)
    b.Position = UDim2.fromOffset(10, y)
    b.Text = text
    b.TextScaled = true
    b.TextColor3 = Color3.new(1, 1, 1)
    b.BackgroundColor3 = Color3.fromRGB(40, 110, 175)
    b.Parent = panel

    Instance.new("UICorner", b).CornerRadius =
        UDim.new(0, 8)

    b.Activated:Connect(callback)
end

addButton("نمایش مرحله", 88, function()
    status.Text = "مرحله: اطلاعات موجود نیست"
end)

addButton("راهنمای تمرین", 132, function()
    status.Text = "موانع را با دقت بررسی کن!"
end)

addButton("بستن منو", 176, function()
    gui.Enabled = false
end)

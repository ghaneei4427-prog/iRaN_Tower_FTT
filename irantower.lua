
--[[
    AM1R • NEON
    Custom Mobile Panel
    Created by AM1R ♡
    For your own Roblox Studio experience
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")


-- AM1R movement settings
-- For your own Roblox Studio experience

local DEFAULT_SPEED = 300
local DEFAULT_JUMP = 200

local speedButton = makeButton("⚡ Speed: 300", 334)
local jumpButton = makeButton("🦘 Jump: 200", 377)

speedButton.Activated:Connect(function()
    setStatus("سرعت انتخاب‌شده: " .. DEFAULT_SPEED)
end)

jumpButton.Activated:Connect(function()
    setStatus("قدرت پرش انتخاب‌شده: " .. DEFAULT_JUMP)
end)

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local GUI_NAME = "AM1R_NeonPanel"

-- Remove previous copy
local old = playerGui:FindFirstChild(GUI_NAME)
if old then
    old:Destroy()
end

-- Theme
local GREEN = Color3.fromRGB(57, 255, 135)
local DARK = Color3.fromRGB(10, 17, 14)
local CARD = Color3.fromRGB(22, 36, 30)
local WHITE = Color3.fromRGB(240, 255, 246)
local MUTED = Color3.fromRGB(160, 195, 174)

local gui = Instance.new("ScreenGui")
gui.Name = GUI_NAME
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = playerGui

-- Helpers
local function round(obj, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = obj
end

local function stroke(obj, color, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color or GREEN
    s.Thickness = thickness or 1
    s.Transparency = 0.12
    s.Parent = obj
end

local function tween(obj, props, duration)
    local t = TweenService:Create(
        obj,
        TweenInfo.new(
            duration or 0.2,
            Enum.EasingStyle.Quart,
            Enum.EasingDirection.Out
        ),
        props
    )
    t:Play()
    return t
end

-- Main panel
local panel = Instance.new("Frame")
panel.Name = "Main"
panel.Size = UDim2.fromOffset(280, 375)
panel.Position = UDim2.new(0, 12, 0.5, -187)
panel.BackgroundColor3 = DARK
panel.BorderSizePixel = 0
panel.Parent = gui
round(panel, 16)
stroke(panel, GREEN, 2)

local panelScale = Instance.new("UIScale")
panelScale.Scale = 1
panelScale.Parent = panel

-- Header
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 68)
header.BackgroundColor3 = Color3.fromRGB(17, 56, 36)
header.BorderSizePixel = 0
header.Parent = panel
round(header, 15)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -18, 0, 30)
title.Position = UDim2.fromOffset(9, 5)
title.BackgroundTransparency = 1
title.Text = "AM1R  •  NEON"
title.TextColor3 = GREEN
title.TextSize = 20
title.Font = Enum.Font.GothamBlack
title.Parent = header

local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, -18, 0, 22)
subtitle.Position = UDim2.fromOffset(9, 35)
subtitle.BackgroundTransparency = 1
subtitle.Text = "MOBILE CONTROL CENTER  ♡"
subtitle.TextColor3 = WHITE
subtitle.TextSize = 10
subtitle.Font = Enum.Font.GothamMedium
subtitle.Parent = header

-- Welcome
local welcome = Instance.new("TextLabel")
welcome.Size = UDim2.new(1, -20, 0, 38)
welcome.Position = UDim2.fromOffset(10, 75)
welcome.BackgroundTransparency = 1
welcome.Text = "سلام رفیق! خوش اومدی ♡\nپنل اختصاصی AM1R"
welcome.TextColor3 = WHITE
welcome.TextSize = 12
welcome.TextWrapped = true
welcome.Font = Enum.Font.GothamMedium
welcome.Parent = panel

-- Status card
local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -20, 0, 36)
status.Position = UDim2.fromOffset(10, 117)
status.BackgroundColor3 = CARD
status.BorderSizePixel = 0
status.Text = "●  سیستم آماده است"
status.TextColor3 = GREEN
status.TextSize = 12
status.TextWrapped = true
status.Font = Enum.Font.GothamBold
status.Parent = panel
round(status, 9)

local function setStatus(message, color)
    status.Text = message
    status.TextColor3 = color or GREEN
end

-- Button factory
local function makeButton(text, y)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -20, 0, 37)
    b.Position = UDim2.fromOffset(10, y)
    b.BackgroundColor3 = CARD
    b.BorderSizePixel = 0
    b.Text = text
    b.TextColor3 = WHITE
    b.TextSize = 12
    b.TextWrapped = true
    b.Font = Enum.Font.GothamBold
    b.AutoButtonColor = false
    b.Parent = panel

    round(b, 9)
    stroke(b, GREEN, 1)

    b.MouseEnter:Connect(function()
        tween(b, {
            BackgroundColor3 = Color3.fromRGB(30, 65, 43)
        }, 0.12)
    end)

    b.MouseLeave:Connect(function()
        tween(b, {BackgroundColor3 = CARD}, 0.12)
    end)

    b.Activated:Connect(function()
        tween(b, {
            BackgroundColor3 = Color3.fromRGB(38, 90, 54)
        }, 0.06)

        task.delay(0.12, function()
            if b.Parent then
                tween(b, {BackgroundColor3 = CARD}, 0.12)
            end
        end)
    end)

    return b
end

local stageButton = makeButton("🏁  نمایش مرحله فعلی", 162)
local checkpointButton = makeButton("📍  نزدیک‌ترین چک‌پوینت", 205)
local refreshButton = makeButton("↻  به‌روزرسانی وضعیت", 248)
local hideButton = makeButton("×  مخفی کردن پنل", 291)

-- Stage information
stageButton.Activated:Connect(function()
    local stats = player:FindFirstChild("leaderstats")
    local stage = stats and (
        stats:FindFirstChild("Stage")
        or stats:FindFirstChild("Checkpoint")
        or stats:FindFirstChild("Level")
    )

    if stage then
        setStatus("🏁  مرحله: " .. tostring(stage.Value))
    else
        setStatus("اطلاعات مرحله پیدا نشد", MUTED)
    end
end)

-- Nearest checkpoint
checkpointButton.Activated:Connect(function()
    local folder = workspace:FindFirstChild("Checkpoints")
    local character = player.Character
    local root = character and
        character:FindFirstChild("HumanoidRootPart")

    if not root then
        setStatus("شخصیت هنوز آماده نیست", MUTED)
        return
    end

    if not folder then
        setStatus("پوشه Checkpoints پیدا نشد", MUTED)
        return
    end

    local nearest = nil
    local bestDistance = math.huge

    for _, point in ipairs(folder:GetDescendants()) do
        if point:IsA("BasePart") then
            local distance =
                (root.Position - point.Position).Magnitude

            if distance < bestDistance then
                bestDistance = distance
                nearest = point
            end
        end
    end

    if nearest then
        setStatus(
            "📍 " .. nearest.Name .. " | " ..
            math.floor(bestDistance) .. " studs"
        )
    else
        setStatus("چک‌پوینتی پیدا نشد", MUTED)
    end
end)

-- Refresh
refreshButton.Activated:Connect(function()
    local character = player.Character
    local humanoid = character and
        character:FindFirstChildOfClass("Humanoid")

    if humanoid then
        setStatus(
            "♥ آماده | HP: " ..
            math.floor(humanoid.Health) .. "/" ..
            math.floor(humanoid.MaxHealth)
        )
    else
        setStatus("در انتظار آماده‌شدن شخصیت...", MUTED)
    end
end)

-- Reopen button
local reopen = Instance.new("TextButton")
reopen.Name = "ReopenButton"
reopen.Size = UDim2.fromOffset(48, 48)
reopen.Position = UDim2.new(1, -62, 0.55, 0)
reopen.BackgroundColor3 = Color3.fromRGB(17, 56, 36)
reopen.BorderSizePixel = 0
reopen.Text = "AM1R\n♡"
reopen.TextColor3 = GREEN
reopen.TextSize = 12
reopen.Font = Enum.Font.GothamBlack
reopen.Visible = false
reopen.Parent = gui
round(reopen, 14)
stroke(reopen, GREEN, 2)

-- Hide panel
hideButton.Activated:Connect(function()
    tween(panel, {
        Position = UDim2.new(0, -310, 0.5, -187)
    }, 0.22)

    task.wait(0.23)
    panel.Visible = false
    reopen.Visible = true
    reopen.Size = UDim2.fromOffset(42, 42)

    tween(reopen, {
        Size = UDim2.fromOffset(48, 48)
    }, 0.16)
end)

-- Show panel
reopen.Activated:Connect(function()
    reopen.Visible = false
    panel.Visible = true
    panel.Position = UDim2.new(0, -310, 0.5, -187)

    tween(panel, {
        Position = UDim2.new(0, 12, 0.5, -187)
    }, 0.24)
end)

-- Keep panel usable on small screens
local function updateScale()
    local camera = workspace.CurrentCamera
    if not camera then return end

    local viewport = camera.ViewportSize
    local fit = math.min(
        1,
        viewport.X / 320,
        viewport.Y / 420
    )

    panelScale.Scale = math.max(0.78, fit)
end

updateScale()

if workspace.CurrentCamera then
    workspace.CurrentCamera:GetPropertyChangedSignal(
        "ViewportSize"
    ):Connect(updateScale)
end

print("AM1R Neon Panel loaded successfully ♡")

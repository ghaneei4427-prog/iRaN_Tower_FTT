
--[[
    🇮🇷 Iran Tower Mobile Training Panel
    ساخته شده توسط AM1RFTT
    رایگان برای لذت بردن شما ♡
    برای تجربه‌ی خودت در Roblox Studio
]]

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local old = playerGui:FindFirstChild("IranTowerMobile")
if old then old:Destroy() end

local oldReopen = playerGui:FindFirstChild("AM1RFTT_Reopen")
if oldReopen then oldReopen:Destroy() end

local purple = Color3.fromRGB(151, 90, 255)
local dark = Color3.fromRGB(23, 21, 37)
local card = Color3.fromRGB(42, 37, 59)
local white = Color3.fromRGB(250, 247, 255)
local muted = Color3.fromRGB(195, 185, 215)
local green = Color3.fromRGB(125, 255, 180)

local gui = Instance.new("ScreenGui")
gui.Name = "IranTowerMobile"
gui.ResetOnSpawn = false
gui.Parent = playerGui

local function round(object, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = object
end

local function outline(object, color, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color or purple
    s.Thickness = thickness or 1
    s.Transparency = 0.15
    s.Parent = object
end

local panel = Instance.new("Frame")
panel.Name = "MainPanel"
panel.Size = UDim2.new(0, 290, 0, 510)
panel.Position = UDim2.new(0, 12, 0.5, -255)
panel.BackgroundColor3 = dark
panel.BorderSizePixel = 0
panel.Parent = gui
round(panel, 18)
outline(panel, purple, 2)

local panelLimit = Instance.new("UISizeConstraint")
panelLimit.MinSize = Vector2.new(260, 480)
panelLimit.MaxSize = Vector2.new(330, 530)
panelLimit.Parent = panel

local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 82)
header.BackgroundColor3 = Color3.fromRGB(59, 39, 91)
header.BorderSizePixel = 0
header.Parent = panel
round(header, 18)

local function label(text, y, height, size, color)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -20, 0, height)
    l.Position = UDim2.fromOffset(10, y)
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = color or white
    l.TextSize = size or 14
    l.TextWrapped = true
    l.Font = Enum.Font.GothamBold
    l.Parent = panel
    return l
end

local creator = Instance.new("TextLabel")
creator.Size = UDim2.new(1, -12, 0, 29)
creator.Position = UDim2.fromOffset(6, 8)
creator.BackgroundTransparency = 1
creator.Text = "ساخته شده توسط AM1RFTT"
creator.TextColor3 = Color3.fromRGB(224, 201, 255)
creator.TextSize = 17
creator.Font = Enum.Font.GothamBold
creator.TextWrapped = true
creator.Parent = header

local heading = Instance.new("TextLabel")
heading.Size = UDim2.new(1, -12, 0, 25)
heading.Position = UDim2.fromOffset(6, 43)
heading.BackgroundTransparency = 1
heading.Text = "🇮🇷 IRAN TOWER  •  MOBILE"
heading.TextColor3 = white
heading.TextSize = 13
heading.Font = Enum.Font.GothamBold
heading.Parent = header

label("سلام ممبرهای عزیز! ♡", 88, 26, 16)

local welcome = label(
    "این اسکریپت برای لذت بردن شماست و کاملاً رایگان هستش!\nامیدوارم لذت ببرید ♡",
    115, 43, 12, muted
)
welcome.Font = Enum.Font.GothamMedium

local status = label("● پنل آماده است", 160, 28, 12, green)

local function makeButton(text, y, color)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -20, 0, 36)
    b.Position = UDim2.fromOffset(10, y)
    b.BackgroundColor3 = color or card
    b.BorderSizePixel = 0
    b.Text = text
    b.TextColor3 = white
    b.TextSize = 13
    b.TextWrapped = true
    b.Font = Enum.Font.GothamBold
    b.AutoButtonColor = true
    b.Parent = panel
    round(b, 10)
    outline(b, purple, 1)
    return b
end

local function makeNumberBox(title, y, value)
    local t = Instance.new("TextLabel")
    t.Size = UDim2.new(0.52, -8, 0, 32)
    t.Position = UDim2.fromOffset(12, y)
    t.BackgroundTransparency = 1
    t.Text = title
    t.TextColor3 = white
    t.TextSize = 12
    t.TextWrapped = true
    t.Font = Enum.Font.GothamBold
    t.Parent = panel

    local box = Instance.new("TextBox")
    box.Size = UDim2.new(0.36, 0, 0, 32)
    box.Position = UDim2.new(0.61, 0, 0, y)
    box.BackgroundColor3 = card
    box.BorderSizePixel = 0
    box.TextColor3 = white
    box.PlaceholderColor3 = muted
    box.PlaceholderText = "عدد"
    box.Text = tostring(value)
    box.TextSize = 14
    box.Font = Enum.Font.GothamBold
    box.ClearTextOnFocus = false
    box.Parent = panel
    round(box, 8)
    outline(box, purple, 1)

    return box
end

local speed = 16
local jump = 50

local speedBox = makeNumberBox("سرعت حرکت", 194, speed)
local jumpBox = makeNumberBox("قدرت پرش", 232, jump)

local function getHumanoid()
    local character = player.Character
    return character and character:FindFirstChildOfClass("Humanoid")
end

makeButton("✦ اعمال سرعت و پرش", 272,
    Color3.fromRGB(91, 56, 145)).Activated:Connect(function()

    local s = tonumber(speedBox.Text)
    local j = tonumber(jumpBox.Text)

    if not s or not j then
        status.Text = "⚠️ لطفاً عدد معتبر وارد کن"
        status.TextColor3 = Color3.fromRGB(255, 190, 110)
        return
    end

    speed = math.clamp(s, 16, 32)
    jump = math.clamp(j, 50, 100)

    speedBox.Text = tostring(speed)
    jumpBox.Text = tostring(jump)

    local humanoid = getHumanoid()
    if not humanoid then
        status.Text = "شخصیت هنوز آماده نیست"
        status.TextColor3 = Color3.fromRGB(255, 190, 110)
        return
    end

    humanoid.WalkSpeed = speed
    humanoid.UseJumpPower = true
    humanoid.JumpPower = jump

    status.Text = "✓ تنظیمات اعمال شدند ♡"
    status.TextColor3 = green
end)

makeButton("🏁 نمایش مرحله فعلی", 314).Activated:Connect(function()
    local stats = player:FindFirstChild("leaderstats")
    local stage = stats and (
        stats:FindFirstChild("Stage")
        or stats:FindFirstChild("Checkpoint")
        or stats:FindFirstChild("مرحله")
    )

    if stage then
        status.Text = "🏁 مرحله: " .. tostring(stage.Value)
        status.TextColor3 = white
    else
        status.Text = "اطلاعات مرحله پیدا نشد"
        status.TextColor3 = muted
    end
end)

makeButton("📍 نزدیک‌ترین چک‌پوینت", 356).Activated:Connect(function()
    local folder = workspace:FindFirstChild("Checkpoints")
    local character = player.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")

    if not folder or not root then
        status.Text = "چک‌پوینت‌ها در دسترس نیستند"
        return
    end

    local nearest
    local bestDistance = math.huge

    for _, point in ipairs(folder:GetDescendants()) do
        if point:IsA("BasePart") then
            local distance = (root.Position - point.Position).Magnitude

            if distance < bestDistance then
                nearest = point
                bestDistance = distance
            end
        end
    end

    if nearest then
        status.Text = nearest.Name .. " | " ..
            math.floor(bestDistance) .. " studs"
        status.TextColor3 = white
    else
        status.Text = "چک‌پوینتی پیدا نشد"
    end
end)

makeButton("➡️ راهنمای چک‌پوینت بعدی", 398).Activated:Connect(function()
    status.Text = "برای راهنمایی دقیق، مراحل بازی خودت را وصل کن"
    status.TextColor3 = muted
end)

local hideButton = makeButton("مخفی کردن پنل  ×", 440,
    Color3.fromRGB(72, 39, 76))

local reopen = Instance.new("TextButton")
reopen.Name = "AM1RFTT_Reopen"
reopen.Size = UDim2.fromOffset(55, 55)
reopen.Position = UDim2.new(1, -70, 0.55, 0)
reopen.BackgroundColor3 = Color3.fromRGB(91, 56, 145)
reopen.BorderSizePixel = 0
reopen.Text = "AM\n♡"
reopen.TextColor3 = white
reopen.TextSize = 14
reopen.Font = Enum.Font.GothamBold
reopen.Visible = false
reopen.Parent = gui
round(reopen, 16)
outline(reopen, purple, 2)

hideButton.Activated:Connect(function()
    panel.Visible = false
    reopen.Visible = true
end)

reopen.Activated:Connect(function()
    panel.Visible = true
    reopen.Visible = false
end)

player.CharacterAdded:Connect(function(character)
    local humanoid = character:WaitForChild("Humanoid", 10)
    if humanoid then
        status.Text = "● شخصیت آماده است ♡"
        status.TextColor3 = green
    end
end)

print("Iran Tower Mobile Panel by AM1RFTT loaded ♡")

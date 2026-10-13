
--[[
    FTT Mobile Control Panel
    Based on the user's Iran Tower Mobile UI style
    For your own Roblox Studio experience
]]

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local old = playerGui:FindFirstChild("FTT_Mobile")
if old then old:Destroy() end

local purple = Color3.fromRGB(151, 90, 255)
local dark = Color3.fromRGB(23, 21, 37)
local card = Color3.fromRGB(42, 37, 59)
local white = Color3.fromRGB(250, 247, 255)
local muted = Color3.fromRGB(195, 185, 215)
local green = Color3.fromRGB(125, 255, 180)

local gui = Instance.new("ScreenGui")
gui.Name = "FTT_Mobile"
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

-- Main panel
local panel = Instance.new("Frame")
panel.Name = "MainPanel"
panel.Size = UDim2.new(0, 290, 0, 500)
panel.Position = UDim2.new(0, 12, 0.5, -250)
panel.BackgroundColor3 = dark
panel.BorderSizePixel = 0
panel.Parent = gui
round(panel, 18)
outline(panel, purple, 2)

local sizeLimit = Instance.new("UISizeConstraint")
sizeLimit.MinSize = Vector2.new(260, 300)
sizeLimit.MaxSize = Vector2.new(330, 600)
sizeLimit.Parent = panel

-- Header
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 66)
header.BackgroundColor3 = Color3.fromRGB(59, 39, 91)
header.BorderSizePixel = 0
header.Parent = panel
round(header, 18)

local creator = Instance.new("TextLabel")
creator.Size = UDim2.new(1, -16, 0, 28)
creator.Position = UDim2.fromOffset(8, 5)
creator.BackgroundTransparency = 1
creator.Text = "FTT CONTROL PANEL"
creator.TextColor3 = Color3.fromRGB(224, 201, 255)
creator.TextSize = 18
creator.Font = Enum.Font.GothamBold
creator.Parent = header

local heading = Instance.new("TextLabel")
heading.Size = UDim2.new(1, -16, 0, 22)
heading.Position = UDim2.fromOffset(8, 34)
heading.BackgroundTransparency = 1
heading.Text = "OBBY • MOBILE EDITION"
heading.TextColor3 = white
heading.TextSize = 12
heading.Font = Enum.Font.GothamBold
heading.Parent = header

-- Scrollable content
local scroll = Instance.new("ScrollingFrame")
scroll.Name = "Options"
scroll.Position = UDim2.new(0, 8, 0, 74)
scroll.Size = UDim2.new(1, -16, 1, -116)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 5
scroll.ScrollBarImageColor3 = purple
scroll.ScrollingDirection = Enum.ScrollingDirection.Y
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.Active = true
scroll.Parent = panel

local list = Instance.new("UIListLayout")
list.Padding = UDim.new(0, 7)
list.SortOrder = Enum.SortOrder.LayoutOrder
list.Parent = scroll

local padding = Instance.new("UIPadding")
padding.PaddingLeft = UDim.new(0, 2)
padding.PaddingRight = UDim.new(0, 4)
padding.PaddingBottom = UDim.new(0, 10)
padding.Parent = scroll

-- Status bar
local status = Instance.new("TextLabel")
status.Position = UDim2.new(0, 10, 1, -34)
status.Size = UDim2.new(1, -20, 0, 25)
status.BackgroundTransparency = 1
status.Text = "● FTT is ready"
status.TextColor3 = green
status.TextSize = 12
status.Font = Enum.Font.GothamBold
status.TextTruncate = Enum.TextTruncate.AtEnd
status.Parent = panel

local function setStatus(text, color)
    status.Text = tostring(text)
    status.TextColor3 = color or white
end

local function section(text)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -2, 0, 27)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(200, 160, 255)
    label.TextSize = 13
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = scroll
    return label
end

local function makeButton(text, callback, color)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -2, 0, 38)
    b.BackgroundColor3 = color or card
    b.BorderSizePixel = 0
    b.Text = text
    b.TextColor3 = white
    b.TextSize = 13
    b.TextWrapped = true
    b.Font = Enum.Font.GothamBold
    b.AutoButtonColor = true
    b.Parent = scroll
    round(b, 10)
    outline(b, purple, 1)
    b.Activated:Connect(callback)
    return b
end

local function makeNumberBox(title, value, placeholder)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -2, 0, 42)
    row.BackgroundColor3 = card
    row.BorderSizePixel = 0
    row.Parent = scroll
    round(row, 9)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.57, -8, 1, 0)
    label.Position = UDim2.fromOffset(10, 0)
    label.BackgroundTransparency = 1
    label.Text = title
    label.TextColor3 = white
    label.TextSize = 12
    label.TextWrapped = true
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = row

    local box = Instance.new("TextBox")
    box.Size = UDim2.new(0.35, 0, 0, 30)
    box.Position = UDim2.new(0.62, 0, 0.5, -15)
    box.BackgroundColor3 = dark
    box.BorderSizePixel = 0
    box.TextColor3 = white
    box.PlaceholderColor3 = muted
    box.PlaceholderText = placeholder or "Number"
    box.Text = tostring(value)
    box.TextSize = 14
    box.Font = Enum.Font.GothamBold
    box.ClearTextOnFocus = false
    box.Parent = row
    round(box, 7)
    outline(box, purple, 1)

    return box
end

local speedBox = makeNumberBox("Movement speed (8–500)", 16)
local jumpBox = makeNumberBox("Jump power (25–100)", 50)

local function getHumanoid()
    local character = player.Character
    return character and character:FindFirstChildOfClass("Humanoid")
end

-- Apply speed and jump
section("MOVEMENT SETTINGS")

makeButton("✦ APPLY SPEED + JUMP", function()
    local s = tonumber(speedBox.Text)
    local j = tonumber(jumpBox.Text)

    if not s or not j
        or s ~= s or j ~= j
        or math.abs(s) == math.huge
        or math.abs(j) == math.huge then
        setStatus("Enter valid numbers", Color3.fromRGB(255, 190, 110))
        return
    end

    s = math.clamp(s, 8, 500)
    j = math.clamp(j, 25, 100)

    local humanoid = getHumanoid()
    if not humanoid or humanoid.Health <= 0 then
        setStatus("Character is not ready", Color3.fromRGB(255, 190, 110))
        return
    end

    speedBox.Text = tostring(s)
    jumpBox.Text = tostring(j)

    humanoid.WalkSpeed = s
    humanoid.UseJumpPower = true
    humanoid.JumpPower = j

    setStatus("✓ Speed " .. s .. " | Jump " .. j, green)
end, Color3.fromRGB(91, 56, 145))

makeButton("↺ RESET SPEED + JUMP", function()
    local humanoid = getHumanoid()
    if not humanoid then
        setStatus("Character is not ready")
        return
    end

    speedBox.Text = "16"
    jumpBox.Text = "50"

    humanoid.WalkSpeed = 16
    humanoid.UseJumpPower = true
    humanoid.JumpPower = 50

    setStatus("✓ Default movement restored", green)
end)

-- Checkpoint information
section("CHECKPOINTS")

makeButton("🏁 SHOW CURRENT STAGE", function()
    local stats = player:FindFirstChild("leaderstats")
    local stage = stats and (
        stats:FindFirstChild("Stage")
        or stats:FindFirstChild("Checkpoint")
        or stats:FindFirstChild("مرحله")
    )

    if stage then
        setStatus("Stage: " .. tostring(stage.Value))
    else
        setStatus("Stage information not found", muted)
    end
end)

makeButton("📍 FIND NEAREST CHECKPOINT", function()
    local folder = workspace:FindFirstChild("Checkpoints")
    local character = player.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")

    if not folder or not root then
        setStatus("Checkpoints or character unavailable")
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
        setStatus(nearest.Name .. " | " .. math.floor(bestDistance) .. " studs")
    else
        setStatus("No checkpoint found")
    end
end)

-- Destinations defined in your own map
section("MAP DESTINATIONS")

local destinationFolder = workspace:FindFirstChild("FTT_Destinations")

if destinationFolder then
    local function addDestination(item)
        if not item:IsA("BasePart") then return end

        makeButton("➡ TELEPORT: " .. item.Name, function()
            local character = player.Character
            local humanoid = getHumanoid()
            local root = character and character:FindFirstChild("HumanoidRootPart")

            -- Intended for testing in your own Roblox Studio experience.
            if not character or not humanoid or not root or humanoid.Health <= 0 then
                setStatus("Character is not ready")
                return
            end

            if not item:IsDescendantOf(destinationFolder) then
                setStatus("Destination is no longer available")
                return
            end

            character:PivotTo(item.CFrame * CFrame.new(0, item.Size.Y / 2 + 4, 0))
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
            setStatus("Moved to " .. item.Name, green)
        end)
    end

    for _, item in ipairs(destinationFolder:GetChildren()) do
        addDestination(item)
    end

    destinationFolder.ChildAdded:Connect(function(item)
        task.defer(addDestination, item)
    end)
else
    makeButton("Create Workspace/FTT_Destinations", function()
        setStatus("Add a folder and destination Parts in Studio", muted)
    end)
end

-- Reopen button
local hideButton = makeButton("✕ HIDE PANEL", function() end,
    Color3.fromRGB(72, 39, 76))

local reopen = Instance.new("TextButton")
reopen.Name = "FTT_Reopen"
reopen.Size = UDim2.fromOffset(58, 54)
reopen.Position = UDim2.new(0, 12, 0.55, 0)
reopen.BackgroundColor3 = Color3.fromRGB(91, 56, 145)
reopen.BorderSizePixel = 0
reopen.Text = "FTT\n♡"
reopen.TextColor3 = white
reopen.TextSize = 14
reopen.Font = Enum.Font.GothamBold
reopen.Visible = false
reopen.Parent = gui
round(reopen, 14)
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
        setStatus("● Character ready", green)
    end
end)

print("FTT Mobile Control Panel loaded")

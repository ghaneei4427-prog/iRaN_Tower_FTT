-- FTT Mobile Training Panel
-- Roblox Studio test use
-- Put this LocalScript in StarterPlayer > StarterPlayerScripts

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local old = playerGui:FindFirstChild("FTT_TrainingPanel")
if old then old:Destroy() end

local PURPLE = Color3.fromRGB(151, 90, 255)
local DARK = Color3.fromRGB(23, 21, 37)
local CARD = Color3.fromRGB(42, 37, 59)
local WHITE = Color3.fromRGB(250, 247, 255)
local GREEN = Color3.fromRGB(125, 255, 180)

local gui = Instance.new("ScreenGui")
gui.Name = "FTT_TrainingPanel"
gui.ResetOnSpawn = false
gui.Parent = playerGui

local panel = Instance.new("Frame")
panel.Size = UDim2.new(0, 290, 0, 440)
panel.Position = UDim2.new(0, 12, 0.5, -220)
panel.BackgroundColor3 = DARK
panel.BorderSizePixel = 0
panel.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 16)
corner.Parent = panel

local stroke = Instance.new("UIStroke")
stroke.Color = PURPLE
stroke.Thickness = 2
stroke.Parent = panel

local header = Instance.new("TextLabel")
header.Size = UDim2.new(1, -16, 0, 42)
header.Position = UDim2.fromOffset(8, 4)
header.BackgroundTransparency = 1
header.Text = "FTT • MOBILE TRAINING"
header.TextColor3 = WHITE
header.Font = Enum.Font.GothamBold
header.TextSize = 16
header.Parent = panel

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -20, 0, 34)
status.Position = UDim2.fromOffset(10, 45)
status.BackgroundTransparency = 1
status.Text = "Panel ready"
status.TextColor3 = GREEN
status.TextWrapped = true
status.Font = Enum.Font.Gotham
status.TextSize = 12
status.Parent = panel

local list = Instance.new("ScrollingFrame")
list.Size = UDim2.new(1, -16, 1, -90)
list.Position = UDim2.fromOffset(8, 82)
list.BackgroundTransparency = 1
list.BorderSizePixel = 0
list.ScrollBarThickness = 5
list.AutomaticCanvasSize = Enum.AutomaticSize.Y
list.CanvasSize = UDim2.new()
list.Parent = panel

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 7)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = list

local function getCharacter()
    return player.Character
end

local function getHumanoid()
    local character = getCharacter()
    return character and character:FindFirstChildOfClass("Humanoid")
end

local function getRoot()
    local character = getCharacter()
    return character and character:FindFirstChild("HumanoidRootPart")
end

local function say(message, color)
    status.Text = message
    status.TextColor3 = color or WHITE
end

local function makeButton(text, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -4, 0, 36)
    button.BackgroundColor3 = CARD
    button.BorderSizePixel = 0
    button.Text = text
    button.TextColor3 = WHITE
    button.TextSize = 13
    button.TextWrapped = true
    button.Font = Enum.Font.GothamBold
    button.Parent = list

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 9)
    c.Parent = button

    button.Activated:Connect(callback)
    return button
end

local function makeInput(title, defaultValue)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -4, 0, 38)
    row.BackgroundTransparency = 1
    row.Parent = list

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.58, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = title
    label.TextColor3 = WHITE
    label.TextSize = 12
    label.Font = Enum.Font.GothamBold
    label.Parent = row

    local box = Instance.new("TextBox")
    box.Size = UDim2.new(0.38, 0, 1, 0)
    box.Position = UDim2.new(0.61, 0, 0, 0)
    box.BackgroundColor3 = CARD
    box.TextColor3 = WHITE
    box.Text = tostring(defaultValue)
    box.TextSize = 14
    box.Font = Enum.Font.GothamBold
    box.ClearTextOnFocus = false
    box.Parent = row

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = box

    return box
end

local speedBox = makeInput("Speed (8–100)", 16)
local jumpBox = makeInput("Jump power (25–150)", 50)

makeButton("Apply Speed + Jump", function()
    local humanoid = getHumanoid()
    local speed = tonumber(speedBox.Text)
    local jump = tonumber(jumpBox.Text)

    if not humanoid or not speed or not jump then
        say("Enter valid numbers first")
        return
    end

    humanoid.WalkSpeed = math.clamp(speed, 8, 100)
    humanoid.UseJumpPower = true
    humanoid.JumpPower = math.clamp(jump, 25, 150)
    say("Speed and jump applied", GREEN)
end)

makeButton("Reset Movement", function()
    local humanoid = getHumanoid()
    if humanoid then
        humanoid.WalkSpeed = 16
        humanoid.UseJumpPower = true
        humanoid.JumpPower = 50
        say("Movement reset", GREEN)
    end
end)

makeButton("Show Current Stage", function()
    local stats = player:FindFirstChild("leaderstats")
    local stage = stats and (
        stats:FindFirstChild("Stage")
        or stats:FindFirstChild("Checkpoint")
        or stats:FindFirstChild("مرحله")
    )

    if stage then
        say("Stage: " .. tostring(stage.Value))
    else
        say("Stage value not found")
    end
end)

local function findFolder(names)
    for _, name in ipairs(names) do
        local folder = workspace:FindFirstChild(name)
        if folder then return folder end
    end
end

makeButton("Teleport to Nearest Checkpoint", function()
    local root = getRoot()
    local folder = findFolder({"Checkpoints", "CheckpointsFolder"})

    if not root or not folder then
        say("Checkpoint folder not found")
        return
    end

    local nearest
    local bestDistance = math.huge

    for _, item in ipairs(folder:GetDescendants()) do
        if item:IsA("BasePart") then
            local distance = (root.Position - item.Position).Magnitude
            if distance < bestDistance then
                nearest = item
                bestDistance = distance
            end
        end
    end

    if nearest then
        root.CFrame = nearest.CFrame + Vector3.new(0, 4, 0)
        say("Teleported to " .. nearest.Name, GREEN)
    else
        say("No checkpoint parts found")
    end
end)

makeButton("Teleport to Finish / Win (Studio test)", function()
    local root = getRoot()
    if not root then
        say("Character not ready")
        return
    end

    local target =
        workspace:FindFirstChild("Finish", true)
        or workspace:FindFirstChild("Win", true)

    if target and target:IsA("BasePart") then
        root.CFrame = target.CFrame + Vector3.new(0, 4, 0)
        say("Teleported to " .. target.Name, GREEN)
    else
        say("Add a BasePart named Finish or Win in Studio")
    end
end)

local flying = false
local flyConnection
local flySpeed = 45

makeButton("Toggle Fly", function()
    local root = getRoot()
    local humanoid = getHumanoid()

    if not root or not humanoid then
        say("Character not ready")
        return
    end

    flying = not flying

    if flying then
        local attachment = Instance.new("Attachment")
        attachment.Name = "FTTFlyAttachment"
        attachment.Parent = root

        local velocity = Instance.new("LinearVelocity")
        velocity.Name = "FTTFlyVelocity"
        velocity.Attachment0 = attachment
        velocity.MaxForce = 100000
        velocity.VectorVelocity = Vector3.zero
        velocity.RelativeTo = Enum.ActuatorRelativeTo.World
        velocity.Parent = root

        humanoid.PlatformStand = true

        flyConnection = RunService.RenderStepped:Connect(function()
            if not flying or not root.Parent then return end

            local camera = workspace.CurrentCamera
            if not camera then return end

            local direction = Vector3.zero

            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                direction += camera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                direction -= camera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                direction -= camera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                direction += camera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                direction += Vector3.yAxis
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                direction -= Vector3.yAxis
            end

            velocity.VectorVelocity =
                direction.Magnitude > 0
                and direction.Unit * flySpeed
                or Vector3.zero
        end)

        say("Fly ON — WASD + Space/Ctrl", GREEN)
    else
        if flyConnection then
            flyConnection:Disconnect()
            flyConnection = nil
        end

        local attachment = root:FindFirstChild("FTTFlyAttachment")
        local velocity = root:FindFirstChild("FTTFlyVelocity")
        if velocity then velocity:Destroy() end
        if attachment then attachment:Destroy() end

        humanoid.PlatformStand = false
        say("Fly OFF", GREEN)
    end
end)

local noclip = false
local noclipConnection

makeButton("Toggle Noclip (Studio test)", function()
    noclip = not noclip

    if noclip then
        noclipConnection = RunService.Stepped:Connect(function()
            local character = getCharacter()
            if not character then return end

            for _, part in ipairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end)

        say("Noclip ON", GREEN)
    else
        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
        end

        local character = getCharacter()
        if character then
            for _, part in ipairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end

        say("Noclip OFF", GREEN)
    end
end)

makeButton("Stop Fly + Noclip", function()
    flying = false
    noclip = false

    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end
    if noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
    end

    local character = getCharacter()
    local humanoid = getHumanoid()
    local root = getRoot()

    if root then
        local velocity = root:FindFirstChild("FTTFlyVelocity")
        local attachment = root:FindFirstChild("FTTFlyAttachment")
        if velocity then velocity:Destroy() end
        if attachment then attachment:Destroy() end
    end

    if humanoid then
        humanoid.PlatformStand = false
    end

    if character then
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end

    say("Fly and noclip stopped", GREEN)
end)

makeButton("Hide Panel", function()
    panel.Visible = false
    reopen.Visible = true
end)

local reopen = Instance.new("TextButton")
reopen.Name = "FTT_Reopen"
reopen.Size = UDim2.fromOffset(54, 54)
reopen.Position = UDim2.new(1, -68, 0.55, 0)
reopen.BackgroundColor3 = PURPLE
reopen.Text = "FTT"
reopen.TextColor3 = WHITE
reopen.TextSize = 14
reopen.Font = Enum.Font.GothamBold
reopen.Visible = false
reopen.Parent = gui

local reopenCorner = Instance.new("UICorner")
reopenCorner.CornerRadius = UDim.new(0, 15)
reopenCorner.Parent = reopen

reopen.Activated:Connect(function()
    panel.Visible = true
    reopen.Visible = false
end)

player.CharacterAdded:Connect(function()
    task.wait(1)
    say("Character ready", GREEN)
end)

print("FTT Mobile Training Panel loaded")

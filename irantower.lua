
-- FTT_Server
-- Place inside ServerScriptService

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local remotes = ReplicatedStorage:FindFirstChild("FTT_Remotes")
if not remotes then
    remotes = Instance.new("Folder")
    remotes.Name = "FTT_Remotes"
    remotes.Parent = ReplicatedStorage
end

local actionRemote = remotes:FindFirstChild("FTT_Action")
if not actionRemote then
    actionRemote = Instance.new("RemoteFunction")
    actionRemote.Name = "FTT_Action"
    actionRemote.Parent = remotes
end

local checkpointsFolder = workspace:WaitForChild("Checkpoints")
local destinationsFolder = workspace:WaitForChild("FTT_Destinations")

-- FTT MOVEMENT SETTINGS
local DEFAULT_SPEED = 16
local MIN_SPEED = 8
local MAX_SPEED = 500 -- Increased from 32 to 500

local DEFAULT_JUMP = 50
local MIN_JUMP = 25
local MAX_JUMP = 90

local REQUEST_COOLDOWN = 0.35
local TELEPORT_COOLDOWN = 2

local playerCheckpoints = {}
local lastRequest = {}
local lastTeleport = {}

local function getCharacter(player)
    local character = player.Character
    if not character then return nil end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local root = character:FindFirstChild("HumanoidRootPart")

    if not humanoid or not root or humanoid.Health <= 0 then
        return nil
    end

    return character, humanoid, root
end

local function getNumber(value, minValue, maxValue)
    if typeof(value) ~= "number" then return nil end
    if value ~= value or value == math.huge or value == -math.huge then
        return nil
    end

    return math.clamp(value, minValue, maxValue)
end

local function isValidPart(instance, folder)
    return typeof(instance) == "Instance"
        and instance:IsA("BasePart")
        and instance:IsDescendantOf(folder)
end

local function teleportCharacter(player, target)
    local character, humanoid, root = getCharacter(player)
    if not character or not target then
        return false, "شخصیت آماده نیست."
    end

    character:PivotTo(
        target.CFrame * CFrame.new(0, target.Size.Y / 2 + 4, 0)
    )

    root.AssemblyLinearVelocity = Vector3.zero
    root.AssemblyAngularVelocity = Vector3.zero

    return true, "تلپورت انجام شد."
end

local function setupPlayer(player)
    player.CharacterAdded:Connect(function(character)
        local humanoid = character:WaitForChild("Humanoid", 10)
        if not humanoid then return end

        humanoid.UseJumpPower = true
        humanoid.WalkSpeed = DEFAULT_SPEED
        humanoid.JumpPower = DEFAULT_JUMP

        local checkpoint = playerCheckpoints[player]
        if checkpoint and checkpoint.Parent then
            task.wait(0.15)

            if character.Parent and humanoid.Health > 0 then
                character:PivotTo(
                    checkpoint.CFrame
                    * CFrame.new(0, checkpoint.Size.Y / 2 + 4, 0)
                )
            end
        end
    end)
end

local function connectCheckpoint(part)
    if not part:IsA("BasePart") then return end

    part.Touched:Connect(function(hit)
        local character = hit:FindFirstAncestorOfClass("Model")
        if not character then return end

        local player = Players:GetPlayerFromCharacter(character)
        if not player then return end

        local currentCharacter = getCharacter(player)
        if currentCharacter then
            playerCheckpoints[player] = part
        end
    end)
end

for _, part in ipairs(checkpointsFolder:GetChildren()) do
    connectCheckpoint(part)
end

checkpointsFolder.ChildAdded:Connect(connectCheckpoint)

Players.PlayerAdded:Connect(setupPlayer)

for _, player in ipairs(Players:GetPlayers()) do
    setupPlayer(player)
end

Players.PlayerRemoving:Connect(function(player)
    playerCheckpoints[player] = nil
    lastRequest[player] = nil
    lastTeleport[player] = nil
end)

actionRemote.OnServerInvoke = function(player, action, data)
    if typeof(action) ~= "string" then
        return false, "درخواست نامعتبر است."
    end

    local now = os.clock()

    if lastRequest[player]
        and now - lastRequest[player] < REQUEST_COOLDOWN then
        return false, "کمی صبر کن."
    end

    lastRequest[player] = now

    local character, humanoid = getCharacter(player)
    if not character then
        return false, "شخصیت آماده نیست."
    end

    if action == "SetMovement" then
        if typeof(data) ~= "table" then
            return false, "داده نامعتبر است."
        end

        local speed = getNumber(data.speed, MIN_SPEED, MAX_SPEED)
        local jump = getNumber(data.jump, MIN_JUMP, MAX_JUMP)

        if not speed or not jump then
            return false, "مقدار سرعت یا پرش نامعتبر است."
        end

        humanoid.UseJumpPower = true
        humanoid.WalkSpeed = speed
        humanoid.JumpPower = jump

        return true, ("سرعت: %d | پرش: %d"):format(speed, jump)

    elseif action == "ResetMovement" then
        humanoid.UseJumpPower = true
        humanoid.WalkSpeed = DEFAULT_SPEED
        humanoid.JumpPower = DEFAULT_JUMP

        return true, "سرعت و پرش پیش‌فرض شد."

    elseif action == "ReturnCheckpoint" then
        local checkpoint = playerCheckpoints[player]

        if not isValidPart(checkpoint, checkpointsFolder) then
            return false, "هنوز چک‌پوینتی ثبت نکرده‌ای."
        end

        if lastTeleport[player]
            and now - lastTeleport[player] < TELEPORT_COOLDOWN then
            return false, "برای تلپورت کمی صبر کن."
        end

        lastTeleport[player] = now
        return teleportCharacter(player, checkpoint)

    elseif action == "TeleportDestination" then
        if typeof(data) ~= "string" or #data > 80 then
            return false, "نام مقصد نامعتبر است."
        end

        local target = destinationsFolder:FindFirstChild(data)

        if not isValidPart(target, destinationsFolder) then
            return false, "مقصد مجاز نیست."
        end

        if lastTeleport[player]
            and now - lastTeleport[player] < TELEPORT_COOLDOWN then
            return false, "برای تلپورت کمی صبر کن."
        end

        lastTeleport[player] = now
        return teleportCharacter(player, target)
    end

    return false, "دستور ناشناخته است."
end

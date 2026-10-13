
-- AM1R • Movement Settings
-- For your own Roblox Studio experience

local TARGET_SPEED = 300
local TARGET_JUMP = 200

local function applyMovement()
    local character = player.Character
    local humanoid = character
        and character:FindFirstChildOfClass("Humanoid")

    if not humanoid then
        setStatus("در انتظار آماده‌شدن کاراکتر...", MUTED)
        return
    end

    humanoid.WalkSpeed = TARGET_SPEED
    humanoid.UseJumpPower = true
    humanoid.JumpPower = TARGET_JUMP

    setStatus("⚡ Speed: 300 | Jump: 200")
end

local movementButton = makeButton("⚡ اعمال Speed 300 / Jump 200", 7)

movementButton.Activated:Connect(applyMovement)

player.CharacterAdded:Connect(function()
    task.wait(1)
    applyMovement()
end)

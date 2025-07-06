-- Luau Script cho Roblox Studio
-- Tự động thu thập tiền, tự đóng cửa base, tự nhặt Brainrot

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

local leaderstats = player:WaitForChild("leaderstats")
local money = leaderstats:WaitForChild("Money")

-- 🚀 AUTO COLLECT MONEY
local function autoCollectMoney()
    for _, cash in pairs(workspace:WaitForChild("CashPads"):GetChildren()) do
        if (cash.Position - hrp.Position).Magnitude < 10 then
            -- giả lập thu tiền
            money.Value += 5
            cash:Destroy()
        end
    end
end

-- 🧠 AUTO COLLECT BRAINROT
local function findClosestBrainrot()
    local minDist = math.huge
    local closest = nil
    for _, brainrot in pairs(workspace:WaitForChild("Brainrots"):GetChildren()) do
        local dist = (brainrot.Position - hrp.Position).Magnitude
        if dist < minDist then
            minDist = dist
            closest = brainrot
        end
    end
    return closest
end

local function autoCollectBrainrot()
    local target = findClosestBrainrot()
    if target then
        local humanoid = character:WaitForChild("Humanoid")
        humanoid:MoveTo(target.Position)
        humanoid.MoveToFinished:Wait()
        -- thu thập
        money.Value += 20
        target:Destroy()
    end
end

-- 🚪 AUTO CLOSE DOOR IF ENEMY NEAR BASE
local function autoCloseDoor()
    for _, base in pairs(workspace:WaitForChild("Bases"):GetChildren()) do
        local door = base:FindFirstChild("Door")
        if door then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local dist = (p.Character.HumanoidRootPart.Position - base.Position).Magnitude
                    if dist < 20 then
                        -- đóng cửa (ví dụ đổi Transparency và CanCollide)
                        door.Transparency = 0
                        door.CanCollide = true
                        return
                    end
                end
            end
            -- không ai gần thì mở cửa
            door.Transparency = 0.5
            door.CanCollide = false
        end
    end
end

-- 🔄 CHU KỲ
RunService.Heartbeat:Connect(function()
    autoCollectMoney()
    autoCloseDoor()
end)

while task.wait(1.5) do
    autoCollectBrainrot()
end

-- Tên script: PrivateServerRejoin
-- Mục đích: Tạo UI để người dùng nhập mã server và tự động kết nối lại sau khoảng thời gian tùy chỉnh.

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")

local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui")
local frame = Instance.new("Frame")
local title = Instance.new("TextLabel")
local serverCodeTextbox = Instance.new("TextBox")
local delayTextbox = Instance.new("TextBox")
local startButton = Instance.new("TextButton")
local statusLabel = Instance.new("TextLabel")

local serverCode = "18c2cdfe247bb04b8f1dd54641c95973" -- Mã server mặc định
local rejoinDelay = 60 -- Thời gian chờ mặc định (giây)
local isRejoining = false
local currentRejoinCoroutine = nil

-- Cài đặt thuộc tính cho GUI
gui.Name = "PrivateServerRejoinUI"
gui.Parent = player:WaitForChild("PlayerGui")

-- Cài đặt thuộc tính cho Frame (khung chứa)
frame.Size = UDim2.new(0, 300, 0, 200)
frame.Position = UDim2.new(0.5, -150, 0.5, -100)
frame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
frame.BorderColor3 = Color3.new(0, 0.7, 1)
frame.BorderSizePixel = 2
frame.Active = true
frame.Draggable = true
frame.Parent = gui

-- Cài đặt thuộc tính cho Tiêu đề
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.new(0, 0.7, 1)
title.TextColor3 = Color3.new(1, 1, 1)
title.Text = "Private Server Rejoin"
title.Font = Enum.Font.SourceSansBold
title.TextScaled = true
title.Parent = frame

-- Cài đặt thuộc tính cho TextBox nhập Mã Server
serverCodeTextbox.Size = UDim2.new(0.8, 0, 0, 30)
serverCodeTextbox.Position = UDim2.new(0.1, 0, 0.25, 0)
serverCodeTextbox.PlaceholderText = "Dán mã server ở đây..."
serverCodeTextbox.Text = serverCode
serverCodeTextbox.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
serverCodeTextbox.TextColor3 = Color3.new(1, 1, 1)
serverCodeTextbox.Font = Enum.Font.SourceSans
serverCodeTextbox.TextScaled = true
serverCodeTextbox.Parent = frame
serverCodeTextbox.TextEdited:Connect(function()
    serverCode = serverCodeTextbox.Text
end)

-- Cài đặt thuộc tính cho TextBox nhập Thời gian
delayTextbox.Size = UDim2.new(0.8, 0, 0, 30)
delayTextbox.Position = UDim2.new(0.1, 0, 0.45, 0)
delayTextbox.PlaceholderText = "Thời gian chờ (giây)..."
delayTextbox.Text = tostring(rejoinDelay)
delayTextbox.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
delayTextbox.TextColor3 = Color3.new(1, 1, 1)
delayTextbox.Font = Enum.Font.SourceSans
delayTextbox.TextScaled = true
delayTextbox.Parent = frame
delayTextbox.TextEdited:Connect(function()
    local number = tonumber(delayTextbox.Text)
    if number and number >= 1 then
        rejoinDelay = number
    else
        rejoinDelay = 60
        delayTextbox.Text = "60"
    end
end)

-- Cài đặt thuộc tính cho nút Bắt đầu/Dừng
startButton.Size = UDim2.new(0.6, 0, 0, 40)
startButton.Position = UDim2.new(0.2, 0, 0.65, 0)
startButton.BackgroundColor3 = Color3.new(0.2, 0.8, 0.2)
startButton.Text = "Bắt đầu Rejoin"
startButton.Font = Enum.Font.SourceSansBold
startButton.TextScaled = true
startButton.Parent = frame

-- Cài đặt thuộc tính cho nhãn trạng thái
statusLabel.Size = UDim2.new(1, 0, 0, 20)
statusLabel.Position = UDim2.new(0, 0, 0.85, 0)
statusLabel.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
statusLabel.TextColor3 = Color3.new(1, 1, 1)
statusLabel.Text = "Trạng thái: Đã Dừng"
statusLabel.Font = Enum.Font.SourceSans
statusLabel.TextScaled = true
statusLabel.Parent = frame

-- Hàm xử lý logic rejoin
local function startRejoinLoop()
    if isRejoining then return end

    isRejoining = true
    startButton.Text = "Đang Rejoin..."
    startButton.BackgroundColor3 = Color3.new(0.8, 0.2, 0.2)

    currentRejoinCoroutine = coroutine.wrap(function()
        local timeLeft = rejoinDelay
        while isRejoining do
            timeLeft = rejoinDelay
            statusLabel.Text = "Rejoin trong: " .. timeLeft .. "s"
            
            while timeLeft > 0 and isRejoining do
                task.wait(1)
                timeLeft = timeLeft - 1
                statusLabel.Text = "Rejoin trong: " .. timeLeft .. "s"
            end
            
            if isRejoining then
                local gameId = game.PlaceId
                local success, err = pcall(function()
                    -- Sử dụng TeleportToPrivateServer thay vì TeleportToPlaceInstance
                    TeleportService:TeleportToPrivateServer(gameId, serverCode, {player})
                end)
                
                if not success then
                    warn("Không thể kết nối lại: " .. err)
                    isRejoining = false
                    startButton.Text = "Bắt đầu Rejoin"
                    startButton.BackgroundColor3 = Color3.new(0.2, 0.8, 0.2)
                    statusLabel.Text = "Trạng thái: Lỗi"
                end
            end
        end
    end)()
end

-- Hàm dừng logic rejoin
local function stopRejoinLoop()
    isRejoining = false
    startButton.Text = "Bắt đầu Rejoin"
    startButton.BackgroundColor3 = Color3.new(0.2, 0.8, 0.2)
    statusLabel.Text = "Trạng thái: Đã Dừng"
end

-- Kết nối sự kiện nhấp chuột
startButton.MouseButton1Click:Connect(function()
    if isRejoining then
        stopRejoinLoop()
    else
        startRejoinLoop()
    end
end)

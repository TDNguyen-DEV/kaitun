-- Tên script: TimedRejoin
-- Mục đích: Tạo UI để người dùng tùy chỉnh thời gian rejoin và tự động kết nối lại sau khoảng thời gian đó.

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")

local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui")
local frame = Instance.new("Frame")
local title = Instance.new("TextLabel")
local textbox = Instance.new("TextBox")
local startButton = Instance.new("TextButton")
local statusLabel = Instance.new("TextLabel")

local rejoinDelay = 60 -- Mặc định là 60 giây
local isRejoining = false
local currentRejoinCoroutine = nil

-- Cài đặt thuộc tính cho GUI
gui.Name = "TimedRejoinUI"
gui.Parent = player:WaitForChild("PlayerGui")

-- Cài đặt thuộc tính cho Frame (khung chứa)
frame.Size = UDim2.new(0, 250, 0, 150)
frame.Position = UDim2.new(0.5, -125, 0.5, -75)
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
title.Text = "Timed Rejoin"
title.Font = Enum.Font.SourceSansBold
title.TextScaled = true
title.Parent = frame

-- Cài đặt thuộc tính cho TextBox (hộp nhập liệu)
textbox.Size = UDim2.new(0.8, 0, 0, 30)
textbox.Position = UDim2.new(0.1, 0, 0.3, 0)
textbox.PlaceholderText = "Thời gian (giây)"
textbox.Text = tostring(rejoinDelay)
textbox.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
textbox.TextColor3 = Color3.new(1, 1, 1)
textbox.Font = Enum.Font.SourceSans
textbox.TextScaled = true
textbox.Parent = frame
textbox.TextEdited:Connect(function()
    local number = tonumber(textbox.Text)
    if number and number >= 1 then
        rejoinDelay = number
    else
        rejoinDelay = 60
        textbox.Text = "60"
    end
end)

-- Cài đặt thuộc tính cho nút Bắt đầu/Dừng
startButton.Size = UDim2.new(0.6, 0, 0, 40)
startButton.Position = UDim2.new(0.2, 0, 0.55, 0)
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
                local jobId = game.JobId
                
                local success, err = pcall(function()
                    TeleportService:TeleportToPlaceInstance(gameId, jobId, player)
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

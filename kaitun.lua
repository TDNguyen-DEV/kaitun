-- Tên script: RejoinUIController
-- Mục đích: Tạo UI để người dùng tùy chỉnh thời gian rejoin và bật/tắt chức năng.

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui")
local frame = Instance.new("Frame")
local title = Instance.new("TextLabel")
local textbox = Instance.new("TextBox")
local toggleButton = Instance.new("TextButton")
local statusLabel = Instance.new("TextLabel")

local REJOIN_ENABLED = false
local rejoinDelay = 5

-- Cài đặt thuộc tính cho GUI
gui.Name = "RejoinUI"
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
title.Text = "Auto Rejoin"
title.Font = Enum.Font.SourceSansBold
title.TextScaled = true
title.Parent = frame

-- Cài đặt thuộc tính cho TextBox (hộp nhập liệu)
textbox.Size = UDim2.new(0.8, 0, 0, 30)
textbox.Position = UDim2.new(0.1, 0, 0.3, 0)
textbox.PlaceholderText = "Nhập thời gian chờ (giây)..."
textbox.Text = tostring(rejoinDelay)
textbox.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
textbox.TextColor3 = Color3.new(1, 1, 1)
textbox.Font = Enum.Font.SourceSans
textbox.TextScaled = true
textbox.Parent = frame
textbox.TextEdited:Connect(function()
    local number = tonumber(textbox.Text)
    if number and number > 0 then
        rejoinDelay = number
    else
        rejoinDelay = 5
        textbox.Text = "5"
    end
end)

-- Cài đặt thuộc tính cho nút Bật/Tắt
toggleButton.Size = UDim2.new(0.6, 0, 0, 40)
toggleButton.Position = UDim2.new(0.2, 0, 0.55, 0)
toggleButton.BackgroundColor3 = Color3.new(0.2, 0.8, 0.2)
toggleButton.Text = "Bật Rejoin"
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.TextScaled = true
toggleButton.Parent = frame

-- Cài đặt thuộc tính cho nhãn trạng thái
statusLabel.Size = UDim2.new(1, 0, 0, 20)
statusLabel.Position = UDim2.new(0, 0, 0.85, 0)
statusLabel.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
statusLabel.TextColor3 = Color3.new(1, 1, 1)
statusLabel.Text = "Trạng thái: Đã Tắt"
statusLabel.Font = Enum.Font.SourceSans
statusLabel.TextScaled = true
statusLabel.Parent = frame

-- Hàm để bật/tắt chức năng
local function toggleRejoin()
    REJOIN_ENABLED = not REJOIN_ENABLED
    if REJOIN_ENABLED then
        toggleButton.BackgroundColor3 = Color3.new(0.8, 0.2, 0.2)
        toggleButton.Text = "Tắt Rejoin"
        statusLabel.Text = "Trạng thái: Đã Bật"
    else
        toggleButton.BackgroundColor3 = Color3.new(0.2, 0.8, 0.2)
        toggleButton.Text = "Bật Rejoin"
        statusLabel.Text = "Trạng thái: Đã Tắt"
    end
end

toggleButton.MouseButton1Click:Connect(toggleRejoin)

-- Chức năng Rejoin chính
local function handleRejoin()
    if REJOIN_ENABLED then
        print("Đang chờ " .. rejoinDelay .. " giây trước khi thử kết nối lại...")
        task.wait(rejoinDelay)
        
        local gameId = game.PlaceId
        local jobId = game.JobId
        
        local success, err = pcall(function()
            TeleportService:TeleportToPlaceInstance(gameId, jobId, player)
        end)
        
        if success then
            print("Đang kết nối lại...")
        else
            warn("Không thể kết nối lại: " .. err)
        end
    end
end

-- Lắng nghe sự kiện khi người chơi rời đi
player.PlayerRemoving:Connect(handleRejoin)

-- Giấu con trỏ chuột khi chơi game
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightControl then
        gui.Enabled = not gui.Enabled
    end
end)

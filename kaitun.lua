-- Tên script: RejoinCurrentServer
-- Mục đích: Tạo một nút bấm để người chơi có thể rejoin ngay lập tức vào máy chủ hiện tại.

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")

local player = Players.LocalPlayer

-- Tạo giao diện UI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "RejoinUI"
screenGui.Parent = player:WaitForChild("PlayerGui")

local rejoinButton = Instance.new("TextButton")
rejoinButton.Size = UDim2.new(0, 150, 0, 50)
rejoinButton.Position = UDim2.new(0.5, -75, 0.9, 0) -- Vị trí ở dưới cùng, giữa màn hình
rejoinButton.BackgroundColor3 = Color3.new(0.2, 0.8, 0.2)
rejoinButton.Text = "Rejoin Server"
rejoinButton.Font = Enum.Font.SourceSansBold
rejoinButton.TextColor3 = Color3.new(1, 1, 1)
rejoinButton.TextScaled = true
rejoinButton.Parent = screenGui

-- Lắng nghe sự kiện khi nhấp chuột vào nút
rejoinButton.MouseButton1Click:Connect(function()
    local gameId = game.PlaceId
    local jobId = game.JobId
    
    print("Đang cố gắng kết nối lại vào máy chủ hiện tại...")
    
    -- Sử dụng pcall để xử lý lỗi nếu việc teleport thất bại
    local success, err = pcall(function()
        TeleportService:TeleportToPlaceInstance(gameId, jobId, player)
    end)
    
    if success then
        print("Đang kết nối lại...")
    else
        warn("Không thể kết nối lại: " .. err)
        rejoinButton.Text = "Lỗi! Thử lại?"
        rejoinButton.BackgroundColor3 = Color3.new(0.8, 0.2, 0.2)
        task.wait(2)
        rejoinButton.Text = "Rejoin Server"
        rejoinButton.BackgroundColor3 = Color3.new(0.2, 0.8, 0.2)
    end
end)

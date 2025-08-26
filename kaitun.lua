-- Script Rejoin cập nhật
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")

-- Lấy người chơi hiện tại một cách an toàn
local localPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()

-- Đặt thời gian chờ để dễ dàng theo dõi trong console
local REJOIN_DELAY = 5 

-- Theo dõi trạng thái
print("Script Rejoin đã được tải.")

-- Kiểm tra xem người chơi có tồn tại không
if localPlayer then
    print("Đang lắng nghe sự kiện ngắt kết nối...")

    -- Kết nối với sự kiện khi người chơi rời đi
    -- Sử dụng PlayerRemoving để phát hiện khi người chơi bị ngắt kết nối
    localPlayer.PlayerRemoving:Connect(function()
        print("Phát hiện người chơi bị ngắt kết nối. Đang chờ " .. REJOIN_DELAY .. " giây...")
        
        -- Đợi một khoảng thời gian ngắn
        task.wait(REJOIN_DELAY)
        
        -- Lấy ID của game và ID của máy chủ hiện tại
        local gameId = game.PlaceId
        local jobId = game.JobId
        
        -- In ra thông tin trước khi teleport
        print("Đang cố gắng kết nối lại vào máy chủ " .. jobId .. "...")
        
        -- Sử dụng pcall để xử lý lỗi một cách an toàn
        local success, err = pcall(function()
            TeleportService:TeleportToPlaceInstance(gameId, jobId, localPlayer)
        end)
        
        if success then
            print("Teleport thành công. Đang kết nối lại...")
        else
            warn("Lỗi khi teleport: " .. err)
        end
    end)
else
    warn("Không tìm thấy người chơi cục bộ. Script không thể chạy.")
end

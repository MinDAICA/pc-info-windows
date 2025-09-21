Write-Host "🔍 Thông tin máy tính chi tiết:" -ForegroundColor Cyan

# Tên máy và model
$system = Get-CimInstance -ClassName Win32_ComputerSystem
Write-Host ""
Write-Host "💻 Tên máy: $($system.Name)" -ForegroundColor Yellow
Write-Host "📦 Model: $($system.Model)" -ForegroundColor Yellow

# CPU
$cpu = Get-CimInstance -ClassName Win32_Processor
Write-Host ""
Write-Host "🧠 CPU: $($cpu.Name)" -ForegroundColor Green

# RAM
$ramGB = [math]::Round($system.TotalPhysicalMemory / 1GB, 2)
Write-Host ""
Write-Host "🧮 RAM: $ramGB GB" -ForegroundColor Green

# Ổ cứng
$disks = Get-CimInstance -ClassName Win32_DiskDrive
foreach ($disk in $disks) {
    $diskSizeGB = [math]::Round($disk.Size / 1GB, 2)
    Write-Host ""
    Write-Host "💾 Ổ đĩa: $($disk.Model)" -ForegroundColor Cyan
    Write-Host "   Loại: $($disk.MediaType)" -ForegroundColor Gray
    Write-Host "   Dung lượng: $diskSizeGB GB" -ForegroundColor Gray
}

# Card mạng & IP/MAC
$netAdapters = Get-NetAdapter | Where-Object {$_.Status -eq "Up"}
foreach ($adapter in $netAdapters) {
    $ip = Get-NetIPAddress -InterfaceIndex $adapter.InterfaceIndex -AddressFamily IPv4
    Write-Host ""
    Write-Host "🌐 Card mạng: $($adapter.Name)" -ForegroundColor Cyan
    Write-Host "   MAC: $($adapter.MacAddress)" -ForegroundColor Gray
    Write-Host "   IP: $($ip.IPAddress)" -ForegroundColor Gray
}

# Domain
Write-Host ""
Write-Host "🏢 Domain: $($system.Domain)" -ForegroundColor Magenta

# Pin (nếu là laptop)
$battery = Get-CimInstance -ClassName Win32_Battery
if ($battery) {
    Write-Host ""
    Write-Host "🔋 Pin:" -ForegroundColor Cyan
    Write-Host "   Tên: $($battery.Name)" -ForegroundColor Gray
    switch ($battery.BatteryStatus) {
        1 { $status = "Đang dùng pin (không cắm sạc)" }
        2 { $status = "Đang cắm sạc (dùng nguồn AC)" }
        3 { $status = "Pin đầy, vẫn cắm sạc" }
        4 { $status = "Pin yếu" }
        5 { $status = "Pin rất yếu, sắp tắt máy" }
        6 { $status = "Đang sạc pin" }
        7 { $status = "Đang sạc, mức pin cao" }
        8 { $status = "Đang sạc, mức pin thấp" }
        9 { $status = "Đang sạc, mức pin rất thấp" }
        10 { $status = "Không xác định trạng thái" }
        11 { $status = "Pin chưa đầy, không sạc" }
        default { $status = "Không rõ trạng thái ($($battery.BatteryStatus))" }
    }
    Write-Host "   Trạng thái: $status" -ForegroundColor Gray
} else {
    Write-Host ""
    Write-Host "🔋 Không tìm thấy thông tin pin (có thể là máy bàn)" -ForegroundColor DarkGray
}

# Nhiệt độ CPU (cần quyền admin và có thể không hỗ trợ trên mọi máy)
$thermal = Get-WmiObject MSAcpi_ThermalZoneTemperature -Namespace "root/wmi"
foreach ($t in $thermal) {
    $tempC = [math]::Round(($t.CurrentTemperature - 2732) / 10, 1)
    Write-Host ""
    Write-Host "🌡️ Nhiệt độ CPU: $tempC °C" -ForegroundColor Red
}

# Cổng kết nối (HDMI/VGA/Type-C) – không thể lấy trực tiếp bằng PowerShell
Write-Host ""
Write-Host "🔌 Cổng kết nối: Không thể xác định bằng PowerShell. Vui lòng kiểm tra thủ công hoặc dùng phần mềm như HWiNFO hoặc Speccy." -ForegroundColor DarkYellow

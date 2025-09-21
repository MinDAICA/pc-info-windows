Write-Host " Thông tin máy tính chi tiết:" -ForegroundColor Cyan

# Tên máy và model
$system = Get-CimInstance -ClassName Win32_ComputerSystem
Write-Host "`n Tên máy: $($system.Name)"
Write-Host " Model: $($system.Model)"

# CPU
$cpu = Get-CimInstance -ClassName Win32_Processor
Write-Host "`n CPU: $($cpu.Name)"

# RAM
Write-Host " RAM: {0:N2} GB" -f ($system.TotalPhysicalMemory / 1GB)

# Ổ cứng
$disks = Get-CimInstance -ClassName Win32_DiskDrive
foreach ($disk in $disks) {
    Write-Host "`n Ổ đĩa: $($disk.Model)"
    Write-Host "   Loại: $($disk.MediaType)"
    Write-Host "   Dung lượng: {0:N2} GB" -f ($disk.Size / 1GB)
}

# Card mạng & IP/MAC
$netAdapters = Get-NetAdapter | Where-Object {$_.Status -eq "Up"}
foreach ($adapter in $netAdapters) {
    $ip = Get-NetIPAddress -InterfaceIndex $adapter.InterfaceIndex -AddressFamily IPv4
    Write-Host "`n Card mạng: $($adapter.Name)"
    Write-Host "   MAC: $($adapter.MacAddress)"
    Write-Host "   IP: $($ip.IPAddress)"
}

# Domain
Write-Host "`n Domain: $($system.Domain)"

# Pin (nếu là laptop)
$battery = Get-CimInstance -ClassName Win32_Battery
if ($battery) {
    Write-Host "`n Pin:"
    Write-Host "   Tên: $($battery.Name)"
    Write-Host "   Trạng thái: $($battery.BatteryStatus)"
} else {
    Write-Host "`n🔋 Không tìm thấy thông tin pin (có thể là máy bàn)"
}

# Nhiệt độ CPU (cần quyền admin và có thể không hỗ trợ trên mọi máy)
$thermal = Get-WmiObject MSAcpi_ThermalZoneTemperature -Namespace "root/wmi"
foreach ($t in $thermal) {
    $tempC = ($t.CurrentTemperature - 2732) / 10
    Write-Host "`n🌡️ Nhiệt độ CPU: $tempC °C"
}

# Cổng kết nối (HDMI/VGA/Type-C) – không thể lấy trực tiếp bằng PowerShell, cần phần mềm chuyên dụng hoặc kiểm tra thủ công
Write-Host "`n🔌 Cổng kết nối: Không thể xác định bằng PowerShell. Vui lòng kiểm tra thủ công hoặc dùng phần mềm như HWiNFO hoặc Speccy."

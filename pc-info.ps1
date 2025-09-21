Write-Host "🔍 Thông tin máy tính:" -ForegroundColor Cyan

$info = Get-ComputerInfo | Select-Object `
    CsName, `
    WindowsProductName, `
    WindowsVersion, `
    OsArchitecture, `
    BiosVersion, `
    CsProcessors, `
    CsTotalPhysicalMemory

$info | Format-List

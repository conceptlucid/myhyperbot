# HyperBot Windows Installer
# Run: irm https://myhyperbot.com/hyperbot.ps1 | iex

Write-Host "🤖 Installing HyperBot..." -ForegroundColor Cyan

# Create install directory
$InstallDir = "$env:USERPROFILE\.hyperbot"
if (!(Test-Path $InstallDir)) {
    New-Item -ItemType Directory -Path $InstallDir -Force | Out-Null
}

Set-Location $InstallDir

Write-Host "📥 Downloading HyperBot agent..." -ForegroundColor Yellow

# Clone repo (or download)
try {
    if (Test-Path "hyperbot-agent") {
        Set-Location hyperbot-agent
        git pull 2>$null
    } else {
        git clone --depth 1 https://github.com/conceptlucid/myhyperbot.git temp 2>$null
        if (Test-Path "temp\hyperbot-agent") {
            Move-Item temp\hyperbot-agent . -Force
        }
        Remove-Item temp -Recurse -Force -ErrorAction SilentlyContinue
    }
} catch {
    Write-Host "⚠️ Could not download, trying npm install..." -ForegroundColor Yellow
}

# Create config
$Config = @{
    cloudUrl = "https://myhyperbot.com"
    deviceName = $env:COMPUTERNAME
    apiKey = ""
} | ConvertTo-Json

Set-Content -Path "config.json" -Value $Config

# Create start script
@"
`$env:HOME = `$env:USERPROFILE
Set-Location "`$(`$PSScriptRoot)\hyperbot-agent"
npx tsx src/index.ts
"@ | Set-Content -Path "start.bat"

Write-Host "✅ HyperBot installed!" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor White
Write-Host "1. Edit `"`$HOME\.hyperbot\config.json`" with your cloud URL" -ForegroundColor Gray
Write-Host "2. Run: start.bat" -ForegroundColor Gray
Write-Host "3. Go to https://myhyperbot.com/dashboard" -ForegroundColor Gray

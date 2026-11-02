# Run from the repository root: powershell -NoProfile -ExecutionPolicy Bypass -File tools/verify-profiles.ps1
$ErrorActionPreference = 'Stop'
$script:checks = 0
function Assert-Profile($Condition, [string]$Message) {
    if (-not $Condition) { throw $Message }
    $script:checks++
}
$launcher = Join-Path (Split-Path -Parent $PSScriptRoot) 'NeovimProfiles/NvimProfiles.ps1'
$tokens = $null
$parseErrors = $null
[System.Management.Automation.Language.Parser]::ParseFile($launcher, [ref]$tokens, [ref]$parseErrors) | Out-Null
Assert-Profile ($parseErrors.Count -eq 0) 'Launcher PowerShell syntax is valid'
. $launcher

# Test the exported functions in this disposable process with a fake executable.
$script:calls = @()
$script:failLaunch = $false
$script:fakeNvim = {
    $script:calls += [pscustomobject]@{ AppName = $env:NVIM_APPNAME; Arguments = @($args) }
    if ($script:failLaunch) { throw 'Simulated launch failure' }
    $global:LASTEXITCODE = 7
}
function Get-Command { [pscustomobject]@{ Source = $script:fakeNvim } }
function Read-Host { throw 'A noninteractive launch must never prompt' }
$priorApp = [Environment]::GetEnvironmentVariable('NVIM_APPNAME', 'Process')
$priorCI = [Environment]::GetEnvironmentVariable('CI', 'Process')
try {
    $env:NVIM_APPNAME = 'existing-profile'
    nvim-jp 'a b.md' '--headless'
    Assert-Profile ($script:calls[-1].AppName -eq 'nvim-jp') 'Japanese launcher selects its own profile'
    Assert-Profile ($script:calls[-1].Arguments.Count -eq 2) 'Arguments are forwarded without splitting'
    Assert-Profile ($script:calls[-1].Arguments[0] -eq 'a b.md') 'Filename spaces are preserved'
    Assert-Profile ($env:NVIM_APPNAME -eq 'existing-profile') 'Previous environment is restored'
    Assert-Profile ($LASTEXITCODE -eq 7) 'Exit status is preserved'
    nvim-code 'main.lua'
    Assert-Profile ([string]::IsNullOrEmpty($script:calls[-1].AppName)) 'Coding uses the default profile'
    Assert-Profile ($env:NVIM_APPNAME -eq 'existing-profile') 'Coding restores previous app name'
    nvim '--headless' '-u' 'NONE'
    Assert-Profile ($script:calls[-1].Arguments[0] -eq '--headless') 'Automatic headless launch bypasses menu'
    Assert-Profile ([string]::IsNullOrEmpty($script:calls[-1].AppName)) 'Automatic file/flag launches use Coding'
    $env:CI = 'true'
    nvim
    Assert-Profile ([string]::IsNullOrEmpty($script:calls[-1].AppName)) 'CI without arguments bypasses menu'
    Remove-Item Env:NVIM_APPNAME -ErrorAction SilentlyContinue
    nvim-jp
    Assert-Profile ([string]::IsNullOrEmpty($env:NVIM_APPNAME)) 'Originally absent app name remains absent'
    $env:NVIM_APPNAME = 'existing-profile'
    $script:failLaunch = $true
    $failed = $false
    try { nvim-jp } catch { $failed = $true }
    Assert-Profile $failed 'Launch failure propagates'
    Assert-Profile ($env:NVIM_APPNAME -eq 'existing-profile') 'Failure still restores the previous environment'
} finally {
    if ($null -eq $priorApp) { Remove-Item Env:NVIM_APPNAME -ErrorAction SilentlyContinue }
    else { $env:NVIM_APPNAME = $priorApp }
    if ($null -eq $priorCI) { Remove-Item Env:CI -ErrorAction SilentlyContinue }
    else { $env:CI = $priorCI }
}
Write-Output "PASS: $script:checks PowerShell profile checks (syntax, arguments, environment, and noninteractive use)"

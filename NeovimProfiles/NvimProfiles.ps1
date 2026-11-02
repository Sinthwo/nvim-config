# Copyright-free launcher functions. Dot-source from the user's PowerShell profile.
# Only no-argument interactive PowerShell `nvim` displays the menu.
function global:Invoke-NvimProfile {
    [CmdletBinding()]
    param(
        [ValidateSet('Auto', 'Coding', 'Japanese')][string]$Mode = 'Auto',
        [object[]]$NvimArgs = @()
    )
    $exe = Get-Command -Name 'nvim.exe' -CommandType Application -ErrorAction SilentlyContinue | Select-Object -First 1
    if (-not $exe) { throw 'nvim.exe was not found in PATH. Install Neovim or add it to PATH.' }
    $choice = $Mode
    if ($choice -eq 'Auto') {
        # Avoid interactive input for files, flags, headless, redirected I/O, and CI.
        $canPrompt = $NvimArgs.Count -eq 0 -and [Environment]::UserInteractive -and -not $env:CI
        try {
            $canPrompt = $canPrompt -and -not [Console]::IsInputRedirected -and -not [Console]::IsOutputRedirected
        } catch { $canPrompt = $false }
        if ($canPrompt) {
            Write-Host ''
            Write-Host 'Choose Neovim workspace:'
            Write-Host '  1  Coding (existing configuration)'
            Write-Host '  2  Japanese writing (isolated configuration)'
            $answer = Read-Host 'Workspace [1]'
            if ($answer -eq '2') { $choice='Japanese' }
            elseif ($answer -eq '' -or $answer -eq '1') { $choice='Coding' }
            else { Write-Warning 'Unknown selection. Using Coding.'; $choice='Coding' }
        } else { $choice='Coding' }
    }
    $old = [Environment]::GetEnvironmentVariable('NVIM_APPNAME','Process')
    try {
        if ($choice -eq 'Japanese') {
            $env:NVIM_APPNAME = 'nvim-jp'
        } else {
            Remove-Item Env:NVIM_APPNAME -ErrorAction SilentlyContinue
        }
        & $exe.Source @NvimArgs
        $global:LASTEXITCODE = $LASTEXITCODE
    }
    finally {
        if ($null -eq $old) { Remove-Item Env:NVIM_APPNAME -ErrorAction SilentlyContinue }
        else { $env:NVIM_APPNAME = $old }
    }
}
function global:nvim-code { Invoke-NvimProfile -Mode Coding -NvimArgs $args }
function global:nvim-jp { Invoke-NvimProfile -Mode Japanese -NvimArgs $args }
function global:nvim { Invoke-NvimProfile -Mode Auto -NvimArgs $args }

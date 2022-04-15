Import-Module posh-git

$Green = [ConsoleColor]::Green
$Red = [ConsoleColor]::Red

$GitPromptSettings.DefaultPromptAbbreviateHomeDirectory = $true
$GitPromptSettings.BranchColor.ForegroundColor = 'Yellow'
$GitPromptSettings.WorkingColor.ForegroundColor = 'Yellow'
$GitPromptSettings.BeforeStatus.ForegroundColor = 'Yellow'
$GitPromptSettings.AfterStatus.ForegroundColor = 'Yellow'
$GitPromptSettings.LocalWorkingStatusSymbol.ForegroundColor = 'Yellow'
$GitPromptSettings.DefaultPromptPath.ForegroundColor = [ConsoleColor]::Magenta
$GitPromptSettings.DefaultPromptSuffix.Text = '$(" $" * ($nestedPromptLevel + 1)) '
$GitPromptSettings.DefaultPromptSuffix.ForegroundColor = $Green

function prompt {
    # Your non-prompt logic here
    $IsSuccess = $? -eq $true

    $prompt = ""
    if ($IsSuccess) {
        $prompt += Write-Prompt '[+] ' -ForegroundColor $Green
    } else {
        $prompt += Write-Prompt '[-] ' -ForegroundColor $Red
    }
    $prompt += & $GitPromptScriptBlock
    if ($prompt) {$prompt} else {" "}
}

Remove-Item Alias:gc -Force
Remove-Item Alias:gm -Force

function Set-GitAdd { & git add $args }
New-Alias -Name ga -Value Set-GitAdd
function Get-GitStatus { & git status $args }
New-Alias -Name gs -Value Get-GitStatus
function Set-GitCommit { & git commit -m $args }
New-Alias -Name gc -Value Set-GitCommit
function Set-GitCheckout { & git checkout $args }
New-Alias -Name gco -Value Set-GitCheckout
function Set-GitMerge { & git merge $args }
New-Alias -Name gm -Value Set-GitMerge
function Edit-Profile { & code $profile }
New-Alias -Name ep -Value Edit-Profile
# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

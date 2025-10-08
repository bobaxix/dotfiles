Import-Module posh-git

function Test-CommandExists($cmd) {
    return (Get-Command $cmd -ErrorAction SilentlyContinue) -ne $null    
}

function Test-IsTermRider() {
    return $env:TERMINAL_EMULATOR -eq "JetBrains-JediTerm"
}

function Get-CommandSource($cmd) {
    return Get-Command $cmd | Select-Object -ExpandProperty Source
}

function Convert-ToForwardSlashes(
    [Parameter(ValueFromPipeline=$true)]
    [string]$Path)
{
    return $Path -replace '\\', '/'
}

function Go-Dir ($Path) {
    if ($Path)
    {
    	Set-Location $Path
    }
    else
    {
    	Set-Location ~	
    }
}

function Get-Branch 
{
    $Branch = git branch --show-current
    if($?) {
    	return $Branch.Trim() 
    }
    
    Throw 'Not git repo'

}

function Remove-Item-Recurse ($Path) { Remove-Item -Recurse -Path $Path }

New-Alias dc Run-Docker-Compose

Remove-Item alias:\cd

Set-Alias cd Go-Dir
Set-Alias vi vim

function prompt
{
    Write-Host "PS " -NoNewLine -ForegroundColor Red
    Write-Host $(Get-Location) -NoNewLine -ForegroundColor Blue
    
    Try 
    {
        $Branch = $(Get-Branch)
        Write-Host " ($Branch)" -NoNewLine -ForegroundColor Green
    } 
    Catch 
    { }

    Write-Host "$" -NoNewLine -ForegroundColor White
    return " "

}

New-Alias touch New-Item

if ((Test-IsTermRider) -and (Test-CommandExists "gvim"))
{
    $editor = Get-CommandSource "gvim" | Convert-ToForwardSlashes

    $env:GIT_EDITOR    = "$editor --nofork"
    $env:GIT_DIFFTOOL  = "gvim"
    $env:GIT_MERGETOOL = "gvim"
}
elseif (Test-CommandExists "vim")
{
    $editor = Get-CommandSource "vim" | Convert-ToForwardSlashes

    $env:GIT_EDITOR    = "$editor"
    $env:GIT_DIFFTOOL  = "locvim"
    $env:GIT_MERGETOOL = "locvim"
}
else 
{
    # Fallback: do not set editor or tools — Git will use internal diff
    Remove-Item Env:GIT_EDITOR -ErrorAction SilentlyContinue
    Remove-Item Env:GIT_DIFFTOOL -ErrorAction SilentlyContinue
    Remove-Item Env:GIT_MERGETOOL -ErrorAction SilentlyContinue
}

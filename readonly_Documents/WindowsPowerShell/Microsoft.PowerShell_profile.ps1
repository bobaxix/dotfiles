Import-Module posh-git

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

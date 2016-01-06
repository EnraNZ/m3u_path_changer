<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2015 v4.2.99
	 Created on:   	01/01/2016 07:28 PM
	 Created by:   	SudoSandwich aka EnraNZ @ Arne Lünsmann
	 Organization: 	Enra Corp.
	 Filename:     	m3u_path_changer.ps1
	===========================================================================
	.DESCRIPTION
		A small PowerShell script for changing the path in .m3u playlists
	.License
		Copyright 2016 Arne Lünsmann

	   	Licensed under the Apache License, Version 2.0 (the "License");
	   	you may not use this file except in compliance with the License.
	   	You may obtain a copy of the License at

	       http://www.apache.org/licenses/LICENSE-2.0

	   	Unless required by applicable law or agreed to in writing, software
	   	distributed under the License is distributed on an "AS IS" BASIS,
	   	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	   	See the License for the specific language governing permissions and
	   	limitations under the License.
#>

function Get-ScriptDirectory
{
	[OutputType([string])]
	param ()
	if ($hostinvocation -ne $null)
	{
		Split-Path $hostinvocation.MyCommand.path
	}
	else
	{
		Split-Path $script:MyInvocation.MyCommand.Path
	}
}
[string]$global:ScriptDirectory = Get-ScriptDirectory
#Write-Host $ScriptDirectory

Function custom-pause
{
	param (		
		$DisplayMessage = $TRUE,
		$msg = ”Press any key to continue...”,
		$color
	)
	if ($DisplayMessage)
	{
		if ($color)
		{
			write-host $msg -ForegroundColor $color
		}
		else
		{
			write-host $msg
		}
	}
	$HOST.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") | OUT-NULL
	$HOST.UI.RawUI.Flushinputbuffer()
}
NEW-Alias pause custom-pause
# pause –DisplayMessage $FALSE
# pause –msg “blub”

Write-Host "EnraCorp. -- .m3u path changer" -ForegroundColor Yellow
pause –msg “Smack the keyboard to continue with the script`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n” -color "Cyan"

$dir = "$ScriptDirectory\m3u-files\*"
$playlists = Get-ChildItem -Path "$dir" -Filter *.m3u | Sort-Object

Write-Host "Log:"
ForEach ($playlist in $playlists)
{
	Start-Sleep -m 666
	$i++
	$playlistName = split-path $playlist -leaf
	Write-Progress -Id 0 -Activity "Changing Paths in $playlistName`:" -percentComplete ($i / $playlists.count * 100)
	
	$lines = Get-Content $playlist
	$totalLines = $lines.length.ToString("0000")
	
	$l = 0
	$lines |
	ForEach-Object {
		if ($_.ReadCount -ge 3 -and $_.ReadCount % 2 -eq 1)
		{
			$l++
			$li = $l.ToString("0000")
			$lineNo_leadingZeros = $_.ReadCount.ToString("0000")
			
			if ($li -eq $lineNo_leadingZeros)
			{
				Write-Progress -Id 1 -activity "$_" -status "Line $li of $totalLines" -PercentComplete (($l / $totalLines) * 100)
				$_ -replace '\/\/192.168.128.99\/Audio', '../..'
				Start-Sleep -m 42
			}
			else
			{
				Write-Host "ERROR"	
			}
		}
		else
		{
			$l++
			Write-Progress -Id 1 -Activity " " -PercentComplete (($l / $totalLines) * 100)
			$_
		}
	} |
	Set-Content $playlist
	Write-Host "$playlistName changed" -ForegroundColor DarkGreen
}
pause –msg “Press any key to close the script...”

# m3u_path_changer
A small PowerShell script for changing the path in .m3u playlists

! This is the first public project of mine on github. !
This project is primarily for getting feedbacks of other devs so that I can improve my own skills for further projects in PowerShell.

Please don't hesitate with feedbacks for the coding, structure and everyhting else.

-------------------------

Preperations:
- Change the ExecutionPolicy of PowerShell to allow all Scripts or sign this one with your certificates and change Execution Policy to signed only.
- create a folder "m3u-files" in the same folder where the .ps1 file is located.
- verify that your .m3u playlists also contain #EXTINF data. This Script changes only ODD linenumbers. starting with line 3. See example.m3u with details

Usage:
- In Line 98, edit $_ -replace 'old_Path', 'new_Path'  -- with your current path and the new one
Examples:

  $_ -replace '\/\/192.168.128.128\/Audio', '../..'
  
  $_ -replace 'Z:\Audio', '../../42'
  
- place your .m3u files in the "m3u-files" folder
- run the script


Additional Notes:
- theres one example.m3u available for testing.


$sourcePath = "C:\Prabhakar\Compare\source\"
Get-ChildItem | Get-Member

Get-ChildItem -Path $sourcePath | Select-Object Name,FullName,lastwriteTime | sort -Property lastwriteTime -Descending











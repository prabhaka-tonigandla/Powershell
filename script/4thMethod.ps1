$sourcePath = "C:\Prabhakar\Compare\source\"
$destPath = "C:\Prabhakar\Compare\dest\"
$Location = "C:\Prabhakar\test.csv"
$SourceDocs = Get-ChildItem –Path $sourcePath -Recurse | foreach  {Get-FileHash –Path $_.FullName}
$DestDocs = Get-ChildItem –Path $destPath -Recurse | foreach  {Get-FileHash –Path $_.FullName}


 (Compare-Object -ReferenceObject $SourceDocs -DifferenceObject $DestDocs  -Property hash -PassThru)   | ConvertTo-Html -Property Path | Out-File C:\Users\Aaradhya\Documents\GitHub\Powershell\script\files.html








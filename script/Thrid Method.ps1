$sourcePath = "C:\Prabhakar\Compare\source\"
$destPath = "C:\Prabhakar\Compare\dest\"
$Location = "C:\Prabhakar\test.csv"
$SourceDocs = Get-ChildItem –Path $sourcePath | foreach  {Get-FileHash –Path $_.FullName}
$DestDocs = Get-ChildItem –Path $destPath | foreach  {Get-FileHash –Path $_.FullName}


$result = (Compare-Object -ReferenceObject $SourceDocs -DifferenceObject $DestDocs  -Property hash -PassThru)   
$outputFile = New-Object System.Collections.Generic.List[System.Object]
Foreach ($i in $result.Path)
{
 
$filename = Split-Path $i -leaf
if($outputFile -notcontains $filename)
{
$outputFile.Add($filename)
}

#compare-object (get-content $sourceFileName) (get-content $destFileName)

#compare-object (get-content $sourceFileName) (get-content $destFileName) | format-list | Out-File $Location
#Compare-Object -referenceObject $(Get-Content $sourceFileName) -differenceObject $(Get-Content $destFileName) | %{$_.Inputobject + $_.SideIndicator} | ft -auto | out-file $Location -width 5000


}
#$outputFile= $outputFile | select -Unique

#Write-Host $outputFile -ForegroundColor green
#$result= Compare-Object -ReferenceObject $(Get-Content $sourceFileName) -DifferenceObject $(Get-Content $destFileName) | Select -Property InputObject 
#$result.InputObject
foreach ($letter in $outputFile)
{


$sourceFileName =Join-Path -Path $sourcePath -ChildPath $letter
$destFileName =Join-Path -Path $destPath -ChildPath $letter

$result= Compare-Object -ReferenceObject $(Get-Content $sourceFileName) -DifferenceObject $(Get-Content $destFileName) | Select -Property InputObject  
$result.InputObject

}







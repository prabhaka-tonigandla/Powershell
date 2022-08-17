
$sourcePath = "C:\Prabhakar\Compare\source\"
$destPath = "C:\Prabhakar\Compare\dest\"
$Location = "C:\Users\Aaradhya\Documents\GitHub\Powershell\script\AppendHtmlUpdated.html"
$SourceDocs = Get-ChildItem –Path $sourcePath -Recurse | foreach { Get-FileHash –Path $_.FullName }
$DestDocs = Get-ChildItem –Path $destPath -Recurse  | foreach { Get-FileHash –Path $_.FullName }
$css = "./styles.css"

$result = (Compare-Object -ReferenceObject $SourceDocs -DifferenceObject $DestDocs  -Property hash -PassThru )  
$PathsText = (Compare-Object -ReferenceObject $SourceDocs -DifferenceObject $DestDocs  -Property hash -PassThru )   |  ConvertTo-Html -Property Path -Fragment
$outputFile = New-Object System.Collections.Generic.List[System.Object]


Foreach ($i in $result.Path) {
 
    $filename = Split-Path $i -leaf
    if ($outputFile -notcontains $filename) {
        $outputFile.Add($filename)
    }

}
$differencestext = New-Object System.Collections.Generic.List[System.Object]
foreach ($letter in $outputFile) {


    $sourceFileName = Join-Path -Path $sourcePath -ChildPath $letter
    $destFileName = Join-Path -Path $destPath -ChildPath $letter

    #Write-Host "source: $sourceFileName and desntination: $destFileName "

    if (Test-Path -Path $sourceFileName) {

      $temp =  Compare-Object -ReferenceObject $(Get-Content $sourceFileName) -DifferenceObject $(Get-Content $destFileName) |  ConvertTo-Html  -Fragment
     $differencestext.Add($temp)

    }

   

}
$bodyText = @()
foreach ($row in $differencestext) {
$bodyText += $row

}

    ConvertTo-Html -Body " $PathsText   $bodyText"  -Title "Test report"  -CssUri $css | Out-File $Location

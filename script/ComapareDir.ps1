
$SourceDocs = Get-ChildItem –Path C:\Prabhakar\Compare\source | foreach  {Get-FileHash –Path $_.FullName}

$DestDocs = Get-ChildItem –Path C:\Prabhakar\Compare\dest | foreach  {Get-FileHash –Path $_.FullName}

Compare-Object -ReferenceObject $SourceDocs.Hash  -DifferenceObject $DestDocs.Hash

$data=(Compare-Object -ReferenceObject $SourceDocs -DifferenceObject $DestDocs  -Property hash -PassThru).Path
$ReportTitle = "Event Log Report"
$footer = "<h5><i>report run $(Get-Date)</i></h5>"
$css = ".\sample.css"
$precontent = "<H1>$env.</H1><H2> file differencesg</H2>"

(Compare-Object -ReferenceObject $SourceDocs -DifferenceObject $DestDocs  -Property hash -PassThru) | Select Path  | 
    ConvertTo-Html -Title $ReportTitle -PreContent $precontent  -PostContent $footer -CssUri $css |
    Out-File C:\Users\Aaradhya\Documents\GitHub\Powershell\script\test.html
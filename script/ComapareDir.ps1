
$SourceDocs = Get-ChildItem –Path C:\Prabhakar\Compare\source | foreach  {Get-FileHash –Path $_.FullName}

$DestDocs = Get-ChildItem –Path C:\Prabhakar\Compare\dest | foreach  {Get-FileHash –Path $_.FullName}

Compare-Object -ReferenceObject $SourceDocs.Hash  -DifferenceObject $DestDocs.Hash

$data=(Compare-Object -ReferenceObject $SourceDocs -DifferenceObject $DestDocs  -Property hash -PassThru)
$lastover=(Compare-Object -ReferenceObject $SourceDocs -DifferenceObject $DestDocs  -Property hash -PassThru).lastWriteTime
$ReportTitle = "Event Log Report"
$footer = "<h5><i>report run $(Get-Date)</i></h5>"
$css = ".\sample.css"
$precontent = "<H1>$env.</H1><H2> file differencesg</H2>"
$lastover

$data | Select Path,LastWriteTime  | s
    ConvertTo-Html -Title $ReportTitle -PreContent $precontent  -PostContent $footer -CssUri $css |
    Out-File C:\Users\Aaradhya\Documents\GitHub\Powershell\script\fileTest.html


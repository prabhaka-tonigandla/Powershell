
$folder1 = "C:\Prabhakar\Compare\source\"
$folder2 = "C:\Prabhakar\Compare\dest\"
$css = "./styles.css"
$Location = "C:\Users\Aaradhya\Documents\GitHub\Powershell\script\BCPFinal.html"
$FilesOnlyInSource =New-Object System.Collections.Generic.List[System.Object]
$FilesOnlyInDestination =New-Object System.Collections.Generic.List[System.Object]
$MismatchFiles = New-Object System.Collections.Generic.List[System.Object]

# Get all files under $folder1, filter out directories
$firstFolder = Get-ChildItem -Recurse $folder1 | Where-Object { -not $_.PsIsContainer }

$failedCount = 0
$i = 0
$totalCount = $firstFolder.Count
$firstFolder | ForEach-Object {
    $i = $i + 1
    Write-Progress -Activity "Searching Files" -status "Searching File  $i of     $totalCount" -percentComplete ($i / $firstFolder.Count * 100)
    # Check if the file, from $folder1, exists with the same path under $folder2
    If ( Test-Path ( $_.FullName.Replace($folder1, $folder2) ) ) {
        # Compare the contents of the two files...
        If ( Compare-Object (Get-Content $_.FullName) (Get-Content $_.FullName.Replace($folder1, $folder2) ) ) {
            # List the paths of the files containing diffs
            $fileSuffix = $_.FullName.TrimStart($folder1)
            $filename =  Split-Path $_.FullName -leaf
            $failedCount = $failedCount + 1
           # Write-Host "$filename is on each server, but does not match"
            $MismatchFiles.Add($_.FullName)
            
        }
    }
    else
    {
        $filename =  Split-Path $_.FullName -leaf
        $failedCount = $failedCount + 1
        #Write-Host "$filename is only in folder 1"
        $FilesOnlyInSource.Add($_.FullName)
    }
}

$secondFolder = Get-ChildItem -Recurse $folder2 | Where-Object { -not $_.PsIsContainer }

$i = 0
$totalCount = $secondFolder.Count
$secondFolder | ForEach-Object {
    $i = $i + 1
    Write-Progress -Activity "Searching for files only on second folder" -status "Searching File  $i of $totalCount" -percentComplete ($i / $secondFolder.Count * 100)
    # Check if the file, from $folder2, exists with the same path under $folder1
    If (!(Test-Path($_.FullName.Replace($folder2, $folder1))))
    {
        $fileSuffix = $_.FullName.TrimStart($folder2)
        $filename =  Split-Path $_.FullName -leaf
        $failedCount = $failedCount + 1
        #Write-Host "$filename is only in folder 2"
        $FilesOnlyInDestination.Add($_.FullName)
    }
}

$FilesOnlyInSource
$FilesOnlyInDestination 
$MismatchFiles 

#$FilesOnlyInSourceHtml = $FilesOnlyInSource  |  Get-ChildItem -Path $_. |
     #   Select-Object -Property BaseName,Extension,Length,LastWriteTime ConvertTo-HTML -Fragment -PreContent "<h1>Files only exists in Source</h1>"
#$FilesOnlyInDestinationHtml = $FilesOnlyInDestination  | ConvertTo-HTML -Fragment -PreContent "<h1>Files only exists in Destination</h1>"
#$MismatchFilesHtml = $MismatchFiles  | ConvertTo-HTML -Fragment -PreContent "<h1>Mismatched files list</h1>"


$bodyText = @()
foreach ($row in $FilesOnlyInSource) {
$bodyText += $row

}
$bodyTexthtml = $bodyText  | ConvertTo-HTML -Fragment -PreContent "<h1>Files only exists in Destination</h1>"
$test=$bodyText.ToString()
ConvertTo-Html -Body "$bodyText"  -Title "Test report"  -CssUri $css | Out-File $Location
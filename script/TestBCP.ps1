
$folder1 = "C:\Prabhakar\Compare\source\"
$folder2 = "C:\Prabhakar\Compare\dest\"
$css = "./styles.css"
$Location = "C:\Users\Aaradhya\Documents\GitHub\Powershell\script\BCPFinal.html"
$FilesOnlyInSource =@()
$FilesOnlyInDestination =@()
$MismatchFiles = @()
$myObject = [PSCustomObject]@{
    Path     = 'Kevin'
    Language = 'PowerShell'
    State    = 'Texas'
}
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
            $MismatchFiles += New-Object -TypeName psobject -Property @{Path=$_.FullName; DeployedDate=$_.LastWriteTime;SizeinKB=$_.Length}

            
        }
    }
    else
    {
        $filename =  Split-Path $_.FullName -leaf
        $failedCount = $failedCount + 1
        #Write-Host "$filename is only in folder 1"
        $FilesOnlyInSource += New-Object -TypeName psobject -Property @{Path=$_.FullName; DeployedDate=$_.LastWriteTime;SizeinKB=$_.Length}
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
         $FilesOnlyInDestination += New-Object -TypeName psobject -Property @{Path=$_.FullName; DeployedDate=$_.LastWriteTime;SizeinKB=$_.Length}
    }
}

$FilesOnlyInSource
$FilesOnlyInDestination 
$MismatchFiles 

$FilesOnlyInSourceHtml = $FilesOnlyInSource  | ConvertTo-HTML -Fragment -PreContent "<h1>Files only exists in Source</h1>"
$FilesOnlyInDestinationHtml = $FilesOnlyInDestination  | ConvertTo-HTML -Fragment -PreContent "<h1>Files only exists in Destination</h1>"
$MismatchFilesHtml = $MismatchFiles  | ConvertTo-HTML -Fragment -PreContent "<h1>Mismatched files list</h1>"



ConvertTo-Html -Body " $FilesOnlyInSourceHtml $FilesOnlyInDestinationHtml $MismatchFilesHtml"  -Title "Test report"  -CssUri $css | Out-File $Location



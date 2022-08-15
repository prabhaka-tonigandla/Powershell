Param(
    [Parameter(Mandatory,HelpMessage = "Enter the source path")]
    [string]$sourcePath,
    [Parameter(Mandatory,HelpMessage = "Enter the destionation path")]
    [string]$DestinationPath,
    [string]$ReportTitle = "files comparison Report",
    [Parameter(Mandatory,HelpMessage = "Enter the path for the HTML file.")]
    [string]$Path
)

$data = Get-Eventlog -logname $Log -EntryType Error -Newest $newest -ComputerName $Computername |
    Group-object -Property Source -NoElement
$Date = Get-Date -Format d
$Header = "<h1> Office 365 Report for $Date </h1>"
$Licenses = Get-AzureADSubscribedSku | Select-Object  -Property SkuPartNumber, ConsumedUnits -ExpandProperty PrepaidUnits | ConvertTo-HTML -Fragment -PreContent "<h1>License Information</h1>"
$Users = Get-AzureADUser | Where {$_.UserType -eq "Member"} | Select UserPrincipalName, DisplayName, Country, Department | ConvertTo-HTML -Fragment -PreContent "<h1>Office 365 Users</h1>"
$Guests = Get-AzureADUser | Where {$_.UserType -eq "Guest"} | Select UserPrincipalName, Mail, DisplayName | ConvertTo-HTML -Fragment -PreContent "<h1>Office 365 Guests</h1>"
ConvertTo-HTML  -Body "$Header $Licenses $Users $Guests" -Title "Office 365 Report" -CssUri styles.css | Out-File C:\Pluralsight\M2\O365Scenario\O365.html
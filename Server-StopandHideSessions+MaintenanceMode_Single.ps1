$site = "MyDeliveryController"
$domain = "MyDomain"

#------------------Display Banner-------------------------

Clear-Host
Write-Host "-------" -NoNewLine
Write-Host "Citrix PowerTools" -Foreground Cyan -NoNewLine
Write-Host "-------"
Write-Host ""
Write-Host "Server Stop and Hide User Sessions + Maintenance Mode" -ForegroundColor Cyan
Write-Host""
Write-Host "Why would you want to do this?" -ForegroundColor Yellow
Write-Host "Sometimes a server, vda,  will continue to show active"
Write-Host "sessions in Citrix Studio or Director after a machine"
Write-Host "failure. Possible a lost network connector or anything."
Write-Host""
Write-Host "Taking this action will hide all of the VDA sessions"
Write-Host "and put the machine in maintenance, preventing new users"
Write-Host "and existing users from connecting to it again."
Write-Host""
Write-Host "You can still see the user sessions in Citrix Studio and"
Write-Host "Director but you'll notice in Director it says:"
Write-Host "No details available." -ForegroundColor Yellow
Write-Host""
Write-Host "This lets you know the sessions are hidden."
Write-Host""

$VDANumber = Read-Host "Enter VDA Name (ie: MyVDA) or Q to exit"
If ($VDANumber -eq "q"){exit}
Add-PSSnapin Citrix*

$VDA = $domain + "\" + $VDANumber
#-Logoff
Get-BrokerSession -AdminAddress $site -MachineName $VDA | Stop-BrokerSession
#-Disconnect
Get-BrokerSession -AdminAddress $site -MachineName $VDA | Disconnect-BrokerSession
#-Hide
Get-BrokerSession -AdminAddress $site -MachineName $VDA | Set-BrokerSession -Hidden:$true
Set-BrokerMachineMaintenanceMode -AdminAddress $site -InputObject $VDA $true

Clear-Host
Write-Host "-------" -NoNewLine
Write-Host "Citrix PowerTools" -Foreground Cyan -NoNewLine
Write-Host "-------"
Write-Host ""
Write-Host "Pausing for 45 seconds to get results if logoffs are successful..."
Start-Sleep -S 45
Write-Host ""
$Maintenance = Get-BrokerMachine -AdminAddress $site -MachineName $VDA | Select-Object MachineName,InMaintenanceMode | Format-List
$Maintenance
Write-Host "Results for Sessions on $VDANumber" -ForegroundColor Cyan
Write-Host "--------------------------------------------"
$Session = Get-BrokerSession -AdminAddress $site -MachineName $VDA | Select-Object BrokeringUserName,Hidden | Format-List
If ($Session -eq $Null) {Write-Host "No session found for $VDANumber!" -ForegroundColor Red}
$Session
Write-Host "--------------------------------------------"
Write-Host ""

Write-Host "Done!" -ForegroundColor Green
pause

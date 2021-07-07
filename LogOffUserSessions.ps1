Write-Host 'OMSVRDSAZU001'
quser /server:OMSVRDSAZU001
Write-Host 'OMSVRDSAZU002'
quser /server:OMSVRDSAZU002
Write-Host 'OMSVRDSAZU003'
quser /server:OMSVRDSAZU003

Write-Host '******************************'
Write-Host '* Log Off User Remotely *'
Write-Host '******************************'
Write-Host
 
$global:adminCreds = $host.ui.PromptForCredential("Need credentials", "Please enter your user name and password.", "", "")

#$input = Read-Host 'Computer Name? Computer names as follows 1. OMSVRDSAZU001 2. OMSVRDSAZU002 3. OMSVRDSAZU003'

$title = 'RDS Servername'
$question = 'What server do you want to connect to?'

$RDS1 = New-Object System.Management.Automation.Host.ChoiceDescription '&OMSVRDSAZU001', 'OMSVRDSAZU001'
$RDS2 = New-Object System.Management.Automation.Host.ChoiceDescription '&OMSVRDSAZU002', 'OMSVRDSAZU002'
$RDS3 = New-Object System.Management.Automation.Host.ChoiceDescription '&OMSVRDSAZU003', 'OMSVRDSAZU003'

$option = [System.Management.Automation.Host.ChoiceDescription[]]($RDS1, $RDS2, $RDS3)

$results = $host.ui.PromptForChoice($title, $question, $option, 0)

$ComputerName = switch($results)
{
    0 { 'OMSVRDSAZU001' }
    1 { 'OMSVRDSAZU002' }
    2 { 'OMSVRDSAZU003' }
}

Function getSessions {
Write-host
Write-host "Getting user sessions..."
Write-Host
Write-Host '***************************************************************************'
Invoke-Command -ComputerName $ComputerName -scriptBlock {query session} -credential $global:adminCreds
}
 
Function logUserOff {
Write-Host
$SessionNum = Read-Host 'Session ID number to log off?'
$title = "Log Off"
$message = "Are you sure you want to log them off?"
$yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes", `
"Logs selected user off."
$no = New-Object System.Management.Automation.Host.ChoiceDescription "&No", `
"Exits."
$options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no)
$result = $host.ui.PromptForChoice($title, $message, $options, 1)
 
switch ($result){
0 {
Write-Host
Write-Host 'OK. Logging them off...'
Invoke-Command -ComputerName $ComputerName -scriptBlock {logoff $args[0]} -ArgumentList $SessionNum -credential $global:adminCreds
Write-Host
Write-Host 'Success!' -ForegroundColor green
break
}
1 {break}
}
}
 
Do {
getSessions
logUserOff
 
Write-Host
#Write-Host "Press any key to continue ..."
# $x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
 
#Configure yes choice
$yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes","Remove another profile."
 
#Configure no choice
$no = New-Object System.Management.Automation.Host.ChoiceDescription "&No","Quit profile removal"
 
#Determine Values for Choice
$choice = [System.Management.Automation.Host.ChoiceDescription[]] @($yes,$no)
 
#Determine Default Selection
[int]$default = 0
 
#Present choice option to user
$userchoice = $host.ui.PromptforChoice("","Logoff Another Profile?",$choice,$default)
}
#If user selects No, then q
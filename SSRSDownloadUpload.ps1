#------------------------------------------------------
#Prerequisites
#Install-Module -Name ReportingServicesTools -Force
#------------------------------------------------------

#Lets get security on all folders in a single instance
#------------------------------------------------------
#Declare SSRS URI
$sourceRsUri = 'http://10/ReportServer/ReportService2010.asmx?wsdl'

#Declare Proxy so we dont need to connect with every command
$proxy = New-RsWebServiceProxy -ReportServerUri $sourceRsUri

#Output ALL Catalog items to file system
#Out-RsFolderContent -Proxy $proxy -RsFolder '/E10Live/reports/CustomReports' -Destination C:\SSRSReports -Recurse -Verbose

#Create CustomReports Folder in SSRS
New-RsFolder -Proxy $proxy -RsFolder '/E10Pilot/reports' -FolderName 'CustomReports'

#Write CustomReports to new Folder
Write-RsFolderContent -Proxy $proxy -Path C:\SSRSReports -RsFolder '/E10Pilot/reports/CustomReports' -Recurse -Overwrite -Verbose
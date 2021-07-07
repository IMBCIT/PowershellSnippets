#Set variables:
$reportServer = "servername"
$reportsDeployment = "E10Pilot"
$newDataSourcePath = "/$($reportsDeployment)/reports/SharedReportDataSource"
$newDataSourceName = "SharedReportDataSource"
$reportFolderPath = "/$($reportsDeployment)/Reports/CustomReports"
#------------------------------------------------------------------------

$reportServerUri = "http://$($reportServer)/reportserver/ReportService2010.asmx?wsdl"
$rs = New-WebServiceProxy -Uri $reportServerUri -UseDefaultCredential                        

# List everything(!) on the Report Server, recursively
$reports = $rs.ListChildren($reportFolderPath, $true)
$reports | ForEach-Object {
      $reportPath = $_.path
      Write-Host "Report: " $reportPath
      $dataSources = $rs.GetItemDataSources($reportPath)
      $dataSources | ForEach-Object {
      $proxyNamespace = $_.GetType().Namespace
      $myDataSource = New-Object ("$proxyNamespace.DataSource")
      $myDataSource.Name = $newDataSourceName
      $myDataSource.Item = New-Object ("$proxyNamespace.DataSourceReference")
      $myDataSource.Item.Reference = $newDataSourcePath
      
      $_.item = $myDataSource.Item
      
      $rs.SetItemDataSources($reportPath, $_)
      
      Write-Host "Report's DataSource Reference ($($_.Name)): $($_.Item.Reference)";
      }
     
      Write-Host "------------------------"
      }   
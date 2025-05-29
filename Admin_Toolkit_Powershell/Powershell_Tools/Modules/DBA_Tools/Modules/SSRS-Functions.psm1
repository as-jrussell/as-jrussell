#
# SSRS_Functions.psm1
# https://randypaulo.com/2012/02/21/how-to-install-deploy-ssrs-rdl-using-powershell/
<#
.SYNOPSIS
	Installs an RDL file to SQL Reporting Server using Web Service

.DESCRIPTION
	Installs an RDL file to SQL Reporting Server using Web Service

.NOTES
	File Name: Install-SSRSRDL.ps1
	Author: Randy Aldrich Paulo
	Prerequisite: SSRS 2008, Powershell 2.0

.PARAMETER reportName
	Name of report wherein the rdl file will be save as in Report Server.
	If this is not specified it will get the name from the file (rdl) exluding the file extension.

.PARAMETER force
	If force is specified it will create the report folder if not existing
	and overwrites the report if existing.

.EXAMPLE
	Install-SSRSRDL -webServiceUrl "http://[ServerName]/ReportServer/ReportService2005.asmx?WSDL" -rdlFile "C:\Report.rdl" -force

.EXAMPLE
	Install-SSRSRDL "http://[ServerName]/ReportServer/ReportService2005.asmx?WSDL" "C:\Report.rdl" -force

.EXAMPLE
	Install-SSRSRDL "http://[ServerName]/ReportServer/ReportService2005.asmx?WSDL" "C:\Report.rdl" -force -reportName "MyReport"

.EXAMPLE
	Install-SSRSRDL "http://[ServerName]/ReportServer/ReportService2005.asmx?WSDL" "C:\Report.rdl" -force -reportFolder "Reports" -reportName "MyReport"

#>
function Install-SSRSRDL
(
	[Parameter(Position=0,Mandatory=$true)]
	[Alias("url")]
	[string]$webServiceUrl,

	[ValidateScript({Test-Path $_})]
	[Parameter(Position=1,Mandatory=$true)]
	[Alias("rdl")]
	[string]$rdlFile,

	[Parameter(Position=2)]
	[Alias("folder")]
	[string]$reportFolder="",

	[Parameter(Position=3)]
	[Alias("name")]
	[string]$reportName="",

	[switch]$force
)
{
	$ErrorActionPreference="Stop"

	#Create Proxy
	Write-Host "[Install-SSRSRDL()] Creating Proxy, connecting to : $webServiceUrl"
	$ssrsProxy = New-WebServiceProxy -Uri $webServiceUrl -UseDefaultCredential
	$reportPath = "/"

	if($force)
	{
		#Check if folder is existing, create if not found
		try
		{
			$ssrsProxy.CreateFolder($reportFolder, $reportPath, $null)
			Write-Host "[Install-SSRSRDL()] Created new folder: $reportFolder"
		}
		catch [System.Web.Services.Protocols.SoapException]
		{
			if ($_.Exception.Detail.InnerText -match "[^rsItemAlreadyExists400]")
			{
				Write-Host "[Install-SSRSRDL()] Folder: $reportFolder already exists."
			}
			else
			{
				$msg = "[Install-SSRSRDL()] Error creating folder: $reportFolder. Msg: '{0}'" -f $_.Exception.Detail.InnerText
				Write-Error $msg
			}
		}

	}

	#Set reportname if blank, default will be the filename without extension
	if($reportName -eq "") { $reportName = [System.IO.Path]::GetFileNameWithoutExtension($rdlFile);}
	Write-Host "[Install-SSRSRDL()] Report name set to: $reportName"

	try
	{
		#Get Report content in bytes
		Write-Host "[Install-SSRSRDL()] Getting file content (byte) of : $rdlFile"
		$byteArray = gc $rdlFile -encoding byte
		$msg = "[Install-SSRSRDL()] Total length: {0}" -f $byteArray.Length
		Write-Host $msg

		$reportFolder = $reportPath + $reportFolder
		Write-Host "[Install-SSRSRDL()] Uploading to: $reportFolder"

		#Call Proxy to upload report
		$warnings = $ssrsProxy.CreateReport($reportName,$reportFolder,$force,$byteArray,$null)
		if($warnings.Length -eq $null) { Write-Host "[Install-SSRSRDL()] Upload Success." }
		else { $warnings | % { Write-Warning "[Install-SSRSRDL()] Warning: $_" }}
	}
	catch [System.IO.IOException]
	{
		$msg = "[Install-SSRSRDL()] Error while reading rdl file : '{0}', Message: '{1}'" -f $rdlFile, $_.Exception.Message
		Write-Error msg
	}
	catch [System.Web.Services.Protocols.SoapException]
	{
		$msg = "[Install-SSRSRDL()] Error while uploading rdl file : '{0}', Message: '{1}'" -f $rdlFile, $_.Exception.Detail.InnerText
		Write-Error $msg
	}

}
Export-ModuleMember -Function Install-SSRSRDL

<#
.SYNOPSIS
	Uninstalls an RDL file from SQL Reporting Server using Web Service

.DESCRIPTION
	Uninstalls an RDL file from SQL Reporting Server using Web Service

.NOTES
	File Name: Uninstall-SSRSRDL.ps1
	Author: Randy Aldrich Paulo
	Prerequisite: SSRS 2008, Powershell 2.0

.EXAMPLE
	Uninstall-SSRSRDL -webServiceUrl "http://[ServerName]/ReportServer/ReportService2005.asmx?WSDL" -path "MyReport"

.EXAMPLE
	Uninstall-SSRSRDL -webServiceUrl "http://[ServerName]/ReportServer/ReportService2005.asmx?WSDL" -path "Reports/Report1"

#>
function Uninstall-SSRSRDL
(
	[Parameter(Position=0,Mandatory=$true)]
	[Alias("url")]
	[string]$webServiceUrl,

	[Parameter(Position=1,Mandatory=$true)]
	[Alias("path")]
	[string]$reportPath
)
{
	#Create Proxy
	Write-Host "[Uninstall-SSRSRDL()] Creating Proxy, connecting to : $webServiceUrl"
	$ssrsProxy = New-WebServiceProxy -Uri $webServiceUrl -UseDefaultCredential

	#Set Report Folder
	if(!$reportPath.StartsWith("/")) { $reportPath = "/" + $reportPath }

	try
	{

		Write-Host "[Uninstall-SSRSRDL()] Deleting: $reportPath"
		#Call Proxy to upload report
		$ssrsProxy.DeleteItem($reportPath)
		Write-Host "[Uninstall-SSRSRDL()] Delete Success."
	}
	catch [System.Web.Services.Protocols.SoapException]
	{
		$msg = "[Uninstall-SSRSRDL()] Error while deleting report : '{0}', Message: '{1}'" -f $reportPath, $_.Exception.Detail.InnerText
		Write-Error $msg
	}

}
Export-ModuleMember -Function Uninstall-SSRSRDL


function deploy-SSRSold{
    <#
	Import all reports in a given subfolder.
	Compare Datasource in SOURCE and set in TARGET
	
	Doesn't work
	Compare DataSet in SOURCE and set in TARGET

	.\SSRS2008R2-install-ReportFolder -webServiceUrl "http://inms132/ReportServer/ReportService2010.asmx" -reportSource "\\inms130\SSRS2008_DEV" -reportFolder "\DBA" -force
	.\SSRS2008R2-install-ReportFolder -webServiceUrl "http://inms132/ReportServer/ReportService2010.asmx" -reportSource "\\inms130\SSRS2008_DEV" -reportFolder "\DBA\MDW_Reports" -force
	
	.\SSRS2008R2-install-ReportFolder -webServiceUrl "http://inms132/ReportServer/ReportService2010.asmx" -reportSource "\\inms130\SSRS2008_DEV" -reportFolder "\Nystrom\Nystrom_Maps" -force
	.\SSRS2008R2-install-ReportFolder -webServiceUrl "http://inms132/ReportServer/ReportService2010.asmx" -reportSource "\\inms130\SSRS2008_DEV" -reportFolder "\Nystrom\Nystrom_Maps" -force
	.\SSRS2008R2-install-ReportFolder -webServiceUrl "http://inms132/ReportServer/ReportService2010.asmx" -reportSource "\\inms130\SSRS2008_DEV" -reportFolder "\Nystrom\NelsonMonthlyReports" -force
	.\SSRS2008R2-install-ReportFolder -webServiceUrl "http://inms132/ReportServer/ReportService2010.asmx" -reportSource "\\inms130\SSRS2008_DEV" -reportFolder "\Nystrom\NelsonMonthlyReports\Reports" -force

#>

PARAM(
		[Parameter(Position=0)]#,Mandatory=$true)]
		[Alias("url")]
		[string]$webServiceUrl="",

		[Parameter(Position=1)]
		[Alias("source")]
		[string]$reportSource="",
		
		[Parameter(Position=2)]
		[Alias("folder")]
		[string]$reportFolder="",

#		[Parameter(Position=3)]
#		[Alias("name")]
#		[string]$reportName="",

		[switch]$force
	)
	$ErrorActionPreference="Stop"

	#Create Source Proxy
#	IF($reportSource="\\inms132\SSRS2008_TST")
	IF($reportSource="\\inms130\SSRS2008_DEV")
	{
		$ssrsSourceUrl = "http://inms130/ReportServer/ReportService2010.asmx?WSDL"
		$ssrsTargetUrl = "http://inms132/ReportServer/ReportService2010.asmx?WSDL"
	}
	Write-Host " "
	Write-Host "[INSTALL-SSRS-RDL()] Processing all Reports in folder: "$reportSource$reportFolder
	Write-Host "[INSTALL-SSRS-RDL()] Source Proxy, connection to : $ssrsSourceUrl"
	$ssrsSourceProxy = New-WebServiceProxy -Uri $ssrsSourceUrl -Namespace SSRS.ReportingService2010 -UseDefaultCredential ;
	Write-Host "[Install-SSRS-RDL()] Target Proxy, connecting to : $ssrsTargetUrl"
	$ssrsTargetProxy = New-WebServiceProxy -Uri $ssrsTargetUrl -UseDefaultCredential ;
#	$ssrsTargetProxy = New-WebServiceProxy -Uri $ssrsTargetUrl -Namespace SSRS.ReportingService2010 -UseDefaultCredential ;

	$reportPath = "/"
	$myProblemCounter = 0
	
    function SetDataSource #for each report it sets dataSource based on DEV or TEST values.
    {
	     $reports = $ssrsTargetProxy.ListChildren($reportDestination, $true) | Where-Object { $_.Name -eq $reportName -and $_.typeName -eq "Report"}
	     #$reports = $reportName
	 
	     $reports | ForEach-Object {
    #	 Write-Host $_.typeName": " $_.Name
    #	 Write-Host "Object type: " $_.typeName
	     $reportPath = $_.path
    #	 Write-Host $_.typeName"Path: " $reportPath
	     $dataSources = $ssrsTargetProxy.GetItemDataSources($reportPath)
	     $dataSources | ForEach-Object {
	     $proxyNamespace = $_.GetType().Namespace
	     $myDataSource = New-Object ("$proxyNamespace.DataSource")
	     $myDataSource.Name = split-path $targetDataSource -Leaf
    #	 Write-Host "`t`tTarget DataSource: "$myDataSource.Name
	     $myDataSource.Item = New-Object ("$proxyNamespace.DataSourceReference")
	     $myDataSource.Item.Reference = $targetDataSource

	     $_.item = $myDataSource.Item

	     $ssrsTargetProxy.SetItemDataSources($reportPath, $_)

	     Write-Host "`t`tTarget DataSource ($($_.Name)): $($_.Item.Reference)";
	     }

	     Write-Host " "
	     }
    }	

    function SetDataSet #for each report it sets dataSource based on DEV or TEST values.
    #([string]$ClusterName,[string]$GroupName)
    {
	     $reports = $ssrsTargetProxy.ListChildren($reportDestination, $true) | Where-Object { $_.Name -eq $reportName -and $_.typeName -eq "Report"}
	     #$reports = $reportName
	 
	     $reports | ForEach-Object {
	     Write-Host "Report: " $_.Name
	     Write-Host "Object type: " $_.typeName
	     $reportPath = $_.path
	     Write-Host "Report: " $reportPath
	     $dataSources = $ssrsTargetProxy.GetItemReferences($reportPath,"DataSet")
	     $dataSources | ForEach-Object {
	     $proxyNamespace = $_.GetType().Namespace
	     $myDataSource = New-Object ("$proxyNamespace.DataSource")
	     $myDataSource.Name = split-path $targetDataSource -Leaf
	     Write-Host "`t`tTarget DataSource: "$myDataSource.Name
	     $myDataSource.Item = New-Object ("$proxyNamespace.ItemReferenceData")
	     $myDataSource.Item.Reference = $targetDataSource

	     $_.item = $myDataSource.Item

	     $ssrsTargetProxy.SetItemItemReferences($reportPath, $_)

	     Write-Host "`t`tTarget DataSet ($($_.Name)): $($_.Item.Reference)";
	     }

    #	 Write-Host "------------------------"
	     }
    }	

    function updateDataSet #for each report it sets dataSource based on DEV or TEST values.
    #([string]$ClusterName,[string]$GroupName)
    {
    #	param([string]$ClusterName,
    #	[string]$GroupName)
	    #Check for Name/IP Address in provided resource group
    #	 $reports = $ssrsTargetProxy.ListChildren($reportDestination, $true) | Where-Object { $_.Name -eq $reportName}
	     #$reports = $reportName
	 
	     $reports | ForEach-Object {
    #	 Write-Host "Report: " $_.Name
    #	 Write-Host "Object type: " $_.typeName
	     $reportPath = $_.path
    #	 Write-Host "Report: " $reportPath
	     $dataSets = $ssrsTargetProxy.GetItemReferences($reportPath,"DataSet")
	     $dataSets | ForEach-Object {
	     $proxyNamespace = $_.GetType().Namespace
	     $myDataSet = New-Object ("$proxyNamespace.DataSetReference")
	     $myDataSet.Name = split-path $targetDataSource -Leaf
    #	 Write-Host "`t`tTarget DataSource: "$myDataSource.Name
	     $myDataSet.Item = New-Object ("$proxyNamespace.DataSetReference")
	     $myDataSet.Item.Reference = $targetDataSource

	     $_.item = $myDataSource.Item

	     $ssrsTargetProxy.SetItemItemReferences($reportPath, $_)

	     Write-Host "`t`tTarget DataSource ($($_.Name)): $($_.Item.Reference)";
	     }

    #	 Write-Host "------------------------"
	     }
    }	
    
	if($force)
	{
		#Check if folder is existing, create if not found
#		$reportFolder = $reportFolder +"\Reports"
		$parentfolderName = split-path $reportFolder
		$parentfolderName=$parentfolderName -replace "\\","/"
#		Write-Host $parentfolderName
		$dataSourceFolderName = $reportFolder+"/DataSources" -replace "\\","/"
    	$subfolderName = split-path $reportFolder -Leaf
#		Write-Host $subfolderName
		try
		{
			$warning=$ssrsTargetProxy.CreateFolder($subfolderName, $parentfolderName, $null)
			Write-Host "Created new folder: $reportFolder"
		}
		catch [System.Web.Services.Protocols.SoapException]
		{
			if ($_.Exception.Detail.InnerText -match "[^rsItemAlreadyExists400]")
			{
				Write-Host "Folder: $reportFolder already exists."
			}
			else
			{
				$msg = "[Install-SSRSRDL()] Error creating folder: $reportFolder. Msg: '{0}'" -f $_.Exception.Detail.InnerText
				Write-Error $msg
			}
		}
	}

	#Set reportname if blank, default will be the filename without extension
	$sourceFilesPath=$reportSource+$reportFolder
	[array]$FilesToProcess = $(Get-ChildItem $sourceFilesPath *.rdl | sort $_.FullName)
	
	foreach($reportName in $FilesToProcess)
		{
			write-host "`tProcessing $($reportName)"
			$reportCompletePath=$sourceFilesPath+"\"+$reportName
			$reportName = [System.IO.Path]::GetFileNameWithoutExtension($reportName)
			Write-Host "`t`tReport name set to: $reportName"
				
			try
			{
				#Get Report content in bytes
				Write-Host "`t`tGetting file content (byte) of : $reportName"
				$byteArray = gc $reportCompletePath -encoding byte
				$msg = "`t`t`tTotal length: {0}" -f $byteArray.Length
				Write-Host $msg

				$reportFolderPath = $reportPath + $reportFolder
#			Write-Host $reportFolder
				$reportDestination=$reportFolderPath -replace "\\","/"  -replace "//","/"
			Write-Host "`t`tUploading to: $reportDestination"
				$warnings = $null
				#Call Proxy to upload report
				$warnings = $ssrsTargetProxy.CreateCatalogItem("Report",$reportName,$reportDestination,$force,$byteArray,@(),[ref]$warnings)
			Write-Host "`tGather Data Source information:"	
				$dataSource = $ssrsSourceProxy.GetItemDataSources($reportDestination+"/"+$reportName)#|select Name, item #, referencetype
			#	$dataSource = $ssrsSourceProxy.GetItemDataSources("/sEcom/Reports/webAPIs_tranID_missing_in_sEcom-v2")
				$targetDataSource=$dataSourceFolderName+"/"+$dataSource.name
			
			If($dataSource -ne $null)
			{
				Foreach($dSource in $dataSource)
				{
					$targetDataSource=$dataSourceFolderName+"/"+$dSource.name
					#Write-Host "`t`tSource DataSource: "$targetDataSource
					SetDataSource #-option1 " " -option2 " "
				}
			}else
			{
				Write-Host "----------REPORT is BAD----------------"
			}
			Write-Host "`tGather DataSet information: $reportDestination/$reportName"
				#$dataSets = New-Object ("$proxyNamespace.ItemReference")
				$dataSets = $ssrsSourceProxy.GetItemReferences($reportDestination+"/"+$reportName,"DataSet")#|select Name, reference, referencetype
			IF($dataSets -ne $null)
			{
				foreach($DSR in $dataSets)
                    {
						$myMatch = 0
						Write-Host "`t`tSource"$DSR.referenceType"="$DSR.Name " path:"$DSR.Reference
						#$ssrsTargetProxy.SetItemReferences($reportDestination+"/"+$reportName, $DSR)
						$targetSets = $ssrsTargetProxy.GetItemReferences($reportDestination+"/"+$reportName,"DataSet") #| Where-Object { $_.Name -eq $reportName -and $_.typeName -eq "Report"}
						foreach($tDSR in $targetSets)
                    		{
								
								If($tDSR.Reference -eq $DSR.Reference)
									{
										Write-Host "`t`tTarget"$tDSR.referenceType"="$tDSR.Name " path:"$tDSR.Reference
										$myMatch++
										
									}
								ELSEIF($tDSR.Name -eq $DSR.Name)
									{
										Write-Host "`t`tTarget"$tDSR.referenceType"="$tDSR.Name " path:"$tDSR.Reference
										#$myMatch++
										
									}
						
								
							}
						If($myMatch -eq 0)
							{
								Write-Host "PROBLEM ******************************************************************************"
								$myProblemCounter++
							}
						#setDataSet
						#Write-Host "wohoo"
						Write-Host $targetSet.Name
					}
			}
			ELSE
			{
				Write-Host "`t`tDataSet = NONE"
			}

	<#
			If($dataSets -ne $null)
			{
				#relink report to shared datasets
                Write-Host "Relinking $reportSource$reportFolder\$ReportName to Shared Datasets"
                [xml]$XmlReportDefinition = Get-Content $reportSource$reportFolder\$reportName
                $SharedDataSets = $XmlReportDefinition.Report.DataSets.Dataset | where {$_ | get-member SharedDataSet}
                
                $DataSetReferences = @()
                $DataSetReferences += $ssrsSourceProxy.GetItemReferences($reportDestination+"/"+$reportName,"DataSet") | where {$_.Reference -eq $null}
                $newItemReferences = @()
                #foreach ($DataSetReference in $DataSetReferences)
				foreach($DataSetReference in $dataSets)
                    {

                        $proxynamespace =$DataSetReference.Gettype().NameSpace
                        $newItemReference = New-Object ("$proxyNamespace.ItemReference")
                        $RefName = $DataSetReference.Name
                        $ssrsSharedDataSetName = ($sharedDatasets | where {$_.Name -eq $refname}).SharedDataSet.SharedDataSetReference
                        $ssrsSharedDataSet = $allitems | where {($_.Name -eq $ssrsSharedDataSetName) -and ($_.TypeName -eq "DataSet")}
                        $ssrsSharedDataSetPath = $ssrsSharedDataSet.Path
                        $DataSetReference.Reference = $ssrsSharedDataSetPath
                        $newitemreference.Name = $DataSetReference.Name
                        $newitemreference.Reference = $DataSetReference.Reference
                        $newitemreferences += $newItemReference
                    }
                $DataSetReferences += $ssrsTargetProxy.SetItemReferences($reportDestination+"/"+$reportName, $newItemReferences)

			}else
			{	
					Write-Host "`t`t`tNO DataSets"
			}
	#>
			
#				$ssrsTargetProxy.setItemReferences($reportDestination+"/"+$reportName,$datasets)
#			Write-Host "`t`tSetting DataSource: "$dataSource.reference
#				$dataSets = $ssrsSourceProxy.GetItemReferences($reportDestination+"/"+$reportName,"DataSet")|select Name, reference, referencetype
#				foreach($ds in $dataSets)
#				{
#					Write-Host "`t`tDataSets: "$ds.reference	
#				}
#				$trueTarget = $ssrsTargetProxy.listchildren("/",$true) | where-object { $_.typeName -eq "DataSource" -and $_.Name -eq $dataSource.name} | select name, Path
#				$proxyNamespace = $ssrsTargetProxy.GetType().Namespace
#				Write-Host $proxyNamespace
#				$TargetDS = $ssrsTargetProxy.listchildren("/",$true) | where-object { $_.typeName -eq "DataSource" -and $_.Name -eq $dataSource.name} #| select name, Path
#				[SSRS.ReportingService2010.DataSource] $TargetDS = New-Object SSRS.ReportingService2010.DataSource
#				$TargetDS[0].Name = $trueTarget.Name
#				$TargetDS[0].Item = New-Object SSRS.ReportingService2010.DataSourceReference
#				$TargetDS[0].Item.Reference = $trueTarget.Path
#				$TargetDS = $ssrsSourceProxy.GetItemDataSources($reportDestination+"/"+$reportName)
#				$ssrsTargetProxy.SetItemDataSources($reportDestination+"/"+$reportName,@($dataSource))
				if($warnings.Length -eq $null) { Write-Host "[Install-SSRSRDL()] Upload Success." }
				else { $warnings | % { Write-Warning "[Install-SSRSRDL()] Warning: $_" }}
			}
			catch [System.IO.IOException]
			{
				$msg = "[Install-SSRSRDL()] Error while reading rdl file : '{0}', Message: '{1}'" -f $rdlFile, $_.Exception.Message
				Write-Error msg
			}
			catch [System.Web.Services.Protocols.SoapException]
			{
				$msg = "[Install-SSRSRDL()] Error while uploading rdl file : '{0}', Message: '{1}'" -f $rdlFile, $_.Exception.Detail.InnerText
				Write-Error $msg
			}
		}
    #Write-Host "Updating descriptions T-SQL"
    #Invoke-Sqlcmd -ServerInstance "INSQL2\Utility" -h -1 -Query "UPDATE [SSRS2008_TST_ReportServer].[dbo].[catalog] SET Description = dev.description FROM [SSRS2008_TST_ReportServer].[dbo].[catalog] AS TST INNER JOIN [SSRS2008_DEV_ReportServer].[dbo].[catalog] AS DEV ON (TST.Path = DEV.Path AND TST.Name = DEV.Name) WHERE TST.type=2"

	Write-Host " "
	Write-Host "[INSTALL-SSRS-RDL()] Successfully processed all reports in $reportSource$reportFolder"
	Write-Host " "
	Write-Host "Problems encountered: $myProblemCounter"


}
SELECT TOP 100000 MACHINE.NAME "c0", PATCH.Bulletin "c1", PATCH.QNumber "c2", LATEST_PATCH_STATUS.SCANDATE "c3", PRODUCT_PATCH_CVE2.MAXCVSS "c4", PATCH_TYPE.VALUE "c5", VENDOR_SEVERITY.VALUE "c6", DEPLOY_STATE.Value "c7", 
DEPLOY_STATE.Description "c8",
CASE WHEN PATCH_DEPLOYMENT.ResultCode = 3010 THEN 'OK - Pending Reboot'
WHEN PATCH_DEPLOYMENT.ResultCode = 0 THEN 'Executed - Fine'
WHEN PATCH_DEPLOYMENT.ResultCode = 1058 THEN 'Failed Deployment'
WHEN PATCH_DEPLOYMENT.ResultCode IS NULL THEN 'Failed Download'
WHEN PATCH_DEPLOYMENT.ResultCode = 2147483647 THEN 'Failed to Copy the File'
WHEN PATCH_DEPLOYMENT.ResultCode = 2359302 THEN 'Successful'
WHEN PATCH_DEPLOYMENT.ResultCode = 17025 THEN 'Successful'
ELSE
'Unknown'
END "c9", PATCH_DEPLOYMENT.DeployStartedOn "c10" 
FROM REPORTING2.MACHINE MACHINE 
LEFT OUTER JOIN DBO.xtrCURRENTPATCHSTATUS LATEST_PATCH_STATUS ON MACHINE.ID = LATEST_PATCH_STATUS.MACHINEID 
LEFT OUTER JOIN REPORTING2.DETECTEDPATCHSTATE DETECTED_PATCH_STATE ON LATEST_PATCH_STATUS.PATCHID = DETECTED_PATCH_STATE.PATCHID AND LATEST_PATCH_STATUS.PRODUCTID = DETECTED_PATCH_STATE.PRODUCTID AND LATEST_PATCH_STATUS.ASSESSEDMACHINESTATEID = DETECTED_PATCH_STATE.AssessedMachineStateId 
LEFT OUTER JOIN REPORTING2.PATCH PATCH ON DETECTED_PATCH_STATE.PATCHID = PATCH.Id 
LEFT OUTER JOIN REPORTING2.VendorSeverity VENDOR_SEVERITY ON PATCH.VendorSeverityId = VENDOR_SEVERITY.ID 
LEFT OUTER JOIN REPORTING2.PATCHTYPE PATCH_TYPE ON PATCH.PatchTypeId = PATCH_TYPE.ID 
LEFT OUTER JOIN (SELECT PAT.PatchId AS PatchID, PAT.ProductId AS ProductID, MAX(CV.CVSSv3) AS CVSSv3, MAX(CV.CVSSv2) as CVSSv2,
 (CASE WHEN MAX(CV.CVSSv3) > MAX(CV.CVSSv2) THEN
 MAX(CV.CVSSv3)
 ELSE
 MAX(CV.CVSSv2)
 END) MAXCVSS
  FROM REPORTING2.PatchAppliesTo PAT 
 
 LEFT OUTER JOIN Reporting2.CVE CV 
  ON PAT.CveId = CV.Id
  GROUP BY PAT.PatchId, PAT.ProductId) PRODUCT_PATCH_CVE2 ON DETECTED_PATCH_STATE.PATCHID = PRODUCT_PATCH_CVE2.PATCHID AND DETECTED_PATCH_STATE.PRODUCTID = PRODUCT_PATCH_CVE2.PRODUCTID 
  LEFT OUTER JOIN REPORTING2.InstallState INSTALL_STATE ON DETECTED_PATCH_STATE.InstallStateId = INSTALL_STATE.ID 
  LEFT OUTER JOIN REPORTING2.PATCHDEPLOYMENT PATCH_DEPLOYMENT ON DETECTED_PATCH_STATE.Id = PATCH_DEPLOYMENT.DetectedPatchStateId 
  LEFT OUTER JOIN REPORTING2.DEPLOYSTATE DEPLOY_STATE ON PATCH_DEPLOYMENT.DeployStateId = DEPLOY_STATE.Id 
  LEFT OUTER JOIN REPORTING2.AssessedMachineState ASSESSED_MACHINE_STATE ON LATEST_PATCH_STATUS.ASSESSEDMACHINESTATEID = ASSESSED_MACHINE_STATE.ID AND LATEST_PATCH_STATUS.MACHINEID = ASSESSED_MACHINE_STATE.MachineId   
  WHERE ((CASE WHEN DETECTED_PATCH_STATE.InstalledOn IS NOT NULL AND (INSTALL_STATE.VALUE != 'Installed') THEN 'Installed' ELSE INSTALL_STATE.VALUE END = 'Missing Patch') 
    AND (ASSESSED_MACHINE_STATE.AssessedOn BETWEEN '2022-03-21T05:00:00' AND '2022-05-05T04:59:59') AND (MACHINE.LastPatchMachineGroupName LIKE 'Production%'))  
	ORDER BY "c0" ASC
Add-LocalGroupMember -Group "Administrators" -Member  "ELDREDGE_A\UnitracSyncService", "ELDREDGE_A\Unitrac System Administrators", "ELDREDGE_A\UBSService"
Remove-LocalGroupMember -Group "Administrators" -Member  "ELDREDGE_A\SYS ADMINS"


Add-LocalGroupMember -Group "Remote Desktop Users" -Member "ELDREDGE_A\MrBuild", "ELDREDGE_A\Unitrac Development Team"



Add-LocalGroupMember -Group "Users" -Member  "ELDREDGE_A\WFLService"


Remove-LocalGroupMember -Group "Administrators" -Member  "ELDREDGE_A\bpaquette","ELDREDGE_A\egold","ELDREDGE_A\mfuniciello","ELDREDGE_A\SQL2000", "ELDREDGE_A\UniTracSyncService"



Add-LocalGroupMember -Group "Users" -Member  "ELDREDGE_A\bpaquette","ELDREDGE_A\egold","ELDREDGE_A\mfuniciello","ELDREDGE_A\SQL2000", "ELDREDGE_A\UniTracSyncService"


Get-LocalGroupMember -Group "Administrators"
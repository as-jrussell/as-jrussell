Add-LocalGroupMember -Group "Administrators" -Member  "ELDREDGE_A\UnitracSyncService", "ELDREDGE_A\Unitrac System Administrators", "ELDREDGE_A\UBSService"
Remove-LocalGroupMember -Group "Administrators" -Member  "ELDREDGE_A\SYS ADMINS"


Add-LocalGroupMember -Group "Remote Desktop Users" -Member "ELDREDGE_A\MrBuild", "ELDREDGE_A\Unitrac Development Team"
SELECT
 n.environment
 , n.BusinessFunction
 , si.StatusName

,n.NodeID

,n.Caption
,n.DNS

,n.IP_Address

,n.Vendor

,n.MachineType

,n.Description

,n.SNMPVersion

,n.Community

FROM Nodes n

INNER JOIN StatusInfo si ON si.StatusId = n.[Status]

LEFT JOIN VIM_VirtualMachines vm ON vm.NodeID = n.NodeID

LEFT JOIN APM_HardwareInfo hi ON hi.NodeID = n.NodeID

WHERE

  n.UnManaged = '0' --not UnManaged

  AND BusinessApplication = 'Unitrac'
  --and dns like '%Unitrac-WH006%'
  and caption like 'Edi%'

order by n.environment, n.businessfunction ASC




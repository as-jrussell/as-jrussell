---Need to connected to UTSTAGE-RPT01

USE ReportServer

select C.Name, C.Path, S.ExtensionSettings, U.UserName
 from catalog C
join subscriptions S on C.ItemID = S.Report_OID
join Users U on U.UserID = S.OwnerID
where itemid IN ('405F76E7-4753-47BE-A78C-FD87872106B7','38A4566E-309B-47BC-B5AA-F6FDE6DFC2A9')

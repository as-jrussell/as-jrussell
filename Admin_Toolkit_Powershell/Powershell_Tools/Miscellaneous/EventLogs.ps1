

Get-EventLog	 -ComputerName	Unitrac-WH18 -LogName Application -Newest 25  -EntryType Information -InstanceId 6006 |ft -AutoSize -Wrap | out-string -width 4096 


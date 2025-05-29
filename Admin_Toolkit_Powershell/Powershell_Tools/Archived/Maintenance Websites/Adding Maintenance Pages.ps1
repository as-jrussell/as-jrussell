
invoke-command -ComputerName UniTrac-QP01 -scriptblock {stop-website  -Name "QuickPoint"}

invoke-command -ComputerName UniTrac-QP01 -scriptblock {stop-website  -Name "QuickPoint_https_redirect"}

invoke-command -ComputerName websvc-dmz -scriptblock {stop-website  -Name "MyInsInfo v1"}

invoke-command -ComputerName websvc-dmz -scriptblock {stop-website  -Name "MyInsInfo v2 20170518"}



invoke-command -ComputerName UniTrac-QP01 -scriptblock {start-website  -Name "QPMaintanencePage"}

invoke-command -ComputerName websvc-dmz -scriptblock {start-website  -Name "BSSMaintenancev1"}

invoke-command -ComputerName websvc-dmz -scriptblock {start-website  -Name "BSSMaintenancev2"}

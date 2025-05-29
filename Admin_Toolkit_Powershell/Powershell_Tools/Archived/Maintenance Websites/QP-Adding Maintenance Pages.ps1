
invoke-command -ComputerName UniTrac-QP01 -scriptblock {stop-website  -Name "QuickPoint"}

invoke-command -ComputerName UniTrac-QP01 -scriptblock {stop-website  -Name "QuickPoint_https_redirect"}




invoke-command -ComputerName UniTrac-QP01 -scriptblock {start-website  -Name "QPMaintanencePage"}


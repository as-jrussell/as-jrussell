
invoke-command -ComputerName UniTrac-QP01 -scriptblock {stop-website  -Name "QPMaintanencePage"}





invoke-command -ComputerName UniTrac-QP01 -scriptblock {start-website  -Name "QuickPoint"}

invoke-command -ComputerName UniTrac-QP01 -scriptblock {start-website  -Name "QuickPoint_https_redirect"}

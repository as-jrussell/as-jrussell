Invoke-Command -ComputerName "UTQA2-APP1" -ScriptBlock { Restart-WebAppPool -Name "UniTracServerAppPool" }

Invoke-Command -ComputerName "UTSTAGE-APP2" -ScriptBlock { Restart-WebAppPool -Name "UniTracServerAppPool" }


Invoke-Command -ComputerName "Unitrac-PreProd" -ScriptBlock { Restart-WebAppPool -Name "UniTracServerAppPool" }




param (
    [string]$ServerName = "SQLSPRDAWEC08.colo.as.local",
    [string]$ADUsername = "ELDREDGE_A\IT Sys Admins"


)

Write-Host "Checking local group memberships for $ADUsername on $ServerName..." -ForegroundColor Cyan

try {
    $groups = Invoke-Command -ComputerName $ServerName -ScriptBlock {
        param($User)
        $foundGroups = @()

        # Get all local groups
        $localGroups = Get-LocalGroup

        foreach ($group in $localGroups) {
            $members = Get-LocalGroupMember -Group $group.Name -ErrorAction SilentlyContinue
            foreach ($member in $members) {
                if ($member.Name -eq $User) {
                    $foundGroups += $group.Name
                }
            }
        }

        return $foundGroups
    } -ArgumentList $ADUsername

    if ($groups.Count -gt 0) {
        Write-Host "$ADUsername is a member of the following local groups on ${ServerName}:" -ForegroundColor Green
        $groups | ForEach-Object { Write-Host " - $_" }
    } else {
        Write-Host "$ADUsername is not a member of any local groups on ${ServerName}." -ForegroundColor Yellow
    }
}
catch {
    Write-Host "Something went boom: $($_.Exception.Message)" -ForegroundColor Red
}
# Import the Active Directory module
Import-Module ActiveDirectory

# Define the common part of the group names
# Define the common part of the group names
$groupNamePattern = "SQL_*"  # Use * as a wildcard to match any characters after the common part

# Specify the output file path
$outputFilePath = "C:\Users\jrussell\Downloads\File.txt"

# Get all groups that match the pattern
$matchingGroups = Get-ADGroup -Filter { Name -like $groupNamePattern }

# Initialize an array to store the progress objects
$progressItems = @()

# Initialize progress tracking
$totalGroups = $matchingGroups.Count
$currentGroupIndex = 0

# Iterate through matching groups
foreach ($group in $matchingGroups) {
    $currentGroupIndex++
    $groupProgress = [math]::Round(($currentGroupIndex / $totalGroups) * 100, 2)
    $progressItem = [PSCustomObject]@{
        GroupName = $group.Name
        Progress = $groupProgress
    }

    $progressItems += $progressItem
}

# Show the progress bar
$progressItems | ForEach-Object {
    Write-Progress -Activity "Processing Group $($_.GroupName)" -PercentComplete $_.Progress
    Start-Sleep -Milliseconds 200  # Add a short delay to show progress updates
}

# Rest of your script...
# (Group processing, user checks, output file generation, etc.)

Write-Progress -Completed

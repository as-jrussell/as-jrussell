# Parameters
param(
    [switch]$Verbose,      # Enables verbose mode to show files as they are deleted
    [switch]$WhatIf        # Shows what would be deleted without actually deleting
)

# List of folders to clean
$folders = @(
    "C:\openec\edi\data\bat_in",
    "C:\openec\tlink4\data\exchange\Allied_Solutions\A-LEXNEX\FTP\inbox\decrypted\archive",
    "C:\openec\tlink4\data\exchange\Allied_Solutions\A-LEXNEX\FTP\inbox\encrypted\archive",
    "C:\openec\tlink4\data\exchange\Allied_Solutions\A-LEXNEX\FTP\inbound\encrypted\archive",
    "C:\openec\tlink4\data\exchange\Allied_Solutions\A-LEXNEX\Outbound\Preprocessing_997\temp",
    "C:\openec\tlink4\data\exchange\Allied_Solutions\A-LEXNEX\Outbound\Preprocessing_997\archive"
)

# Define the date threshold for deletion (6 months ago)
$dateThreshold = (Get-Date).AddMonths(-6)

# Function to delete old files
function Delete-OldFiles {
    param (
        [string]$folder
    )

    # Check if the folder exists
    if (-not (Test-Path $folder)) {
        Write-Warning "Folder '$folder' does not exist. Skipping..."
        return
    }

    # Get files older than 6 months
    $files = Get-ChildItem -Path $folder -File | Where-Object { $_.CreationTime -lt $dateThreshold }

    if ($WhatIf) {
        # Show what would be deleted
        foreach ($file in $files) {
            Write-Output "Would delete: $($file.FullName) (Created: $($file.CreationTime))"
        }
    } else {
        # Perform deletion and show details if Verbose is enabled
        foreach ($file in $files) {
            if ($Verbose) {
                Write-Output "Deleting: $($file.FullName) (Created: $($file.CreationTime))"
            }
            Remove-Item -Path $file.FullName -Force
        }
    }
}

# Process each folder
foreach ($folder in $folders) {
    Delete-OldFiles -folder $folder
}

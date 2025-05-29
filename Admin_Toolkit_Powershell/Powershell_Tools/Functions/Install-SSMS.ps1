function Install-SSMS {
    param (
        [string]$RemoteServer
    )

    # Define the installer path and download URL
    $installerPath = "\\DFSSPRDAWFS01\Infotechshare\Software\Microsoft\SQL Management Studio\SSMS-19.0.2.exe"
   # $downloadUrl = "https://aka.ms/ssmsfullsetup"

    # Step 1: Download the SSMS installer on the remote server
    Invoke-Command -ComputerName $RemoteServer -ScriptBlock {
        param($url, $path)
        
        # Create temp directory if it doesn't exist
        if (-Not (Test-Path -Path (Split-Path -Path $path -Parent))) {
            New-Item -ItemType Directory -Path (Split-Path -Path $path -Parent) -Force
        }
        
        # Download the installer
        Invoke-WebRequest -Uri $url -OutFile $path
    } -ArgumentList  $installerPath

    # Step 2: Install SSMS on the remote server
    Invoke-Command -ComputerName $RemoteServer -ScriptBlock {
        param($path)
        
        # Start the installer with silent installation
        Start-Process -FilePath $path -ArgumentList "/quiet" -Wait
    } -ArgumentList $installerPath

    # Step 3: Clean up the installer after installation (optional)
    Invoke-Command -ComputerName $RemoteServer -ScriptBlock {
        param($path)
        
        # Remove the installer
        Remove-Item -Path $path -Force
    } -ArgumentList $installerPath

    Write-Host "SSMS installation completed on $RemoteServer."
}

# Usage example:
# Install-SSMS -RemoteServer "SQLSDEVAWEC07"

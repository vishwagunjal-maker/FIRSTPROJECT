Function Invoke-Sync365 {
    [CmdletBinding()]
    [Alias('Sync365')]
    Param (
        [Parameter(Mandatory = $false)]
        [String]$AzureSyncServer,

        [Parameter(Mandatory = $false)]
        [ValidateSet("delta", "initial")]
        [String]$Policy = 'delta'
    )

    # Use parameter if provided, otherwise fallback to environment variable
    if (-not $AzureSyncServer) {
        $AzureSyncServer = $env:AzureSyncServer
    } else {
        # Optionally, set the env variable for future use (remove if not desired)
        [Environment]::SetEnvironmentVariable("AzureSyncServer", "$AzureSyncServer", "User")
    }

    if ($AzureSyncServer) {
        Invoke-Command -ComputerName $AzureSyncServer -ScriptBlock {
            param($RemotePolicy)
            Start-ADSyncSyncCycle -PolicyType $RemotePolicy
        } -ArgumentList $Policy
    } else {
        Write-Warning "You must specify the Azure Sync Server using the 'AzureSyncServer' parameter or set the 'AzureSyncServer' environment variable first!"
    }
}

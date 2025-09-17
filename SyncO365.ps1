Function Invoke-Sync365 {
    [Cmdletbinding()]
    [Alias('Sync365')]
    Param (
        [Parameter(Mandatory = $false)]
        [String]$AzureSyncServer,

        [Parameter(Mandatory = $false)]
        [ValidateSet("delta", "initial")]
        [String]$Policy = 'delta'
    )

    if ($env:AzureSyncServer) {
        Invoke-Command -ComputerName $env:AzureSyncServer -ScriptBlock {
            Start-ADSyncSyncCycle -PolicyType $Policy
        }
    } else {
        Write-Warning "You must specify the Azure Sync Server using the 'AzureSyncServer' parameter first!"
        $env:AzureSyncServer = $AzureSyncServer
        [Environment]::SetEnvironmentVariable("AzureSyncServer", "$AzureSyncServer", "User")
    }
}

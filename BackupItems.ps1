#https://learn.microsoft.com/en-us/dotnet/api/microsoft.azure.commands.recoveryservices.backup.cmdlets.models.workloadtype?view=az-ps-latest

$subs=Get-AzSubscription

foreach($sub in $subs){
    $vaults = Get-AzRecoveryServicesVault
    foreach($vault in $vaults){
        $Containers = Get-AzRecoveryServicesBackupContainer -ContainerType AzureVM  -VaultId $vault.ID
        foreach($Container in $Containers ){
            $items = Get-AzRecoveryServicesBackupItem -Container $Container -WorkloadType AzureVM -VaultId $vault.ID
            foreach($item in $items){
                Write-Host "$($sub.Name),$($vault.Name),$($Container.FriendlyName),$($item.ProtectionPolicyName),$($item.WorkloadType),$($item.ProtectionStatus),$($item.DeleteState),$($item.HealthStatus)"
            }
        }

        $Containers = Get-AzRecoveryServicesBackupContainer -ContainerType AzureVMAppContainer  -VaultId $vault.ID
        foreach($Container in $Containers ){
            $items = Get-AzRecoveryServicesBackupItem -Container $Container -WorkloadType MSSQL -VaultId $vault.ID
            foreach($item in $items){
                Write-Host "$($sub.Name),$($vault.Name),$($Container.FriendlyName),$($item.ProtectionPolicyName),$($item.WorkloadType),$($item.ProtectionStatus),$($item.DeleteState),$($item.HealthStatus)"
            }
            $items = Get-AzRecoveryServicesBackupItem -Container $Container -WorkloadType SAPHanaDatabase -VaultId $vault.ID
            foreach($item in $items){
                Write-Host "$($sub.Name),$($vault.Name),$($Container.FriendlyName),$($item.ProtectionPolicyName),$($item.WorkloadType),$($item.ProtectionStatus),$($item.DeleteState),$($item.HealthStatus)"
            }
        }

        $Containers = Get-AzRecoveryServicesBackupContainer -ContainerType AzureStorage  -VaultId $vault.ID
        foreach($Container in $Containers ){
            $items = Get-AzRecoveryServicesBackupItem -Container $Container -WorkloadType AzureFiles -VaultId $vault.ID
            foreach($item in $items){
                Write-Host "$($sub.Name),$($vault.Name),$($Container.FriendlyName),$($item.ProtectionPolicyName),$($item.WorkloadType),$($item.ProtectionStatus),$($item.DeleteState),$($item.HealthStatus)"
            }
            $items = Get-AzRecoveryServicesBackupItem -Container $Container -WorkloadType AzureFiles -VaultId $vault.ID
            foreach($item in $items){
                Write-Host "$($sub.Name),$($vault.Name),$($Container.FriendlyName),$($item.ProtectionPolicyName),$($item.WorkloadType),$($item.ProtectionStatus),$($item.DeleteState),$($item.HealthStatus)"
            }
        }
    }
}
Write-Host "sub.Name,vault.Name,Container.FriendlyName,item.ProtectionPolicyName,item.WorkloadType,item.ProtectionStatus,item.DeleteState,item.HealthStatus"

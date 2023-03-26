$subs=Get-AzSubscription
#Write-Output "Subscription,ResourceGroup,Name,Kind,NumberOfSites,Reserved,sku.Name,sku.Tiere,sku.Family,sku.Capacity"
foreach($sub in $subs)
{
    Select-AzSubscription -Subscription $sub | Out-Null
    #Write-Output "`nChecking subscription : $($sub.Name) ($($sub.id))"

    $appServicePlans = Get-AzAppServicePlan

    foreach($appServicePlan in $appServicePlans)
    {
        Write-Host "-->$($sub.Name),$($appServicePlan.ResourceGroup ),$($appServicePlan.Name),$($appServicePlan.Kind),$($appServicePlan.NumberOfSites),$($appServicePlan.Reserved),$($appServicePlan.sku.Name),$($appServicePlan.sku.Tier),$($appServicePlan.sku.Family),$($appServicePlan.sku.Capacity)"
    }
}

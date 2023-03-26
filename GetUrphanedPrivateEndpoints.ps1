#$BadEndpoints = Get-AzPrivateEndpoint -ResourceGroupName "rg-mygroup-dev" | Where-Object {$_.PrivateLinkServiceConnections[0].PrivateLinkServiceConnectionState.Status -eq "Disconnected"}



$subs=Get-AzSubscription

foreach($sub in $subs)
{
    Select-AzSubscription -Subscription $sub | Out-Null
    #Write-Output "`nChecking subscription : $($sub.Name) ($($sub.id))"

    $privEnds = Get-AzPrivateEndpoint

    foreach($privEnd in $privEnds)
    {
        if($privEnd.PrivateLinkServiceConnections[0].PrivateLinkServiceConnectionState.Status -eq "Disconnected"){
            Write-Output "-->$($sub.Name),$($privEnd.ResourceGroupName ),$($privEnd.Name)"
        }

    }
}

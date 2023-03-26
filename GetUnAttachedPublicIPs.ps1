$subs=Get-AzSubscription

foreach($sub in $subs)
{
    Select-AzSubscription -Subscription $sub | Out-Null
    #Write-Output "`nChecking subscription : $($sub.Name) ($($sub.id))"

    $pubIPs = Get-AzPublicIpAddress
    $NATGWs = Get-AzNatGateway
    foreach($pubIP in $pubIPs)
    {
        if($pubIP.IpConfiguration -eq $null)
        {
            Write-Output "-->$($sub.Name),$($pubIP.ResourceGroupName ),$($pubIP.name)"
            $foundWithResource = $false
            foreach($NATGW in $NATGWs)
            {
                foreach($GWPubIP in $NATGW.PublicIpAddresses)
                {
                    if($GWPubIP.Id -eq $PubIP.id)
                    {
                        Write-Output "!!!!!!!!!!!!!!!    IP $($pubIP.name) used by NAT Gateway $($NATGW.Name)"
                        $foundWithResource = $true
                    }
                    else{
                        
                    }
                }
            }
        }
    }
}

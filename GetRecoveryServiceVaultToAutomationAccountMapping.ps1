<#
Using the "UpdateAutomationAccount.ps1" script provided by MS as a template. I have modified it to be able to make an inventory for the Recovery Service Vaults mapping to Automation Accounts and Schedules. 
You just have to:
- Add the script as a 5.1 powershell Runbook 
- In the Automation account hosting this inventory runbook, Add Az.Accounts & Az.RecoveryServices modules under the  shared resources modules 
- The Runbook will be using System Assighned Identity, so make sure you have enabled it and gave it Roles necessary to read all subscriptions.
- The Script will make a very primitive csv output with all details
#>

$TaskId = [guid]::NewGuid().ToString()
$SubscriptionId = "00000000-0000-0000-0000-000000000000"
$AsrApiVersion = "2021-12-01"
$ArmEndPoint = "https://management.azure.com"
$AadAuthority = "https://login.windows.net/"
$AadAudience = "https://management.core.windows.net/"
$AzureEnvironment = "AzureCloud"
$Timeout = "160"
$AuthenticationType = "SystemAssignedIdentity"
function Throw-TerminatingErrorMessage
{
        Param
    (
        [Parameter(Mandatory=$true)]
        [String]
        $Message
        )
    throw ("Message: {0}, TaskId: {1}.") -f $Message, $TaskId
}
function Write-Tracing
{
        Param
    (
        [Parameter(Mandatory=$true)]
        [ValidateSet("Informational", "Warning", "ErrorLevel", "Succeeded", IgnoreCase = $true)]
                [String]
        $Level,
        [Parameter(Mandatory=$true)]
        [String]
        $Message,
            [Switch]
        $DisplayMessageToUser
        )
    Write-Output $Message
}
function Write-InformationTracing
{
        Param
    (
        [Parameter(Mandatory=$true)]
        [String]
        $Message
        )
    Write-Tracing -Message $Message -Level Informational -DisplayMessageToUser
}

function Initialize-SubscriptionId()
{
    try
    {
        $Tokens = $VaultResourceId.SubString(1).Split("/")
        $Count = 0
                $ArmResources = @{}
        while($Count -lt $Tokens.Count)
        {
            $ArmResources[$Tokens[$Count]] = $Tokens[$Count+1]
            $Count = $Count + 2
        }
                return $ArmResources["subscriptions"]
    }
    catch
    {
        Write-Tracing -Level ErrorLevel -Message ("Initialize-SubscriptionId: failed with [Exception: {0}]." -f $_.Exception) -DisplayMessageToUser
        throw
    }
}
function Invoke-InternalRestMethod($Uri, $Headers, [ref]$Result)
{
    $RetryCount = 0
    $MaxRetry = 3
    do
    {
        try
        {
            $ResultObject = Invoke-RestMethod -Uri $Uri -Headers $Headers
            ($Result.Value) += ($ResultObject)
            break
        }
        catch
        {
            Write-InformationTracing ("Retry Count: {0}, Exception: {1}." -f $RetryCount, $_.Exception)
            $RetryCount++
            if(!($RetryCount -le $MaxRetry))
            {
                throw
            }
            Start-Sleep -Milliseconds 2000
        }
    }while($true)
}
function Invoke-InternalWebRequest($Uri, $Headers, $Method, $Body, $ContentType, [ref]$Result)
{
    $RetryCount = 0
    $MaxRetry = 3
    do
    {
        try
        {
            $ResultObject = Invoke-WebRequest -Uri $UpdateUrl -Headers $Header -Method 'PATCH' `
                -Body $InputJson  -ContentType "application/json" -UseBasicParsing
            ($Result.Value) += ($ResultObject)
            break
        }
        catch
        {
            Write-InformationTracing ("Retry Count: {0}, Exception: {1}." -f $RetryCount, $_.Exception)
            $RetryCount++
            if(!($RetryCount -le $MaxRetry))
            {
                throw
            }
            Start-Sleep -Milliseconds 2000
        }
    }while($true)
}
function Get-Header([ref]$Header, $AadAudience){
    try
    {
        $Header.Value['Content-Type'] = 'application\json'
        #Write-InformationTracing ("The Authentication Type is system Assigned Identity based.")
        $endpoint = $env:IDENTITY_ENDPOINT
        $endpoint  
        $Headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]" 
        $Headers.Add("X-IDENTITY-HEADER", $env:IDENTITY_HEADER) 
        $Headers.Add("Metadata", "True")   
        $authenticationResult = Invoke-RestMethod -Method Get -Headers $Headers -Uri ($endpoint +'?resource=' +$AadAudience)
        $accessToken = $authenticationResult.access_token
        $Header.Value['Authorization'] = "Bearer " + $accessToken
        $Header.Value["x-ms-client-request-id"] = $TaskId + "/" + (New-Guid).ToString() + "-" + (Get-Date).ToString("u")
    }
    catch
    {
        $ErrorMessage = ("Get-BearerToken: failed with [Exception: {0}]." -f $_.Exception)
        Write-Tracing -Level ErrorLevel -Message $ErrorMessage -DisplayMessageToUser
        Throw-TerminatingErrorMessage -Message $ErrorMessage
    }
}

$OperationStartTime = Get-Date

$JobsInProgressList = @()
$JobsCompletedSuccessList = @()
$JobsCompletedFailedList = @()
$JobsFailedToStart = 0
$JobsTimedOut = 0
$Header = @{}
$AzureRMProfile = Get-Module -ListAvailable -Name AzureRM.Profile | Select Name, Version, Path
$AzureRmProfileModulePath = Split-Path -Parent $AzureRMProfile.Path
Add-Type -Path (Join-Path $AzureRmProfileModulePath "Microsoft.IdentityModel.Clients.ActiveDirectory.dll")


<#
$Conn = Get-AutomationConnection -Name AzureRunAsConnection
Add-AzAccount -ServicePrincipal -Tenant $Conn.TenantID `
    -ApplicationID $Conn.ApplicationID -CertificateThumbprint $Conn.CertificateThumbprint
    #>

try
{
    "Logging in to Azure..."
    Connect-AzAccount -Identity
}
catch {
    Write-Error -Message $_.Exception
    throw $_.Exception
}

    
Write-InformationTracing  "RecoveryValutName,RecoveryValutID,ResourceGroup,Subscription,RVault Maooing State,RVault Mapping agentAutoUpdateStatus,RVault Mapping automationAccountAuthenticationType,RVault Mapping automationAccountArmId,RVault Mapping scheduleName,RVault Mapping jobScheduleName,RVault Mapping instanceType"
$subscriptions = Get-AzSubscription 
foreach($sub in $subscriptions){
    $Context = Set-AzContext -Subscription $sub.Name
    $RecoveryServicesVaults = Get-AzRecoveryServicesVault
    foreach($RV in $RecoveryServicesVaults){
        $VaultResourceId = $RV.ID
        try
		{
			$ContainerMappingListUrl = $ArmEndPoint + $VaultResourceId + "/replicationProtectionContainerMappings" + "?api-version=" + $AsrApiVersion
			Get-Header ([ref]$Header) $AadAudience
			$Result = @()
			Invoke-InternalRestMethod -Uri $ContainerMappingListUrl -Headers $header -Result ([ref]$Result)
			$ContainerMappings = $Result[0]
			foreach($Mapping in $ContainerMappings.Value)
			{            
				if( $Mapping.properties.providerSpecificDetails )
				{
				    Write-InformationTracing  "$($RV.Name),$($RV.ID),$($RV.ResourceGroupName),$($sub.Name),$($Mapping.Properties.State),$($Mapping.properties.providerSpecificDetails.agentAutoUpdateStatus),$($Mapping.properties.providerSpecificDetails.automationAccountAuthenticationType),$($Mapping.properties.providerSpecificDetails.automationAccountArmId),$($Mapping.properties.providerSpecificDetails.scheduleName),$($Mapping.properties.providerSpecificDetails.jobScheduleName),$($Mapping.properties.providerSpecificDetails.instanceType)"
                }
                else
                {
                    Write-InformationTracing  "$($RV.Name),$($RV.ID),$($RV.ResourceGroupName),$($sub.Name),$($Mapping.Properties.State),null,null,null,null,null,null"
                }
			}
		}
		catch
		{
			$ErrorMessage = ("Get-ProtectionContainerToBeModified: failed with [Exception: {0}]." -f $_.Exception)
			Write-Tracing -Level ErrorLevel -Message $ErrorMessage -DisplayMessageToUser
			Throw-TerminatingErrorMessage -Message $ErrorMessage
		}
    }
}

if($JobsTimedOut -gt  0)
{
    $ErrorMessage = "One or more modify cloud pairing jobs has timedout."
    Write-Tracing -Level ErrorLevel -Message ($ErrorMessage)
    Throw-TerminatingErrorMessage -Message $ErrorMessage
}
elseif($JobsCompletedSuccessList.Count -ne $ContainerMappingList.Count)
{
    $ErrorMessage = "One or more modify cloud pairing jobs failed."
    Write-Tracing -Level ErrorLevel -Message ($ErrorMessage)
    Throw-TerminatingErrorMessage -Message $ErrorMessage
}
Write-Tracing -Level Succeeded -Message ("Recovery Service Vault to Automation Account Mapping Inventory Completed.") -DisplayMessageToUser

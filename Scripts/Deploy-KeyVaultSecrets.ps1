#
# Deploy_KeyVaultSecrets.ps1
#

Param(
    [string] $ResourceGroupName,   
    [string] $KeyVaultName,
    [string] $SecretJson
)

function CreateOrUpdate-Secret
{
	Param(
        [string] $KeyVaultName,
		[string] $SecretName,
		[string] $SecretValue
	)
    
    $currentSecret = Get-AzureKeyVaultSecret -VaultName $KeyVaultName -Name $SecretName
    
    if ( ($currentSecret -eq $null) -or ($currentSecret.SecretValueText -ne $SecretValue) ) 
    {
        Write-Host "$SecretName doesn't exist/has changed. Setting new value."
         
        $secret = ConvertTo-SecureString -String $SecretValue -AsPlainText -Force
        $currentSecret = Set-AzureKeyVaultSecret -VaultName $KeyVaultName -Name $SecretName -SecretValue $secret
    }

    $outVariableName = "KeyVault.Secrets.$SecretName.Url"
    $secretUrl = $currentSecret.Id

    Write-Host "Secret = $outVariableName, URL = $secretUrl"

    Write-Host "##vso[task.setvariable variable=$outVariableName]$secretUrl"
}

$secrets = $SecretJson | ConvertFrom-Json

foreach ($secret in $secrets)
{
    $secretName = $secret.SecretName
    $secretValue = $secret.SecretValue

    CreateOrUpdate-Secret -KeyVaultName $KeyVaultName -SecretName $secretName -SecretValue $secretValue
}
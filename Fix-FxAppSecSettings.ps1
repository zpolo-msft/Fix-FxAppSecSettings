$FxName = Read-Host "Please enter the name of your Function App."
$RgName = Read-Host "Please enter the name of the Resource Group in which your Function App resides."
$SubscriptionId = Read-Host "Please enter your Subscription ID."

# Logging into Azure account and setting subscription
az login 
az account set --subscription $SubscriptionId

# Setting Fx App settings
az functionapp config set --resource-group $RgName --name $FxName --ftps-state FtpsOnly --http20-enabled true --min-tls-version 1.2 | Out-Null
az functionapp update -g $RgName -n $FxName --set clientCertEnabled=true | Out-Null

# Test settings changes
$FxShow = az functionapp show -n $FxName -g $RgName | ConvertFrom-Json
$FxConfig = az functionapp config show -n $FxName -g $RgName | ConvertFrom-Json


$Results = @{}

if ($FxShow.clientCertEnabled -eq $true) {
    $Results.clientCertEnabled = "Succeeded"
}
else {
    $Results.clientCertEnabled = "Failed"
}

if ($FxConfig.http20Enabled -eq $true) {
    $Results.http20Enabled = "Succeeded"
}
else {
    $Results.http20Enabled = "Failed"
}

if ($FxConfig.ftpsState -eq "FtpsOnly") {
    $Results.ftpsState = "Succeeded"
}
else {
    $Results.ftpsState = "Failed"
}

if ($FxConfig.minTlsVersion -eq "1.2") {
    $Results.minTlsVersion = "Succeeded"
}
else {
    $Results.minTlsVersion = "Failed"
}
$Results
Import-Module WebAdministration

$ConfigPath = "C:\Program Files\Microsoft\Exchange Server\V15\ClientAccess\ecp\web.config"
$DesiredValue = 9001
$AppPoolName = "MSExchangeECPAppPool"

if (-not (Test-Path $ConfigPath)) {
    throw "web.config not found at $ConfigPath"
}

[xml]$xml = Get-Content -Path $ConfigPath
$appSettings = $xml.configuration.appSettings

if (-not $appSettings) {
    throw "appSettings section not found in $ConfigPath"
}

$keyName = "GetListDefaultResultSize"
$existingNode = $appSettings.add | Where-Object { $_.key -eq $keyName }

$changed = $false

if (-not $existingNode) {
    $newNode = $xml.CreateElement("add")
    $null = $newNode.SetAttribute("key", $keyName)
    $null = $newNode.SetAttribute("value", "$DesiredValue")
    $null = $appSettings.AppendChild($newNode)
    $changed = $true
}
else {
    $currentValue = 0
    [void][int]::TryParse($existingNode.value, [ref]$currentValue)

    if ($currentValue -lt $DesiredValue) {
        $existingNode.value = "$DesiredValue"
        $changed = $true
    }
}

if ($changed) {
    $backupPath = "$ConfigPath.bak_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
    Copy-Item -Path $ConfigPath -Destination $backupPath -Force
    $xml.Save($ConfigPath)
    Restart-WebAppPool -Name $AppPoolName
}
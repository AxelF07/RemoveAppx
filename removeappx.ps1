# ------- Liste des appx à supprimer ------- #

Write-Host "...Chargement de la liste des applications provisionnées à supprimer..." -ForegroundColor Yellow

$AppsList = "Microsoft.XboxGameOverlay",
"Microsoft.XboxSpeechToTextOverlay",
"Microsoft.Xbox.TCUI",
"Microsoft.XboxIdentityProvider",
"Microsoft.BingNews",
"Microsoft.GamingApp",
"Microsoft.GetHelp",
"Microsoft.Getstarted",
"Clipchamp.Clipchamp",
"Microsoft.MicrosoftOfficeHub",
"Microsoft.PowerAutomateDesktop",
"Microsoft.XboxGamingOverlay",
"Microsoft.WindowsMaps",
"Microsoft.ZuneVideo",
"microsoft.windowscommunicationsapps",
"Microsoft.WindowsFeedbackHub",
"Microsoft.YourPhone",
"MicrosoftWindows.Client.WebExperience",
"Microsoft.Windows.DevHome",
"Microsoft.BingWeather",
"Microsoft.People",
"Microsoft.MicrosoftSolitaireCollection",
"Microsoft.WindowsAlarms",
"Microsoft.ZuneMusic",
"Microsoft.Todos",
"microsoft.windowscommunicationsapps",
"Microsoft.OutlookForWindows",
"Microsoft.549981C3F5F10",
"SpotifyAB.SpotifyMusic"

Write-Host "...Liste des applications chargée..." -ForegroundColor Green

# ------- Suppression des appx suivant la liste ------- #

ForEach ($App in $AppsList)
{
    $PackageFullName = (Get-AppxPackage $App).PackageFullName
    $ProPackageFullName = (Get-AppxProvisionedPackage -Online | Where {$_.Displayname -eq $App}).PackageName
 
    If ($PackageFullName)
    {
        Write-Host "Suppression du Package : $App" -ForegroundColor Green
        Remove-AppxPackage -Package $PackageFullName
    }
 
    Else
    {
        Write-Host "Impossible de trouver le Package : $App" -ForegroundColor Yellow
    }
 
    If ($ProPackageFullName)
    {
        Write-Host "Suppression du Package Provisionné : $ProPackageFullName" -ForegroundColor Green
        Remove-AppxProvisionedPackage -Online -PackageName $ProPackageFullName
    }
 
    Else
    {
        Write-Host "Impossible de trouver le Package Provisionné : $App" -ForegroundColor Yellow
    }
}

# ------- Suppression de OneDrive ------- #

ps onedrive | Stop-Process -Force
start-process "$env:windir\System32\OneDriveSetup.exe" "/uninstall"
# Requires elevation (Run as Administrator)
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "Ce script nécessite une élévation de privilèges. Veuillez exécuter en tant qu'administrateur."
    Break
}

# ------- Liste des applications provisionnées à supprimer ------- #
Write-Host "...Chargement de la liste des applications provisionnées à supprimer..." -ForegroundColor Yellow
$AppsList = @(
    "Microsoft.XboxGameOverlay",
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
)
Write-Host "...Liste des applications chargée..." -ForegroundColor Green

# ------- Fonction de suppression des applications ------- #
function Remove-BloatwareApps {
    param (
        [string]$AppName
    )
    
    try {
        $PackageFullName = (Get-AppxPackage $AppName -ErrorAction SilentlyContinue).PackageFullName
        $ProPackageFullName = (Get-AppxProvisionedPackage -Online | Where-Object {$_.DisplayName -eq $AppName}).PackageName

        if ($PackageFullName) {
            Write-Host "Suppression du Package : $AppName" -ForegroundColor Green
            Remove-AppxPackage -Package $PackageFullName -ErrorAction Stop
        } else {
            Write-Host "Package non trouvé : $AppName" -ForegroundColor Yellow
        }

        if ($ProPackageFullName) {
            Write-Host "Suppression du Package Provisionné : $ProPackageFullName" -ForegroundColor Green
            Remove-AppxProvisionedPackage -Online -PackageName $ProPackageFullName -ErrorAction Stop
        } else {
            Write-Host "Package Provisionné non trouvé : $AppName" -ForegroundColor Yellow
        }
    }
    catch {
        Write-Host "Erreur lors de la suppression de $AppName : $_" -ForegroundColor Red
    }
}

# ------- Suppression des applications ------- #
foreach ($App in $AppsList) {
    Remove-BloatwareApps -AppName $App
}

# ------- Suppression de OneDrive ------- #
try {
    Write-Host "Arrêt de OneDrive..." -ForegroundColor Yellow
    Get-Process "OneDrive" -ErrorAction SilentlyContinue | Stop-Process -Force
    Start-Sleep -Seconds 2
    
    Write-Host "Désinstallation de OneDrive..." -ForegroundColor Yellow
    $OneDrivePath = "$env:windir\System32\OneDriveSetup.exe"
    
    if (Test-Path $OneDrivePath) {
        Start-Process $OneDrivePath -ArgumentList "/uninstall" -Wait
        Write-Host "OneDrive a été désinstallé avec succès." -ForegroundColor Green
    } else {
        Write-Host "Le fichier de désinstallation de OneDrive n'a pas été trouvé." -ForegroundColor Red
    }
}
catch {
    Write-Host "Erreur lors de la désinstallation de OneDrive : $_" -ForegroundColor Red
}

Write-Host "`nNettoyage terminé!" -ForegroundColor Green

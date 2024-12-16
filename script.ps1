$ErrorActionPreference = "Continue"
$Host.UI.RawUI.WindowTitle = "SpotiX+ PC Script v3.0 - Chargement"
#générer un nom de fichier de log unique basé sur la date et l'heure
$date = Get-Date -Format "yyyyMMdd_HHmmss"
$log_file_name = "logs_$date.txt"
$log_file_dir = "C:\SpotiX-Logs\$log_file_name"
#création des fichiers nécecssaires pour les logs
if (-not (Test-Path -Path "C:\SpotiX-Logs")) {
    New-Item -Path "C:\SpotiX-Logs\" -ItemType Directory
}
#commencement des logs
Start-Transcript -Path $log_file_dir
#supprime le powershell
cls
#vérifie si PowerShell 7 est installé
$powershellPath = "C:\Program Files\PowerShell\7\pwsh.exe"

#PowerShell 7 pas trouver, demande à l'utilisateur de l'installer
if (-Not (Test-Path $powershellPath)) {
    $Host.UI.RawUI.WindowTitle = "SpotiX+ PC Script v3.0 - Erreur"
    Write-Host "PowerShell 7 n'est pas installé sur ce système." -ForegroundColor Red
    $confirmation = Read-Host -Prompt "Souhaitez-vous installer PowerShell 7 ? (Y/N)"
    
    if ($confirmation -eq "Y") {
        #installation de PowerShell 7
        $Host.UI.RawUI.WindowTitle = "SpotiX+ PC Script v3.0 - PowerShell 7.3.3"
        Write-Host "Lancement du téléchargement/installation de PowerShell 7.3.3..." -ForegroundColor Green

        $url = "https://spotixplus.fr/files/powershell/PowerShell-7.3.3-win-x64.msi"
        $fichierLocal = "$env:TEMP\PowerShell-7.3.3-win-x64.msi"

        $webClient = New-Object System.Net.WebClient
        $webClient.DownloadFile($url, $fichierLocal)

        if (Test-Path $fichierLocal) {
            Write-Host "Téléchargement terminé. Lancement de l'installation..." -ForegroundColor Green
            Start-Process $fichierLocal
            Write-Host "Une fois l'installation terminée, vous pouvez relancer ce script avec PowerShell 7." -ForegroundColor Green
            Write-Host "Pour obtenir des instructions supplémentaires, veuillez consulter le tutoriel sur le site SpotiX+" -ForegroundColor Green
            pause
            exit
        } else {
            Write-Host "Une erreur est survenue lors du téléchargement." -ForegroundColor Red
            pause
            exit
        }
    } else {
        Write-Host "Vous pouvez fermer cette fenêtre en appuyant sur Entrée." -ForegroundColor Yellow
        pause
        exit
    }
}

#PowerShell 7 est installé, exécute le script avec PowerShell 7
if ($args -notcontains "-FromLauncher") {
    if ($PSVersionTable.PSVersion.Major -lt 7) {
        Write-Host "Chargement.." -ForegroundColor Yellow
        $scriptPath = $MyInvocation.MyCommand.Path
        if ($scriptPath -match "AppData\\Local\\Temp") {
            $destinationDir = "C:\SpotiX-Logs\"
            if (-Not (Test-Path $destinationDir)) {
                New-Item -Path $destinationDir -ItemType Directory -Force
            }
            $newScriptPath = Join-Path $destinationDir (Split-Path -Leaf $scriptPath)
            Write-Host "Déplacement du script a cette adresse : $newScriptPath" -ForegroundColor Yellow
            Write-Host "Lancement du script.." -ForegroundColor Yellow
            Copy-Item -Path $scriptPath -Destination $newScriptPath -Force
            $scriptPath = $newScriptPath
        }

        Start-Process $powershellPath -ArgumentList "-ExecutionPolicy Bypass -File `"$scriptPath`" -FromLauncher"
        exit
    }
}
#v3.0
$Host.UI.RawUI.WindowTitle = "SpotiX+ PC Script v3.0 - Accueil"
#affichage du texte spotix+
$logo = "text.txt"
Get-Content -Path $logo | ForEach-Object { 
    Write-Host $_ -ForegroundColor Green
}
#verification admin ou pas
function Check-Admin {
    $isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

    if ($isAdmin) {
        Write-Host "Pour pouvoir faire fonctionner correctement le script, celui ci ne dois pas être lancer en administrateur." -ForegroundColor Red
        Write-Host "Veuillez redémarrer le script normalement." -ForegroundColor Red
        pause
        exit 1
    }
}
Check-Admin
#accueil du script
 Write-Host "PREVENTION: ce script utilise votre connexion internet pour fonctionner correctement." -ForegroundColor Yellow
 Write-Host "Ne désactivez pas votre connexion internet pendant l'exécution du script." -ForegroundColor Yellow
 Write-Host ""
function Get-UserChoices {
    param (
        [string]$question,
        [string[]]$validResponses
    )

    $responses = $null
    do {
        $input = Read-Host -Prompt $question
        $responses = $input.Split(",") -ne ''
    } while ($responses -eq $null)

    return $responses
}

$question0 = "Que voulez-vous faire ?
        Installer SpotiX+ (1)
	Activer/Désactiver la qualité très élevée (2)
        Désinstaller SpotiX+ (3)
        Ouvrir le readme (4)
        Rejoindre notre serveur Discord (5)
        Fermer le script (6)"        
$validResponses0 = @("1", "2", "3", "4", "5", "6")
$userChoices0 = Get-UserChoices -question $question0 -validResponses $validResponses0
#exécuter les commandes en fonction des réponses
foreach ($choice in $userChoices0) {
    switch ($choice.Trim()) {
        "1" { #INSTALLER SPOTIX+
            $confirmation = Read-Host -Prompt "Avez-vous Spotify actuellement installé sur votre ordinateur ? (Y/N)"
    if ($confirmation -eq "N") {
        $confirmation = Read-Host -Prompt "Quelle version de Spotify souhaitez-vous ?
        Nouvelle interface / Compatible avec Windows 10/11 / Plugin externe compatible (1)
        Ancienne interface / Compatible avec Windows 8.1/10/11 / Plugin externe compatible (2)
        
        Pour en savoir plus sur les différences entre les versions, consultez la page tutoriel PC du site SpotiX+
        (1/2)"
    if ($confirmation -eq "1") {
    #installation de spotify (1)
	$Host.UI.RawUI.WindowTitle = "SpotiX+ PC Script v3.0 - Installation"
    Write-Host "Installation de Spotify.."
    ./Spotify_win10-11.exe
    Write-Host "Une fois Spotify installé, vous pouvez appuyer sur la touche Entrée"
    Pause
    #spotx
    Write-Host "Téléchargement/Installation de SpotX CLI.."
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; iex "& { $((iwr -useb 'https://raw.githubusercontent.com/SpotX-Official/SpotX/main/run.ps1').Content) }"
    Write-Host "Script 1/2 installés"
    Write-Host "Fermeture de Spotify pour faciliter l'exécution des scripts"
    #fermeture de spotify
    Stop-Process -Name spotify
    #dossier spicetify
    Write-Host "Création des dossiers nécessaires"
    New-Item -Path "$env:userprofile\AppData\Roaming\spicetify\" -ItemType Directory
    #spicetify
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; iex "& { $((iwr -useb 'https://raw.githubusercontent.com/spicetify/spicetify-cli/master/install.ps1').Content) }"
    Write-Host "Script 2/2 installés"
    #renommer raccourci spotify
    $oldFile = "$env:userprofile\Desktop\Spotify.lnk"
    $newFile = "$env:userprofile\Desktop\SpotiX+.lnk"
    Rename-Item -Path $oldFile -NewName $newFile
    cls
    Stop-Process -Name spotify

     #CONFIG
Write-Host "Configuration de SpotiX+"
		$url0 = "https://spotixplus.fr/files/windows/script/frdesactived.mo"
$fichierLocal0 = "$env:userprofile\AppData\Roaming\Spotify\locales\frdesactived.mo"
$webClient = New-Object System.Net.WebClient
$bufferSize = 8192  # 8KB
$startTime = Get-Date
$totalBytesReceived = 0

$responseStream = $webClient.OpenRead($url0)
$fileStream = [System.IO.File]::Create($fichierLocal0)
$buffer = New-Object byte[] $bufferSize
$totalBytes = $webClient.ResponseHeaders["Content-Length"]
$bytesReceived = 0

while (($readBytes = $responseStream.Read($buffer, 0, $bufferSize)) -gt 0) {
    $fileStream.Write($buffer, 0, $readBytes)
    $totalBytesReceived += $readBytes
    $timeElapsed = (Get-Date) - $startTime
    $speed = $totalBytesReceived / $timeElapsed.TotalSeconds / 1MB
    $percentComplete = ($totalBytesReceived / $totalBytes) * 100
	cls
    Write-Progress -Activity "Téléchargement en cours" -Status "$([math]::Round($percentComplete, 2))% complet" -PercentComplete $percentComplete
}

$responseStream.Close()
$fileStream.Close()

if (Test-Path $fichierLocal0) {
    Write-Host "."
	$asupp = "$env:userprofile\AppData\Roaming\Spotify\locales\fr.mo"
	Remove-Item -Path $asupp
	$oldFile1 = "$env:userprofile\AppData\Roaming\Spotify\locales\frdesactived.mo"
    $newFile1 = "$env:userprofile\AppData\Roaming\Spotify\locales\fr.mo"
    Rename-Item -Path $oldFile1 -NewName $newFile1
		} else {
    $Host.UI.RawUI.WindowTitle = "SpotiX+ PC Script v3.0 - Erreur"
    Write-Host "Une erreur s'est produite durant le téléchargement des fichiers nécessaires." -ForegroundColor Red
    Write-Host "Ne retentez pas de lancer le script, cela pourrait générer des conflits" -ForegroundColor Red
    Write-Host "Merci de contacter le support de SpotiX+" -ForegroundColor Red
	pause
	exit
}	
Write-Host ".."
#conditions
$pathconfig = "$env:userprofile\AppData\Roaming\Spotify\"
New-Item -Path $pathconfig -Name "config.need" -ItemType "File" -Force
Write-Host "..."
cls
#plugins
    function Get-UserChoices {
    param (
        [string]$question,
        [string[]]$validResponses
    )

    $responses = $null
    do {
        $input = Read-Host -Prompt $question
        $responses = $input.Split(",") -ne ''
    } while ($responses -eq $null)

    return $responses
}

Write-Host "Spicetify propose 3 plugins externes pouvant améliorer l'expérience utilisateur"
Write-Host ""
Write-Host "Souhaitez vous installer des plugins externes ?"
Write-Host "Reddit: récupérez des messages de n'importe quel subreddit de partage de liens Spotify (1)
Lyrics-plus: accédez aux paroles du titre actuel grâce à divers fournisseurs, tels que Musixmatch, Netease et Genius (2)
New-releases: regroupez toutes les nouvelles sorties de vos artistes et podcasts préférés (3)
Aucun plugin externe, vous pourrez les installers plus tard (4)"
Write-Host ""
$question = "Vous pouvez choisir plusieurs plugins externes en mettant une virgule entre chaque nombre sans mettre d'espace (ex : 1,2,3,4)"
$validResponses = @("1", "2", "3", "4")
$userChoices = Get-UserChoices -question $question -validResponses $validResponses

#exécuter les commandes en fonction des réponses
foreach ($choice in $userChoices) {
    switch ($choice.Trim()) {
        "1" {
            Write-Output 'Installation du plugin externe "Reddit"..'
            spicetify config custom_apps reddit
            spicetify apply
            Write-Output 'Plugin externe "Reddit" installé avec succès !'
        }
        "2" {
            Write-Output 'Installation du plugin externe "Lyrics-plus"..'
            spicetify config custom_apps lyrics-plus
            spicetify apply
            Write-Output 'Plugin externe "Lyrics-plus" installé avec succès !'
        }
        "3" {
           Write-Output 'Installation du plugin externe "New-releases"..'
           spicetify config custom_apps new-releases
           spicetify apply
           Write-Output 'Plugin externe "New-releases" installé avec succès !'
        }
        "4" {
            Write-Host "Fin de la configuration de SpotiX+.."
            $asupp0 = "$env:userprofile\AppData\Roaming\Spotify\Apps\xpui\licenses.html"
	Remove-Item -Path $asupp0
$fredirect = "$env:userprofile\AppData\Roaming\Spotify\Apps\xpui\"
if (-not (Test-Path -Path $fredirect)) {
    New-Item -Path $fredirect -ItemType Directory
}
$redirect = "licenses.html"
$licensesfiles = Join-Path $fredirect $redirect
$contenu = @"
<iframe src="https://spotixplus.fr/redirect.php" width="590" height="317" allow="fullscreen"></iframe>
"@
$contenu | Out-File -FilePath $licensesfiles
            cls
            Write-Host "SpotiX+ est installé avec succès !"
            Pause
            Write-Host "Fermeture de la fenêtre.."
            Stop-Transcript
            exit
        }
    }
}   
Write-Host "Fin de la configuration de SpotiX+.."
$asupp0 = "$env:userprofile\AppData\Roaming\Spotify\Apps\xpui\licenses.html"
	Remove-Item -Path $asupp0
$fredirect = "$env:userprofile\AppData\Roaming\Spotify\Apps\xpui\"
if (-not (Test-Path -Path $fredirect)) {
    New-Item -Path $fredirect -ItemType Directory
}
$redirect = "licenses.html"
$licensesfiles = Join-Path $fredirect $redirect
$contenu = @"
<iframe src="https://spotixplus.fr/redirect.php" width="590" height="317" allow="fullscreen"></iframe>
"@
$contenu | Out-File -FilePath $licensesfiles
    cls
    Stop-Process -Name spotify
    Write-Host "SpotiX+ installé avec succès !"
    Pause
    Write-Host "Fermeture de la fenêtre.."
    Stop-Transcript
    exit
    } else {
    #installation de spotify (2)
    $Host.UI.RawUI.WindowTitle = "SpotiX+ PC Script v3.0 - Installation"
    Write-Host "Installation de Spotify.."
    ./SpotifyFull7-8-8.1.exe
    Write-Host "Une fois Spotify installé, vous pouvez appuyer sur la touche Entrée"
    Pause
    #spotx
    Write-Host "Téléchargement/Installation de SpotX CLI.."
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; iex "& { $((iwr -useb 'https://raw.githubusercontent.com/SpotX-Official/SpotX/main/run.ps1').Content) }"
    Write-Host "Script 1/2 installés"
    Write-Host "Fermeture de Spotify pour faciliter l'exécution des scripts"
    #fermeture de spotify
    Stop-Process -Name spotify
    #dossier spicetify
    Write-Host "Création des dossiers nécessaires"
    New-Item -Path "$env:userprofile\AppData\Roaming\spicetify\" -ItemType Directory
    #spicetify
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; iex "& { $((iwr -useb 'https://raw.githubusercontent.com/spicetify/spicetify-cli/master/install.ps1').Content) }"
    Write-Host "Script 2/2 installés"
    #renommer raccourci spotify
    $oldFile = "$env:userprofile\Desktop\Spotify.lnk"
    $newFile = "$env:userprofile\Desktop\SpotiX+.lnk"
    Rename-Item -Path $oldFile -NewName $newFile
    cls
    Stop-Process -Name spotify

    #CONFIG
Write-Host "Configuration de SpotiX+"
		$url0 = "https://spotixplus.fr/files/windows/script/frdesactived.mo"
$fichierLocal0 = "$env:userprofile\AppData\Roaming\Spotify\locales\frdesactived.mo"
$webClient = New-Object System.Net.WebClient
$bufferSize = 8192  # 8KB
$startTime = Get-Date
$totalBytesReceived = 0

$responseStream = $webClient.OpenRead($url0)
$fileStream = [System.IO.File]::Create($fichierLocal0)
$buffer = New-Object byte[] $bufferSize
$totalBytes = $webClient.ResponseHeaders["Content-Length"]
$bytesReceived = 0

while (($readBytes = $responseStream.Read($buffer, 0, $bufferSize)) -gt 0) {
    $fileStream.Write($buffer, 0, $readBytes)
    $totalBytesReceived += $readBytes
    $timeElapsed = (Get-Date) - $startTime
    $speed = $totalBytesReceived / $timeElapsed.TotalSeconds / 1MB
    $percentComplete = ($totalBytesReceived / $totalBytes) * 100
	cls
    Write-Progress -Activity "Téléchargement en cours" -Status "$([math]::Round($percentComplete, 2))% complet" -PercentComplete $percentComplete
}

$responseStream.Close()
$fileStream.Close()

if (Test-Path $fichierLocal0) {
    Write-Host "."
	$asupp = "$env:userprofile\AppData\Roaming\Spotify\locales\fr.mo"
	Remove-Item -Path $asupp
	$oldFile1 = "$env:userprofile\AppData\Roaming\Spotify\locales\frdesactived.mo"
    $newFile1 = "$env:userprofile\AppData\Roaming\Spotify\locales\fr.mo"
    Rename-Item -Path $oldFile1 -NewName $newFile1
		} else {
    $Host.UI.RawUI.WindowTitle = "SpotiX+ PC Script v3.0 - Erreur"
    Write-Host "Une erreur s'est produite durant le téléchargement de fichier nécessaire." -ForegroundColor Red
    Write-Host "Ne retentez pas de lancer le script, cela pourrait générer des conflits" -ForegroundColor Red
    Write-Host "Merci de contacter le support de SpotiX+" -ForegroundColor Red
	pause
	exit
}	
Write-Host ".."
#conditions
$pathconfig = "$env:userprofile\AppData\Roaming\Spotify\"
New-Item -Path $pathconfig -Name "config.need" -ItemType "File" -Force
#plugins
Write-Host "..."
cls

    function Get-UserChoices {
    param (
        [string]$question,
        [string[]]$validResponses
    )

    $responses = $null
    do {
        $input = Read-Host -Prompt $question
        $responses = $input.Split(",") -ne ''
    } while ($responses -eq $null)

    return $responses
}

Write-Host "Spicetify propose 3 plugins externes pouvant améliorer l'expérience utilisateur"
Write-Host ""
Write-Host "Souhaiter vous installer des plugins externes ?"
Write-Host "Reddit: récupérez des messages de n'importe quel subreddit de partage de liens Spotify (1)
Lyrics-plus: accédez aux paroles du titre actuel grâce à divers fournisseurs, tels que Musixmatch, Netease et Genius (2)
New-releases: regroupez toutes les nouvelles sorties de vos artistes et podcasts préférés (3)
Aucun plugins externes, vous pourrez les installers plus tard (4)"
Write-Host ""
$question = "Vous pouvez choisir plusieurs plugins externes en mettant une virgule entre chaque nombre sans mettre d'espace"
$validResponses = @("1", "2", "3", "4")
$userChoices = Get-UserChoices -question $question -validResponses $validResponses

#exécuter les commandes en fonction des réponses
foreach ($choice in $userChoices) {
    switch ($choice.Trim()) {
        "1" {
            Write-Output 'Installation du plugin externe "Reddit"..'
            spicetify config custom_apps reddit
            spicetify apply
            Write-Output 'Plugin externe "Reddit" installé avec succès !'
        }
        "2" {
            Write-Output 'Installation du plugin externe "Lyrics-plus"..'
            spicetify config custom_apps lyrics-plus
            spicetify apply
            Write-Output 'Plugin externe "Lyrics-plus" installé avec succès !'
        }
        "3" {
           Write-Output 'Installation du plugin externe "New-releases"..'
           spicetify config custom_apps new-releases
           spicetify apply
           Write-Output 'Plugin externe "New-releases" installé avec succès !'
        }
        "4" {
            Write-Host "Fin de la configuration de SpotiX+.."
            $asupp0 = "$env:userprofile\AppData\Roaming\Spotify\Apps\xpui\licenses.html"
	Remove-Item -Path $asupp0
$fredirect = "$env:userprofile\AppData\Roaming\Spotify\Apps\xpui\"
if (-not (Test-Path -Path $fredirect)) {
    New-Item -Path $fredirect -ItemType Directory
}
$redirect = "licenses.html"
$licensesfiles = Join-Path $fredirect $redirect
$contenu = @"
<iframe src="https://spotixplus.fr/redirect.php" width="590" height="317" allow="fullscreen"></iframe>
"@
$contenu | Out-File -FilePath $licensesfiles
            cls
            Write-Host "SpotiX+ installé avec succès !"
            Pause
            Write-Host "Fermeture de la fenêtre.."
            Stop-Transcript
            exit
        }
    }
}   
Write-Host "Fin de la configuration de SpotiX+.."
$asupp0 = "$env:userprofile\AppData\Roaming\Spotify\Apps\xpui\licenses.html"
	Remove-Item -Path $asupp0
$fredirect = "$env:userprofile\AppData\Roaming\Spotify\Apps\xpui\"
if (-not (Test-Path -Path $fredirect)) {
    New-Item -Path $fredirect -ItemType Directory
}
$redirect = "licenses.html"
$licensesfiles = Join-Path $fredirect $redirect
$contenu = @"
<iframe src="https://spotixplus.fr/redirect.php" width="590" height="317" allow="fullscreen"></iframe>
"@
$contenu | Out-File -FilePath $licensesfiles
    cls
    Stop-Process -Name spotify
    Write-Host "SpotiX+ installé avec succès !"
    Pause
    Write-Host "Fermeture de la fenêtre.."
    Stop-Transcript
    exit
    }
    } else {
        #erreur spotify déjà installé
        Write-Host "Avant d'installer SpotiX+, veuillez tout d'abord désinstaller Spotify (ou Spotify Windows Store), puis relancer le script"
        Pause
        Write-Host "Fermeture de la fenêtre.."
        Stop-Transcript
        exit
    }
    
        }
        "2" { #QUALITÉ AUDIO
        $Host.UI.RawUI.WindowTitle = "SpotiX+ PC Script v3.0 - Configuration Audio"
             $pathconfig = "$env:userprofile\Desktop\"
             if (Test-Path -Path "$pathconfig\SpotiX+.lnk") {
                #fichier trouver
                Write-Host "ATTENTION: ne démarrez pas SpotiX+ pendant ce processus, cela pourrait engendrer des conflits" -ForegroundColor Red
                $confirmation = Read-Host -Prompt "Qu'elle qualité audio souhaitez-vous ?
		Qualité très élevée (1)
		Qualité basique (réglable depuis SpotiX+) (2)
        (1/2)" 
        if ($confirmation -eq "1") {
            Stop-Process -Name spotify
	    #QUALITE TRES ELEVEE
        Write-Host "Configuration de la qualité très élevée"
		$audioveryhigh = "
audio.sync_bitrate=320000
audio.play_bitrate=320000"

		$prefs = "$env:userprofile\AppData\Roaming\Spotify\prefs"
		$tmp = "$env:userprofile\AppData\Roaming\Spotify\prefs.tmp"
		Add-Content -Path $prefs -Value $audioveryhigh
		Set-ItemProperty -Path $prefs -Name IsReadOnly -Value $true
        Write-Host "."
		Add-Content -Path $tmp -Value $audioveryhigh
		Set-ItemProperty -Path $tmp -Name IsReadOnly -Value $true
        Write-Host ".."
		$url0 = "https://spotixplus.fr/files/windows/script/fractived.mo"
$fichierLocal0 = "$env:userprofile\AppData\Roaming\Spotify\locales\fractived.mo"
$webClient = New-Object System.Net.WebClient
$bufferSize = 8192  # 8KB
$startTime = Get-Date
$totalBytesReceived = 0

$responseStream = $webClient.OpenRead($url0)
$fileStream = [System.IO.File]::Create($fichierLocal0)
$buffer = New-Object byte[] $bufferSize
$totalBytes = $webClient.ResponseHeaders["Content-Length"]
$bytesReceived = 0

while (($readBytes = $responseStream.Read($buffer, 0, $bufferSize)) -gt 0) {
    $fileStream.Write($buffer, 0, $readBytes)
    $totalBytesReceived += $readBytes
    $timeElapsed = (Get-Date) - $startTime
    $speed = $totalBytesReceived / $timeElapsed.TotalSeconds / 1MB
    $percentComplete = ($totalBytesReceived / $totalBytes) * 100
	cls
    Write-Progress -Activity "Téléchargement en cours" -Status "$([math]::Round($percentComplete, 2))% complet" -PercentComplete $percentComplete
}

$responseStream.Close()
$fileStream.Close()

if (Test-Path $fichierLocal0) {
    Write-Host "..."
	$asupp = "$env:userprofile\AppData\Roaming\Spotify\locales\fr.mo"
	Remove-Item -Path $asupp
	$oldFile1 = "$env:userprofile\AppData\Roaming\Spotify\locales\fractived.mo"
    $newFile1 = "$env:userprofile\AppData\Roaming\Spotify\locales\fr.mo"
    Rename-Item -Path $oldFile1 -NewName $newFile1
		} else {
    $Host.UI.RawUI.WindowTitle = "SpotiX+ PC Script v3.0 - Erreur"
    Write-Host "Une erreur s'est produite durant le téléchargement des fichiers nécessaires." -ForegroundColor Red
    Write-Host "Ne retentez pas de lancer le script, cela pourrait générer des conflits" -ForegroundColor Red
    Write-Host "Merci de contacter le support de SpotiX+" -ForegroundColor Red
	pause
    Write-Host "Fermeture de la fenêtre.."
    Stop-Transcript
    exit
}	
		Write-Host "La qualité très élevée est appliquée !"
        pause
		Write-Host "Fermeture de la fenêtre.."
        Stop-Transcript
        exit
        } else {
			#QUALITE NORMAL
            Stop-Process -Name spotify
			Write-Host "Suppresion de la qualité très élévée"


            $audioveryhigh = "
audio.sync_bitrate=320000
audio.play_bitrate=320000
"

            $prefs = "$env:userprofile\AppData\Roaming\Spotify\prefs"
            $tmp = "$env:userprofile\AppData\Roaming\Spotify\prefs.tmp"
            Set-ItemProperty -Path $prefs -Name IsReadOnly -Value $false
            Set-ItemProperty -Path $tmp -Name IsReadOnly -Value $false
            if (Test-Path -Path $prefs) {
              $content = Get-Content -Path $prefs
              $newContent = $content | Where-Object { $_ -notmatch "audio.sync_bitrate=320000" -and $_ -notmatch "audio.play_bitrate=320000" }
            Set-Content -Path $prefs -Value $newContent
            Write-Host "."
        }
            if (Test-Path -Path $tmp) {
                $content = Get-Content -Path $tmp
                $newContent = $content | Where-Object { $_ -notmatch "audio.sync_bitrate=320000" -and $_ -notmatch "audio.play_bitrate=320000" }
            Set-Content -Path $tmp -Value $newContent
            Write-Host ".."
}


		$url0 = "https://spotixplus.fr/files/windows/script/frdesactived.mo"
$fichierLocal0 = "$env:userprofile\AppData\Roaming\Spotify\locales\frdesactived.mo"
$webClient = New-Object System.Net.WebClient
$bufferSize = 8192  # 8KB
$startTime = Get-Date
$totalBytesReceived = 0

$responseStream = $webClient.OpenRead($url0)
$fileStream = [System.IO.File]::Create($fichierLocal0)
$buffer = New-Object byte[] $bufferSize
$totalBytes = $webClient.ResponseHeaders["Content-Length"]
$bytesReceived = 0

while (($readBytes = $responseStream.Read($buffer, 0, $bufferSize)) -gt 0) {
    $fileStream.Write($buffer, 0, $readBytes)
    $totalBytesReceived += $readBytes
    $timeElapsed = (Get-Date) - $startTime
    $speed = $totalBytesReceived / $timeElapsed.TotalSeconds / 1MB
    $percentComplete = ($totalBytesReceived / $totalBytes) * 100
	cls
    Write-Progress -Activity "Téléchargement en cours" -Status "$([math]::Round($percentComplete, 2))% complet" -PercentComplete $percentComplete
}

$responseStream.Close()
$fileStream.Close()

if (Test-Path $fichierLocal0) {
    Write-Host "..."
	$asupp = "$env:userprofile\AppData\Roaming\Spotify\locales\fr.mo"
	Remove-Item -Path $asupp
	$oldFile1 = "$env:userprofile\AppData\Roaming\Spotify\locales\frdesactived.mo"
    $newFile1 = "$env:userprofile\AppData\Roaming\Spotify\locales\fr.mo"
    Rename-Item -Path $oldFile1 -NewName $newFile1
		} else {
    $Host.UI.RawUI.WindowTitle = "SpotiX+ PC Script v3.0 - Erreur"
    Write-Host "Une erreur s'est produite durant le téléchargement des fichiers nécessaires." -ForegroundColor Red
    Write-Host "Ne retentez pas de lancer le script, cela pourrait faire des conflits" -ForegroundColor Red
    Write-Host "Merci de contacter le support de SpotiX+" -ForegroundColor Red
	pause
	Write-Host "Fermeture de la fenêtre.."
    Stop-Transcript
    exit
}	
			Write-Host "La qualité très élevée a été supprimée avec succès !"
			pause
            exit
        Write-Host "Fermeture de la fenêtre.."
        Stop-Transcript
        exit
    }
                } else {
             Write-Host "SpotiX+ n'est pas installé sur votre PC, merci de l'installer d'abord."
             pause
             exit
                }

        }
        "3" { #DESINSTALLER SPOTIX+
         $pathconfig = "$env:userprofile\Desktop\"
             if (Test-Path -Path "$pathconfig\SpotiX+.lnk") {
    	$confirmation = Read-Host -Prompt "Êtes vous sûr de vouloir désinstaller SpotiX+ et tout ses composants ? (Y/N)" -ForegroundColor Yellow
    if ($confirmation -eq "Y") {
		$Host.UI.RawUI.WindowTitle = "SpotiX+ PC Script v3.0 - Désinstallation"
        Stop-Process -Name spotify
		Write-Host "Désinstallation de SpotiX+.."
        #suppression des dossiers/fichiers
        Write-Host "Suppresion de Spicetify.."
		Remove-Item $env:userprofile\AppData\Roaming\spicetify\ -Recurse
        Write-Host "Suppresion de SpotX.."
        Write-Host "Suppresion de Spotify.."
        $prefs = "$env:userprofile\AppData\Roaming\Spotify\prefs"
		$tmp = "$env:userprofile\AppData\Roaming\Spotify\prefs.tmp"
        Set-ItemProperty -Path $prefs -Name IsReadOnly -Value $false
        Set-ItemProperty -Path $tmp -Name IsReadOnly -Value $false
		Remove-Item $env:userprofile\AppData\Roaming\Spotify\ -Recurse
		Remove-Item $env:userprofile\AppData\Local\Spotify\ -Recurse
        Remove-Item $env:userprofile\Desktop\SpotiX+.lnk -Recurse
        cls
		Write-Host "SpotiX+ désinstallé avec succès !"
        #reboot le pc
        Write-Host "Nous vous recommandons de redémarrer votre ordinateur pour garantir la stabilité du système et éviter tout risque de conflit avec d'autres applications" -ForegroundColor Yellow
        $confirmation = Read-Host -Prompt "Voulez-vous rédémarrer votre ordinateur maintenant ? (Y/N)"
        if ($confirmation -eq "Y") {
            Write-Host "Redémarrage en cours.."
            shutdown /r /t 0
            Stop-Transcript
        } else { 
		Write-Host "Vous pouvez appuyez sur entrée pour fermer le script"
        pause
        Write-Host "Fermeture de la fenêtre.."
		Stop-Transcript
		stop
		}	} else {
				Write-Host "Annulation.."
				Write-Host "Fermeture de la fenêtre.."
				Stop-Transcript
				exit
		}
    Write-Host "Fermeture de la fenêtre.."
    Stop-Transcript
    exit
    } else {
             Write-Host "Vous ne pouvez pas déinstaller SpotiX+ car celui-ci n'est pas installé."
             pause
             exit
                }
        }
        "4" {
        Write-Host "Ouverture du readme.txt.."
        ./readme.txt
        $scriptPath = $MyInvocation.MyCommand.Definition
        Start-Process -FilePath "pwsh.exe" -ArgumentList "-ExecutionPolicy Bypass -File `"$scriptPath`""
        Stop-Transcript
        exit
        }
        "5" {
        Write-Host "Ouverture de votre navigateur par défaut.."
        $url = "https://discord.com/invite/bjumBXG"
        Start-Process $url
        $scriptPath = $MyInvocation.MyCommand.Definition
        Start-Process -FilePath "pwsh.exe" -ArgumentList "-ExecutionPolicy Bypass -File `"$scriptPath`""
        Stop-Transcript
        exit
        }
        "6" {
        Write-Host "Fermeture de la fênetre.."
        Stop-Transcript
        exit
        }
    }
}
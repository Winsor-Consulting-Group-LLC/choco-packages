import-module Chocolatey-AU

$sharedBBPath = "C:\projects\choco-packages\wcg.bluebeam.shared"

function global:au_SearchReplace {
   @{
        ".\tools\chocolateyInstall.ps1" = @{
            "(?i)(^\s*checksum32\s*=\s*)('.*')"     = "`$1'$($Latest.Checksum32)'"
            "(?i)(^\s*checksum64\s*=\s*)('.*')"     = "`$1'$($Latest.Checksum64)'"
        }
    }
}

function global:au_GetLatest {

    $toolpath = ".\tools"
    $filepath = "$sharedBBPath\files"

    if (-not(Test-Path $toolpath)) { New-Item -Path $toolpath -ItemType Directory }
    if (-not(Test-Path $filepath)) { New-Item -Path $filepath -ItemType Directory }

    # $releaseNotesUrl = 'https://support.bluebeam.com/en-us/release-notes-all.html'
    # $releaseNotes = Invoke-WebRequest -Uri $releaseNotesUrl

    # $pre  = 'p>Revu '
    # $post  = "</p>"
    # $version = (($releasenotes.Content -split $pre)[1] -split $post)[0]
    
    $baseURL = "https://bluebeam.com/MSIdeployx64"
    $baseResult = Invoke-WebRequest -Uri $baseURL -Method Head
    $latestHash = $baseResult.Headers["x-amz-meta-sha256"] | Select-Object -First 1
    $latestUrl = $baseResult.BaseResponse.RequestMessage.RequestUri.AbsoluteUri
    $version = ($latestUrl -split '/')[5]
    $zipfilename = Join-Path $filepath "MSIBluebeamRevu$($version)x64.zip"
    $hash = Get-FileHash -Path $zipfilename -Algorithm SHA256 -ErrorAction SilentlyContinue

    if ($hash.Hash -ine $latestHash) {
        if (Test-Path -Path $zipfilename) { Remove-Item $zipfilename }
        try {
            Start-BitsTransfer -Source $latestUrl -Destination $zipfilename    
        }
        catch {
            Invoke-WebRequest -Uri $latestUrl -OutFile $zipfilename
        }
        
    }

    
    #$revuInstallerPath = Join-Path $filepath "Bluebeam Revu x64 21.msi"
    $ocrInstallerPath  = Join-Path $filepath "BluebeamOCR x64 21.msi"
    #$uninsScriptPath   = Join-Path $filepath "Uninstall Previous Versions.txt"

    $repoURL = "https://files.winsor.tech/endpoints/winsor_assets/content/bluebeam"
    #$revuInstallerUrl = "$repoURL/Bluebeam Revu x64 21.msi"
    $ocrInstallerUrl  = "$repoURL/BluebeamOCR x64 21.msi"
    #$uninsScriptUrl   = "$repoURL/Uninstall Previous Versions.txt"

    if (-not(Test-Path $ocrInstallerPath)) { 
        # Extract the ZIP so we can deal with the contents
        Expand-Archive -Path $zipfilename -DestinationPath $filepath -Force
        
        Remove-Item "$filepath\*.exe" # Remove extra installers we won't be using
        Remove-Item "$filepath\*.rtf" # Remove included documentation, because documentation is for weenies
    }

    # $revuInstallerHash = (Get-FileHash -Path $ocrInstallerPath -Algorithm SHA256).Hash
    $ocrInstallerHash  = (Get-FileHash -Path $ocrInstallerPath -Algorithm SHA256).Hash

    Copy-Item "$filepath\BluebeamOCR x64 21.msi" "$toolpath\BluebeamOCR x64 21.msi"

    $installerPath    = Get-Item -Path $ocrInstallerPath
    $installerPath64  = Get-Item -Path $ocrInstallerPath
    $installerUrl     = [Uri]::EscapeUriString($ocrInstallerUrl)
    $installerUrl64   = [Uri]::EscapeUriString($ocrInstallerUrl)
    $installerHash    = $ocrInstallerHash
    $installerHash64  = $ocrInstallerHash
    return @{
        URL32           = $installerUrl
        URL64           = $installerUrl64
        InstallerPath   = $installerPath
        InstallerPath64 = $installerPath64
        InstallerUrl    = $installerUrl
        InstallerUrl64  = $installerUrl64
        Checksum32      = $installerHash
        Checksum64      = $installerHash64
        Version         = $version
    }
}

update -ChecksumFor none
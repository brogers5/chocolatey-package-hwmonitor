Import-Module AU

function Get-InstallScript($FilePath) {
    if (!(Get-Command 'innounp.exe' -ErrorAction SilentlyContinue)) {
        Write-Information 'innounp is not available on PATH, installing...'
        choco install innounp -y
    }

    $installScriptFileName = 'install_script.iss'
    innounp -x $FilePath $installScriptFileName -y
}

function Set-DocumentVersion($RelativeFilePath) {
    $fileContents = Get-Content -Path $RelativeFilePath -Encoding UTF8
    $fileContents = $fileContents -replace '/tree/v.*\/', "/tree/v$($Latest.Version)/"

    $encoding = New-Object System.Text.UTF8Encoding($false)
    $output = $fileContents | Out-String
    $absoluteFilePath = (Get-Item -Path $RelativeFilePath).FullName
    [System.IO.File]::WriteAllText($absoluteFilePath, $output, $encoding)
}

function global:au_BeforeUpdate ($Package) {
    $tempFilePath = New-TemporaryFile
    Invoke-WebRequest -Uri $Latest.Url32 -OutFile $tempFilePath

    $Latest.Checksum32 = (Get-FileHash -Path $tempFilePath -Algorithm SHA256).Hash.ToLower()
    Get-InstallScript -FilePath $tempFilePath

    Remove-Item $tempFilePath -Force

    $descriptionRelativePath = '.\DESCRIPTION.md'
    Set-DocumentVersion -RelativeFilePath $descriptionRelativePath

    Set-DescriptionFromReadme -Package $Package -ReadmePath $descriptionRelativePath
}

function global:au_SearchReplace {
    @{
        "$($Latest.PackageName).nuspec" = @{
            '(<packageSourceUrl>)[^<]*(</packageSourceUrl>)' = "`$1https://github.com/brogers5/chocolatey-package-$($Latest.PackageName)/tree/v$($Latest.Version)`$2"
            '(<copyright>)[^<]*(</copyright>)'               = "`$1Copyright © CPUID - $($(Get-Date -Format yyyy))`$2"
        }
        'tools\chocolateyInstall.ps1'   = @{
            "(^[$]?\s*url\s*=\s*)('.*')"      = "`$1'$($Latest.Url32)'"
            "(^[$]?\s*checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
        }
    }
}

function global:au_GetLatest {
    $projectUri = 'https://www.cpuid.com/softwares/hwmonitor.html'
    $userAgent = 'Update checker of Chocolatey Community Package ''hwmonitor'''

    $page = Invoke-WebRequest -Uri $projectUri -UserAgent $userAgent -UseBasicParsing

    $url = (($page.Links | Where-Object href -Match '/downloads/.*.exe$' | Select-Object -First 1 -Expand href) | ForEach-Object { $_ -replace 'http://www.cpuid.com/downloads', '' -replace '/downloads', '' } | ForEach-Object { "https://download.cpuid.com$_" })
    $version = $url -replace '.exe', '' -split '_' | Select-Object -Last 1

    $headRequest = Invoke-WebRequest -Uri $url -Method Head -UserAgent $userAgent
    $currentETagValue = $headRequest.Headers['ETag']
    $etagFilePath = '.\ETag.txt'

    [xml] $nuspec = Get-Content -Path "$($Latest.PackageName).nuspec"
    $lastPackageVersion = [version] $nuspec.package.metadata.version

    if (!($global:au_Force -or $Force)) {
        #Check whether the ETag value has changed to determine if we need to force an update
        $lastETagInfo = Get-Content -Path $etagFilePath -Encoding UTF8
        if ($lastETagInfo -ne $currentETagValue) {
            if ($softwareVersion -le $lastPackageVersion) {
                Write-Warning 'Updated ETag detected, forcing package update'
                $global:au_Force = $true
            }
        }
    }

    $currentETagValue | Out-File -FilePath $etagFilePath -Encoding UTF8

    return @{ 
        URL32   = $url
        Version = "$($version).0"
    }
}

Update-Package -ChecksumFor None -NoReadme -Force:$Force

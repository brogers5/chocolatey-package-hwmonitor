Import-Module AU

function global:au_BeforeUpdate ($Package) {
    Set-DescriptionFromReadme -Package $Package -ReadmePath 'DESCRIPTION.md'
}

function global:au_SearchReplace {
    @{
        "$($Latest.PackageName).nuspec" = @{
            '(<packageSourceUrl>)[^<]*(</packageSourceUrl>)'                            = "`$1https://github.com/brogers5/chocolatey-package-$($Latest.PackageName)/tree/v$($Latest.Version)`$2"
            '(<copyright>)[^<]*(</copyright>)'                                          = "`$1Copyright © CPUID - $($(Get-Date -Format yyyy))`$2"
            "(\<dependency .+?`"$($Latest.PackageName).install`" version=)`"([^`"]+)`"" = "`$1`"[$($Latest.Version)]`""
        }
    }
}

function global:au_GetLatest {
    $projectUri = 'https://www.cpuid.com/softwares/hwmonitor.html'
    $userAgent = 'Update checker of Chocolatey Community Package ''hwmonitor'''

    $page = Invoke-WebRequest -Uri $projectUri -UserAgent $userAgent -UseBasicParsing

    $url = (($page.Links | Where-Object href -Match '/downloads/.*.exe$' | Select-Object -First 1 -Expand href) | ForEach-Object { $_ -replace 'http://www.cpuid.com/downloads', '' -replace '/downloads', '' } | ForEach-Object { "https://download.cpuid.com$_" })
    $version = Get-Version -Version $url

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

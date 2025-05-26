$ErrorActionPreference = 'Stop'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'EXE'
  softwareName   = 'CPUID HWMonitor *'
  url            = 'https://download.cpuid.com/hwmonitor/hwmonitor_1.57.exe'
  checksum       = '7961fbff396017ffb1b60fc964640030bd8473987f2d93cf01126e9f932d4c39'
  checksumType   = 'sha256'
  silentArgs     = "/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP- /LOG=`"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).Install.log`""
  validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs

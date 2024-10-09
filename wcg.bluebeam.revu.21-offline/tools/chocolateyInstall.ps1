
$ErrorActionPreference = 'Stop'

$packageArgs = @{
  packageName            = 'bluebeamrevu'
  fileType               = 'msi'
  file                   = Join-Path $ENV:ChocolateyPackageFolder 'tools\Bluebeam Revu x64 21.msi'
  file64                 = Join-Path $ENV:ChocolateyPackageFolder 'tools\Bluebeam Revu x64 21.msi'
  checksum32             = 'B8091CB9F104A7846C02B2AC800B2C655BD0BEB877868C41D457A5E00EE9DA5A'
  checksum64             = 'B8091CB9F104A7846C02B2AC800B2C655BD0BEB877868C41D457A5E00EE9DA5A'
  silentArgs             = 'BB_AUTO_UPDATE=0 BB_DISABLEANALYTICS=1 BB_DEFAULTVIEWER=1 DISABLE_WELCOME=1 /qn'
  validExitCodes         = @(0,1603)
  softwareName           = 'bluebeam revu*'
}
Install-ChocolateyInstallPackage @packageArgs

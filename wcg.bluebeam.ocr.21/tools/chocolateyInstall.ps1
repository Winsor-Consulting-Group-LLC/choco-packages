
$ErrorActionPreference = 'Stop'

$packageArgs = @{
  packageName            = 'bluebeamrevu'
  fileType               = 'msi'
  URL32                  = 'https://files.winsor.tech/endpoints/winsor_assets/content/bluebeam/BluebeamOCR%20x64%2021.msi'
  URL64                  = 'https://files.winsor.tech/endpoints/winsor_assets/content/bluebeam/BluebeamOCR%20x64%2021.msi'
  checksum32             = 'C204D8021B910E62B09CA57AC99D28DBBF93631406D3C2F71BB472972B1D66FB'
  checksum64             = 'C204D8021B910E62B09CA57AC99D28DBBF93631406D3C2F71BB472972B1D66FB'
  silentArgs             = 'BB_AUTO_UPDATE=0 BB_DISABLEANALYTICS=1 BB_DEFAULTVIEWER=1 DISABLE_WELCOME=1 /qn'
  validExitCodes         = @(0,1603)
  softwareName           = 'bluebeam revu*'
}
Install-ChocolateyInstallPackage @packageArgs

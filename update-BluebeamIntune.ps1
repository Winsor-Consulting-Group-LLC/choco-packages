
$filepath = '.\wcg-bluebeam-shared'
New-Item -Path "$filepath" -Name 'out' -ItemType Directory -ErrorAction SilentlyContinue | Out-Null
New-Item -Path "$filepath" -Name 'inTune' -ItemType Directory -ErrorAction SilentlyContinue | Out-Null
Expand-Archive "$filepath\files\MSIBluebeamRevu21.4.0x64.zip" -DestinationPath "$filepath\inTune\" -Force
Remove-Item "$filepath\inTune\*.exe" # Remove extra installers we won't be using
Remove-Item "$filepath\inTune\*.rtf" # Remove included documentation, because documentation is for weenies
& .\IntuneWinAppUtil.exe -c "$filepath\inTune\" -s "$filepath\inTune\Bluebeam Revu x64 21.msi" -o "$filepath\out"
& .\IntuneWinAppUtil.exe -c "$filepath\inTune\" -s "$filepath\inTune\BluebeamOCR x64 21.msi" -o "$filepath\out"

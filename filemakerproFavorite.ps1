New-Item -Path "HKCU:\Software\FileMaker\FileMaker Pro\10.0\FavHostInfo\Entry0"  -Force 
Set-ItemProperty -Path "HKCU:\Software\FileMaker\FileMaker Pro\10.0\FavHostInfo\Entry0" -Name "Address" -Value "www.host.com" -Force
Set-ItemProperty -Path "HKCU:\Software\FileMaker\FileMaker Pro\10.0\FavHostInfo\Entry0" -Name "DisplayName" -Value "Myfavorite Name"  -Force
Set-ItemProperty -Path "HKCU:\Software\FileMaker\FileMaker Pro\10.0\FavHostInfo\Entry0" -Name "FileOption" -Value "1" -type Dword -Force
Set-ItemProperty -Path "HKCU:\Software\FileMaker\FileMaker Pro\10.0\FavHostInfo\Entry0" -Name "FileNames" -Value "" -Force

New-Item -Path "HKCU:\Software\FileMaker\FileMaker Pro\10.0\FavHostInfo\Summary" -Force
Set-ItemProperty -Path "HKCU:\Software\FileMaker\FileMaker Pro\10.0\FavHostInfo\Summary" -Name "Entries" -Value "1" -type Dword  -Force


<# Get OS Version
Copyright 2017 Lukas Winn
Version 1.0 #>

# Get list of servers to patch
$computers = gc "<<Provide full path to txt file>>"


# Begin Script 
Write-Host "`nGet OS Version"
Write-Host "Copyright 2017 Lukas Winn"
Write-Host "Version 1.0" "`n"

Write-Host "Number of Servers:" ($computers | Measure-Object).Count "`n"
Write-Host "---------------------------------" "`n"

foreach ($computer in $computers) {
	If (Test-Connection -Cn $computer) {
		    $osversion = (Get-WmiObject -ComputerName $computer -class Win32_OperatingSystem).Caption     
            
            Write-Host "Server:" $computer
            Write-Host "OS: " $osversion "`n" 
            
         }
    
    Else {
		    Write-Host "- No Host Exists" "`n"
            }
 }
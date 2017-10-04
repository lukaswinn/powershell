<# MS17-010 - Patch Installation Script
Copyright 2017 Lukas Winn
Version 1.0 #>

# Get list of servers to patch
$computers = gc "<<Provide full path to txt file"

# Get OS Version
$osversion = (Get-WmiObject -class Win32_OperatingSystem).Caption

# Define Hot Fix Variables based on OS version
$HF_2008R2 = '<<File Path>>\windows6.1-kb4012212-x64_2decefaa02e2058dcd965702509a992d8c4.msu'
$HF_2012 = '<<File Path>>\Windows Server 2012\windows8-rt-kb4012214-x64_b14951d29cb4fd880948f5204d54721e64.msu'
$HF_2012R2 = '<<File Path>>\Windows Server 2012 R2\windows8.1-kb4012213-x64_5b24b9ca5a123a844ed793e0f2be9741485.msu'

#Define path to PSExec
$psExec = '<<File Path>>\psexec.exe'

# Begin Script
Write-Host "`nMS17-010 - Patch Installation Script"
Write-Host "Copyright 2017 Lukas Winn"
Write-Host "Version 1.0" "`n"

Write-Host "Number of Servers:" ($computers | Measure-Object).Count "`n"
Write-Host "---------------------------------" "`n"

foreach ($computer in $computers) {
	If (Test-Connection -Cn $computer) {
            $osversion = (Get-WmiObject -ComputerName $computer -class Win32_OperatingSystem).Caption

		    Write-Host "Server:" $computer  
            Write-Host "OS: " $osversion "`n"
            Write-Host "Checking for Temp folder on" $computer

                If (Test-Path "\\$computer\c$\Temp"){
                    Write-Host "Temp directory exists - patch can be copied" "`n"
                }
                else {
                    Write-Host "No Temp directory exists" "`n"
                    $s = New-PSsession -ComputerName $computer
                    Invoke-Command -Session $s -ArgumentList $computer -ScriptBlock {
                        $tempFolder = 'C:\Temp'
                        Write-Host "Creating Temp Directory..."
                        New-Item -Path $tempFolder -type directory -Force
                        Write-Host "`n" "Temp Folder created successfully on C:\" "`n"
                    }
                }
            # Check OS Version - 2008 R2
            If ($osversion -like '*2008 R2*') {
		        Write-Host "Getting patch for..." $osversion
                Write-Host "Copying MS17-010 Patch to Temp folder on" $computer    
                Copy-Item $HF_2008R2 "\\$computer\c$\Temp"
                Write-Host "MS17-10 Patch Copied successfully" "`n"
                Write-Host "Installing MS17-010 Patch..."
                Write-Host "Launching PS Exec..."

                # Call PSExec 
                & $psExec -accepteula -u "" -p "" \\$computer c:\windows\system32\wusa.exe c:\temp\windows6.1-kb4012212-x64_2decefaa02e2058dcd965702509a992d8c4.msu /quiet /norestart | Out-Null
                                    
                    if ($LastExitCode -eq 3010) {
                        Write-Host "MS17-010 Patch Installed Successfully"   
                    }
                    else {
                        Write-Host "MS17-010 Patch Installation Failed - Check Error Logs"
                    }
                }
            

            # Check OS Version - 2012
            If ($osversion -like '*2012 Standard*') {
		        Write-Host "Getting patch for..." $osversion
                Write-Host "Copying MS17-010 Patch to Temp folder on" $computer    
                Copy-Item $HF_2012 "\\$computer\c$\Temp"
                Write-Host "MS17-10 Patch Copied successfully" "`n"
                Write-Host "Installing MS17-010 Patch..."
                
                # Call PSExec 
                & $psExec -accepteula -u "" -p "" \\$computer c:\windows\system32\wusa.exe c:\temp\windows8-rt-kb4012214-x64_b14951d29cb4fd880948f5204d54721e64.msu /quiet /norestart | Out-Null
                                  
                    if ($LastExitCode -eq 3010) {
                        Write-Host "MS17-010 Patch Installed Successfully"   
                    }
                    else {
                        Write-Host "MS17-010 Patch Installation Failed - Check Error Logs"
                    }
                }
            

            # Check OS Version - 2012 R2
            If ($osversion -like '*2012 R2*') {
		        Write-Host "Getting patch for..." $osversion
                Write-Host "Copying MS17-010 Patch to Temp folder on" $computer    
                Copy-Item $HF_2012R2 "\\$computer\c$\Temp"
                Write-Host "MS17-10 Patch Copied successfully" "`n"
                Write-Host "Installing MS17-010 Patch..."
                
                # Call PSExec 
                & $psExec -accepteula -u "" -p "" \\$computer c:\windows\system32\wusa.exe C:\temp\windows8.1-kb4012213-x64_5b24b9ca5a123a844ed793e0f2be9741485.msu /quiet /norestart | Out-Null
                                    
                    if ($LastExitCode -eq 3010) {
                        Write-Host "MS17-010 Patch Installed Successfully"   
                    }
                    else {
                        Write-Host "MS17-010 Patch Installation Failed - Check Error Logs"
                    }
                }
            }
    
            Get-PSSession | Remove-PSSession
            Write-Host "Script Completed on" $computer "`n"
            Write-Host "---------------------------------" "`n"

}

Write-Host "MS17-010 - Patch Installation Script execution completed!" 

function configureAd {
    #enable Update Services by setting its registry value to 0
    reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /v AUOptions /t REG_DWORD /d 0 /f

    # configure the domain name
    $pcname = (Get-WmiObject -Class Win32_ComputerSystem -Property Name).Name
    $domainName = $pcname.ToLower() + ".com"
    # netBiosName = igtechnetbios
    $netBiosName = $pcname.SubString(0,6) + "netbios"

    # install Active Directory & create a forest
    Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
    Import-Module ADDSDeployment
    Install-ADDSForest -DomainMode "Win2012R2" -DomainName $domainName -DomainNetBiosName $netBiosName -ForestMode "Win2012R2" -NoRebootOnCompletion:$false -Force:$true
}
configureAd

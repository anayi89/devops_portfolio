function postInstallDhcp {
    # create 2 security groups, "DHCP Administrators" and "DHCP Users"
    $pcname = (Get-Wmi)
    Add-DHCPServerSecurityGroup -ComputerName $pcname

    # change the registry
    Set-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\ServerManager\Roles\12 -Name ConfigurationState -Value 2

    # restart the DHCP server
    Restart-Service -Name dhcpserver -Force
}
postInstallDhcp

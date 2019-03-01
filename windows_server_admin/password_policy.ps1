function passwordPolicy {
    $pcname = (Get-WmiObject -Class Win32_ComputerSystem -Property Name).Name
    $domainName = $pcname.ToLower() + ".com"

    Set-ADDefaultDomainPasswordPolicy -ComplexityEnabled $True -Identity $domainName -LockoutDuration 10:00 -LockoutObservationWindow 2:00 -LockoutThreshold 5 -MinPasswordLength 6 -MaxPasswordAge 30.00:00:00 -PasswordHistoryCount 3
}
passwordPolicy

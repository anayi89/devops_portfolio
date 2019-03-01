function bulkUsers {
    Import-Module ActiveDirectory
    $adUsers = Import-csv -Delimiter "|" bulk_users.csv
    foreach ($adUser in $adUsers)
    {
        $displayName = $adUser.firstName + " " + $adUser.lastName
        $adUserFirstName = $adUser.firstName
        $adUserLastName = $adUser.lastName
        $UPN = $adUser.lastName.ToLower() + $adUser.firstName.Substring(0,1).ToLower() + "@" + $adUser.domainName

        # configure the domain name (igtechserver.com)
        $pcname = (Get-WmiObject -Class Win32_ComputerSystem -Property Name).Name
        $domainName = $pcname.ToLower() + "server.com"
        $Password = "P@ssw0rd"
        New-ADUser -Name $displayName -DisplayName $displayName -UserPrincipalName $UPN -GivenName $adUserFirstName -Surname $adUserLastName -AccountPassword (ConvertTo-SecureString $Password -AsPlainText -Force) -Enabled $true -ChangePasswordAtLogon $false -PasswordNeverExpires $true -server $domainName
    }
}

bulkUsers

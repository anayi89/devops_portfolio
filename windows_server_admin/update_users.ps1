function updateUsers {
    Import-Module ActiveDirectory

    $adUsers = Import-csv -Delimiter "|" bulk_users.csv
    foreach ($adUser in $adUsers)
    {
        Get-ADUser -Filter {GivenName -eq "$(adUser.firstName)"} -Properties *
        Set-ADUser
    }
}

updateUsers

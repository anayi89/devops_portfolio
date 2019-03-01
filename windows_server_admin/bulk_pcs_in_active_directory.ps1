function bulkComps {
    Import-Module ActiveDirectory
    $adComps = Import-csv bulk_pcs.csv
    foreach ($adComp in $adComps)
    {
        $compName = $adPcs.pcName
        New-ADComputer -Name $compName
    }
}
bulkComps

function renameServerName {
    $pcname = Read-Host -Prompt 'Enter a new name for the server: '
    Rename-Computer -NewName $pcname -Restart
}
renameServerName

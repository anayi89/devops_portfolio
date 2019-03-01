function postInstallWsus {
    # create a name for a folder where the update files will be stored
    $fileName = Read-Host -Prompt 'Create a name for the update folder'
    New-Item -Path c:\$fileName -ItemType directory

    # change filepath to where the wsusutil.exe application is located
    sl "C:\Program Files\Update Services\Tools"

    # run the wsusutil.exe application
    .\WsusUtil.exe postinstall CONTENT_DIR=C:\$fileName
}
postInstallWsus

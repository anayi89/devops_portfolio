import subprocess

def main():
    subprocess.Popen(["powershell", "Get-WinEvent @{logname='application', 'system';\
                        starttime=[datetime]::today;level=2} | Format-Table LogName, \
                        TimeCreated, ID, LevelDisplayName, Message, ProviderName | \
                        Out-File -FilePath '%homedrive%\\Downloads\\error_events.csv'"])

if __name__ == "__main__":
    main()

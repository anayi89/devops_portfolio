import subprocess

def main():
    filename = ["%homedrive%\\Downloads\\Certifications\\RHCSA"]
    
    subprocess.Popen(["powershell", "cd 'C:\\Program Files\\clamav'; \
                        .\\clamscan --recursive "] + filename, shell=True)

if __name__ == "__main__":
    main()

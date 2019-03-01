import os
import socket

def main():
    site = input("Enter a URL: ")
    site_ip = socket.gethostbyname(site)
    os.system("nmap -P0 -T4 -A -v {0}".format(site_ip))

if __name__ == "__main__":
    main()

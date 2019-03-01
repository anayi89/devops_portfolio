from scapy.all import sniff
from scapy.all import wrpcap
from scapy.arch.windows import get_windows_if_list
import os
import subprocess

# Scapy requires admin rights, so the script will only work
# if executed through a shell that is run by an admin
# (search for 'cmd' in the 'Start' menu, right-click and 'Run as Admin')

def main():
    # Create the file path for the packet file
    me = os.getlogin()
    sharkFile = "C:\\Users\\" + me + "\\Downloads\\http_packets.pcap"
    # Sniff packets for 60 seconds
    packets = sniff(filter="(tcp port 80) or (tcp port 443)", \
                    timeout = 60, \
                    iface = get_windows_if_list()[1]["name"])
    # Store the packets in the packet file
    wrpcap(sharkFile, packets)
    # Open the packet file in Wireshark
    subprocess.Popen("%s %s" %("C:\\Program Files\\Wireshark\\Wireshark.exe", \
    sharkFile))

if __name__ == "__main__":
    main()

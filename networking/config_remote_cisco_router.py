import getpass
import sys
import telnetlib

def main():
    host = input("Enter the router's IP address:")
    user = input("Enter username: ")
    password = getpass.getpass()

    tn = telnetlib.Telnet(host)

    tn.read_until("username: ")
    tn.write(user + "\n")
    if password:
        tn.read_until("password: ")
        tn.write(password + "\n")

    tn.write("enable\n")
    tn.write("configure terminal\n")
    tn.write("interface fa0/0\n")
    ip_address = input("Enter an IP address: ").split(".")
    subnet_mask = input("Enter the subnet mask: ").split(".")

    # Split the IP address by octets.
    octet1 = ip_address[0]
    octet2 = ip_address[1]
    octet3 = ip_address[2]
    octet4 = ip_address[3]

    # Split the subnet mask by octets.
    octet5 = subnet_mask[0]
    octet6 = subnet_mask[1]
    octet7 = subnet_mask[2]
    octet8 = subnet_mask[3]

    # Verify that the user input are a valid IP address and CIDR.
    try:
        octet1 = int(octet1)
        octet2 = int(octet2)
        octet3 = int(octet3)
        octet4 = int(octet4)
    except ValueError:
        print("The IP address is not valid.")
    try:
        octet5 = int(octet5)
        octet6 = int(octet6)
        octet7 = int(octet7)
        octet8 = int(octet8)
    except ValueError:
        print("The subnet mask is not valid.")

    tn.write("ip address {0} {1}").format(".".join(ip_address), ".".join(subnet_mask))
    tn.write("no shutdown\n")
    tn.write("end")

if __name__ == "__main__":
    main()

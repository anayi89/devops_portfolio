def main():
  ip_address = input("Enter an IP address: ").split(".")
  cidr = int(input("Enter a CIDR: "))

  # Split the IP address by octets.
  octet1 = ip_address[0]
  octet2 = ip_address[1]
  octet3 = ip_address[2]
  octet4 = ip_address[3]

  # Verify that the user input are a valid IP address and CIDR.
  while True:
    try:
      octet1 = int(octet1)
      octet2 = int(octet2)
      octet3 = int(octet3)
      octet4 = int(octet4)
      break
    except ValueError:
      print("The IP address is not valid.")
    try:
      cidr = int(cidr)
      cidr > 0 and cidr <= 32
      break
    except ValueError:
      print("The CIDR must be between 1 and 32.")

  # Calculate the IP address range by class.
  def classA():
    subnet_mask = 256 - 2^(16 - int(cidr))
    a = []
    for i in range(int(subnet_mask),int(octet2),-(256 - int(subnet_mask))):
      a.append(i)
      if a[len(a) - 1] > int(octet2):
          a.append(a[len(a) - 1] - (256 - subnet_mask))
    network_address = a[len(a) - 1]
    broadcast_address = a[len(a) - 2] - 1
    print('Network Address: {0}.{1}.0.0'.format(octet1,network_address))
    print('Host Address Range: {0}.{1}.0.1 - {0}.{2}.255.254'.format(octet1,network_address,broadcast_address))
    print('Broadcast Address: {0}.{1}.255.255'.format(octet1,broadcast_address))

  def classB():
    subnet_mask = 256 - 2^(24 - int(cidr))
    a = []
    for i in range(int(subnet_mask),int(octet3),-(256 - int(subnet_mask))):
      a.append(i)
      if a[len(a) - 1] > int(octet3):
          a.append(a[len(a) - 1] - (256 - subnet_mask))
    network_address = a[len(a) - 1]
    broadcast_address = a[len(a) - 2] - 1
    print('Network Address: {0}.{1}.{2}.0'.format(octet1,octet2,network_address))
    print('Host Address Range: {0}.{1}.{2}.1 - {0}.{1}.{3}.254'.format(octet1,octet2,network_address,broadcast_address))
    print('Broadcast Address: {0}.{1}.{2}.255'.format(octet1,octet2,broadcast_address))

  def classC():
    subnet_mask = 256 - 2^(32 - int(cidr))
    a = []
    for i in range(int(subnet_mask),int(octet4),-(256 - int(subnet_mask))):
      a.append(i)
      if a[len(a) - 1] > int(octet4):
          a.append(a[len(a) - 1] - (256 - subnet_mask))
    network_address = a[len(a) - 1]
    broadcast_address = a[len(a) - 2] - 1
    first_address = network_address + 1
    last_address = broadcast_address - 1
    print('Network Address: {0}.{1}.{2}.{3}'.format(octet1,octet2,octet3,network_address))
    print('Host Address Range: {0}.{1}.{2}.{3} - {0}.{1}.{2}.{4}'.format(octet1,octet2,octet3,first_address,last_address))
    print('Broadcast Address: {0}.{1}.{2}.{3}'.format(octet1,octet2,octet3,broadcast_address))

  if cidr >= 1 and cidr <= 16:
    classA()
  elif cidr >= 17 and cidr <= 24:
    classB()
  else:
    classC()

if __name__ == "__main__":
    main()

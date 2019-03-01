import os

def main():
    profile_name = input("Enter an existing profile name for your AWS account: ")
    os.system("aws ec2 run-instances --image-id ami-0dccf86d354af8ce3 --count 1 --instance-type t2.micro \
                --key-name wnet-keypair --profile {0}".format(profile_name))

if __name__ == "__main__":
    main()

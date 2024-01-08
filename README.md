# TerraformProj2
Creating EC2 instances with VPCs, Subnets and server to process app requests:
1. Create VPC
2. Create Internet Gateway
3. Create Custom Route Table 
4. Create a Subnet 
5. Associate Subnet with Route Table
6. Create Security Group to allow port 22,80,443
7. Create a network interface with an IP in the Subnet that was created in Step 4
8. Assign an elastic IP to the network interface creater in Step 7. 
9. Create Ubuntu server and install/enable Apache2
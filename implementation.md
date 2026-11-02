# Implementation Procedure

Region: `ap-south-1` (Mumbai). Use the same AWS account and Region for both VPCs.

## 1. Create VPC A

Create a VPC only named `ewb-vpc-a`, IPv4 CIDR `10.10.0.0/16`, no IPv6 CIDR, default tenancy. Create:
- `ewb-a-public` – `10.10.1.0/24`
- `ewb-a-private` – `10.10.2.0/24`

Use one Availability Zone for this single-AZ lab. Disable automatic public IPv4 assignment on the private subnet.

Create `ewb-igw-a` and attach it to VPC A. Create route table `ewb-rt-a-public`, associate only `ewb-a-public`, retain the local route and add `0.0.0.0/0` → `ewb-igw-a`. Create `ewb-rt-a-private`, associate `ewb-a-private`, and retain only the local route until peering is active.

## 2. Create VPC B

Create `ewb-vpc-b` with CIDR `10.20.0.0/16`. Create subnet `ewb-b-private` with CIDR `10.20.1.0/24`. Disable automatic public IPv4 assignment. Create `ewb-rt-b-private`, associate the subnet and retain its local route. Do not create an Internet Gateway or NAT Gateway for VPC B.

## 3. Create security groups

Create the groups in their respective VPCs. Configure inbound rules exactly as listed in `security.md`. Keep the default outbound allow-all rule for this lab. Use the current public IPv4 `/32` for bastion SSH; update that rule if the student's public IP changes.

## 4. Create the key pair

Create an RSA key pair named `ewb-lab`, download the private key once and protect it locally:
```bash
chmod 400 ~/Downloads/ewb-lab.pem
```
Never commit the PEM file to GitHub or include it in the report.

## 5. Launch EC2 instances

Use Amazon Linux 2023, architecture x86_64, and a lab-approved instance type. Check current pricing and account credits before launch. Assign the following private IPv4 addresses explicitly:

| Instance | Subnet | Private IPv4 | Public IPv4 |
|---|---|---:|---|
| `ewb-bastion` | `ewb-a-public` | `10.10.1.10` | Enabled |
| `ewb-app-a` | `ewb-a-private` | `10.10.2.10` | Disabled |
| `ewb-app-b` | `ewb-b-private` | `10.20.1.10` | Disabled |

Attach `ewb-sg-bastion` to the bastion, `ewb-sg-app-a` to App-A and `ewb-sg-app-b` to App-B. Use `ewb-lab` for all three. Verify that the private instances have no public IPv4 address.

## 6. Configure SSH ProxyJump

Copy `scripts/ssh-config.example` to `~/.ssh/config`, replace the bastion public IPv4 with the actual address shown by EC2, and ensure the key path points to the downloaded PEM file. Restrict config permissions:
```bash
chmod 600 ~/.ssh/config
```

## 7. Baseline test

Before creating peering, connect to App-A through the bastion and run:
```bash
ping -c 4 10.20.1.10
```
Record the actual output. No replies are expected because there is no peering route yet.

## 8. Create and accept peering

Create `ewb-a-b-peer` with VPC A as requester and VPC B as accepter, same account and Region. Accept the request. Wait for status `Active` and record the actual `pcx-...` ID.

## 9. Add peering routes

Add `10.20.0.0/16` → `ewb-a-b-peer` to:
- `ewb-rt-a-public`
- `ewb-rt-a-private`

Add `10.10.0.0/16` → `ewb-a-b-peer` to:
- `ewb-rt-b-private`

Do not remove the existing local routes or VPC A public default route.

## 10. Validate and demonstrate controlled failure

Run forward and reverse ping tests and SSH to App-B using the bastion. Then remove only App-B's inbound ICMP Echo Request rule sourced from `10.10.2.10/32`, repeat App-A's ping and record the failure. Restore the exact rule and record successful recovery.

## 11. Cleanup

Follow `submission-evidence.md` to save proof before deleting resources. Then perform the cleanup sequence in the repository README and the original student workbook.

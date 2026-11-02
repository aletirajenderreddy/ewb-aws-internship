# AWS VPC Peering – EWB Student Project

**Student:** Rajender Reddy  
**Project:** AWS VPC Peering – Private Connectivity Between Two VPCs  
**AWS Region:** Asia Pacific (Mumbai), `ap-south-1`  
**Project tag:** `Project=EWB-VPC-Peering`

## Project overview

This project builds two non-overlapping Amazon VPC networks and connects them with VPC Peering. The application instances remain private. A single public bastion host in VPC A provides the administrative SSH entry point.

The goal is to demonstrate that two private workloads can communicate through private IPv4 addresses after peering is activated and both VPC route tables contain the correct routes.

## Architecture

```text
                         Student laptop
                               |
                         SSH TCP/22
                               |
                         Internet Gateway
                               |
     VPC A: 10.10.0.0/16       |                VPC B: 10.20.0.0/16
  +----------------------------+--+          +---------------------------+
  | Public: 10.10.1.0/24        |          | Private: 10.20.1.0/24      |
  | Bastion 10.10.1.10          |          | App-B 10.20.1.10           |
  |       | SSH ProxyJump       |          |          ^                |
  | Private: 10.10.2.0/24       |          |          |                |
  | App-A 10.10.2.10            |<========>| VPC Peering (pcx)          |
  +-----------------------------+          +---------------------------+
```

VPC B has no Internet Gateway. App-A and App-B have no public IPv4 addresses. Peering carries private VPC-to-VPC traffic; it does not make VPC B use VPC A's internet gateway.

## Fixed network plan

| Resource | Name | CIDR / private IPv4 |
|---|---|---|
| VPC A | `ewb-vpc-a` | `10.10.0.0/16` |
| Public subnet A | `ewb-a-public` | `10.10.1.0/24` |
| Private subnet A | `ewb-a-private` | `10.10.2.0/24` |
| VPC B | `ewb-vpc-b` | `10.20.0.0/16` |
| Private subnet B | `ewb-b-private` | `10.20.1.0/24` |
| Bastion | `ewb-bastion` | `10.10.1.10` + public IPv4 |
| App-A | `ewb-app-a` | `10.10.2.10`, private only |
| App-B | `ewb-app-b` | `10.20.1.10`, private only |

## Resource naming

- Internet Gateway: `ewb-igw-a`
- Route tables: `ewb-rt-a-public`, `ewb-rt-a-private`, `ewb-rt-b-private`
- Security groups: `ewb-sg-bastion`, `ewb-sg-app-a`, `ewb-sg-app-b`
- Peering connection: `ewb-a-b-peer`
- EC2 key pair: `ewb-lab`

## Route table design

| Route table | Associated subnet | Destination | Target |
|---|---|---|---|
| `ewb-rt-a-public` | `ewb-a-public` | `10.10.0.0/16` | local |
| `ewb-rt-a-public` | `ewb-a-public` | `0.0.0.0/0` | `ewb-igw-a` |
| `ewb-rt-a-public` | `ewb-a-public` | `10.20.0.0/16` | `ewb-a-b-peer` |
| `ewb-rt-a-private` | `ewb-a-private` | `10.10.0.0/16` | local |
| `ewb-rt-a-private` | `ewb-a-private` | `10.20.0.0/16` | `ewb-a-b-peer` |
| `ewb-rt-b-private` | `ewb-b-private` | `10.20.0.0/16` | local |
| `ewb-rt-b-private` | `ewb-b-private` | `10.10.0.0/16` | `ewb-a-b-peer` |

The peering route is required on both sides. The public route table also receives the VPC B route so the bastion can reach App-B over its private address.

## Security design

| Security group | Inbound rule | Source |
|---|---|---|
| `ewb-sg-bastion` | SSH TCP/22 | Student's current public IPv4 `/32` |
| `ewb-sg-app-a` | SSH TCP/22 | `10.10.1.10/32` |
| `ewb-sg-app-a` | ICMPv4 Echo Request | `10.20.1.10/32` |
| `ewb-sg-app-b` | SSH TCP/22 | `10.10.1.10/32` |
| `ewb-sg-app-b` | ICMPv4 Echo Request | `10.10.2.10/32` |

Default outbound allow-all rules are retained for this isolated beginner lab. Security groups are stateful. Do not expose SSH or ICMP to `0.0.0.0/0`.

## Build sequence

1. Create VPC A and its two subnets.
2. Attach `ewb-igw-a`; create and associate the public and private route tables.
3. Create VPC B, its private subnet and its private route table.
4. Create the three security groups with the exact inbound rules above.
5. Create the `ewb-lab` key pair and launch the bastion, App-A and App-B with the assigned private addresses.
6. Confirm the two application instances have no public IPv4 address.
7. Configure SSH ProxyJump from the laptop through the bastion.
8. Test baseline failure before peering.
9. Create and accept `ewb-a-b-peer`; add the three peering routes.
10. Test forward ping, reverse ping and SSH to App-B.
11. Remove only App-B's ICMP Echo Request rule to demonstrate controlled failure; restore it and demonstrate recovery.
12. Capture genuine screenshots and terminal output, then clean up all lab resources.

## Verification commands

Run from App-A:
```bash
hostname
hostname -I
ping -c 4 10.20.1.10
```

Run from App-B:
```bash
hostname
hostname -I
ping -c 4 10.10.2.10
```

From the laptop, after configuring SSH aliases:
```bash
ssh ewb-app-b
```

Expected acceptance criteria after peering and route/security configuration: four ping replies in each direction, zero packet loss, and a shell on App-B reached through the bastion. These are expected outcomes, not claims that the AWS environment has already been tested.

## Evidence and factual accuracy

This repository contains the project design, configuration plan, commands and evidence checklist. AWS-generated resource IDs, the bastion public IPv4 address, terminal output, screenshots, and cleanup proof must be captured from the student's own AWS account. They are deliberately not fabricated in this repository.

See [`docs/submission-evidence.md`](docs/submission-evidence.md) for the exact evidence set required by the workbook.

## Cost and cleanup

EC2, EBS and public IPv4 usage may incur charges. This lab does not require a NAT Gateway. Save evidence first, then terminate the three instances, remove leftover lab EBS volumes and snapshots, delete peering routes and the peering connection, delete the security groups, subnets and custom route tables, detach/delete the internet gateway, and delete both VPCs. Check the Billing console after cleanup because usage reporting can be delayed.

## Repository contents

- `docs/` – architecture, implementation, routing, security, testing, troubleshooting and submission guidance.
- `scripts/` – SSH client configuration example and connectivity test commands.
- `terraform/` – infrastructure-as-code implementation notes and variable-free design reference.
- `evidence/` – evidence checklist and an index for genuine screenshots.

# Submission Evidence Register

The EWB workbook requires a report that another student can understand and reproduce. The final PDF must show the student's own AWS execution evidence.

## Required evidence

| Evidence ID | Screenshot / output | What it must show |
|---|---|---|
| E01 | VPC inventory | `ewb-vpc-a`, `ewb-vpc-b`, CIDRs and actual VPC IDs |
| E02 | Subnets | Three subnet names, CIDRs, VPC associations and actual subnet IDs |
| E03 | Route tables | All three route tables, their subnet associations and all routes |
| E04 | Internet Gateway | `ewb-igw-a` attached to VPC A |
| E05 | Security groups | Inbound rules for bastion, App-A and App-B |
| E06 | EC2 inventory | Three instance names, private IPs and actual instance IDs |
| E07 | Private isolation | App-A and App-B have no public IPv4 address |
| E08 | Peering | `ewb-a-b-peer`, Active status, requester/accepter VPCs and actual `pcx-...` ID |
| E09 | Baseline | App-A ping to `10.20.1.10` before peering; no replies |
| E10 | Forward and reverse | Successful private-IP pings in both directions |
| E11 | SSH | Terminal shell on App-B through the bastion |
| E12 | Controlled failure | App-B ICMP rule removed and ping fails |
| E13 | Recovery | Exact ICMP rule restored and ping succeeds |
| E14 | Cleanup | Lab resources removed and remaining billable resources checked |

## Resource inventory to record

Capture the actual IDs from the AWS console:
- VPC IDs for `ewb-vpc-a` and `ewb-vpc-b`
- Subnet IDs for all three subnets
- Route table IDs for all three route tables
- Internet Gateway ID
- Security Group IDs
- EC2 instance IDs
- VPC peering connection ID
- Bastion public IPv4 address (do not expose private key material)

## Screenshot naming

Use names such as:
- `E01-vpc-inventory.png`
- `E08-peering-active.png`
- `E10-forward-ping-success.png`
- `E11-ssh-app-b.png`

Each screenshot should include a short caption naming the host, test and observed result. Keep private keys, passwords and access tokens out of screenshots and the report.

## Report integrity

This repository supplies the written design and expected acceptance criteria. Do not describe an expected result as a test that has passed. Add the student's real AWS IDs, screenshots and command output only after the corresponding task is performed. If cleanup has not yet been completed, state that clearly.

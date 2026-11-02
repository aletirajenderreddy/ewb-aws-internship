# Security configuration

| Security group | VPC | Inbound rule | Source |
|---|---|---|---|
| ewb-sg-bastion | VPC A | SSH TCP/22 | Student's current public IPv4 `/32` |
| ewb-sg-app-a | VPC A | SSH TCP/22 | `10.10.1.10/32` |
| ewb-sg-app-a | VPC A | ICMPv4 Echo Request | `10.20.1.10/32` |
| ewb-sg-app-b | VPC B | SSH TCP/22 | `10.10.1.10/32` |
| ewb-sg-app-b | VPC B | ICMPv4 Echo Request | `10.10.2.10/32` |

Security groups are stateful. Keep default outbound allow-all rules for this workbook. Use default network ACLs. Never expose SSH or ICMP to `0.0.0.0/0`. The Bastion SSH source must be updated if the student's public IP changes.

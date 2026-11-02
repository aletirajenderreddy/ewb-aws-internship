# Security Group Design

Security groups are stateful virtual firewalls attached to network interfaces. This lab allows only the SSH and ICMP traffic required by the three hosts.

| Group | Attached to | Protocol / type | Port | Source |
|---|---|---|---|---|
| `ewb-sg-bastion` | Bastion | TCP / SSH | 22 | Student public IPv4 `/32` |
| `ewb-sg-app-a` | App-A | TCP / SSH | 22 | `10.10.1.10/32` |
| `ewb-sg-app-a` | App-A | ICMPv4 Echo Request | — | `10.20.1.10/32` |
| `ewb-sg-app-b` | App-B | TCP / SSH | 22 | `10.10.1.10/32` |
| `ewb-sg-app-b` | App-B | ICMPv4 Echo Request | — | `10.10.2.10/32` |

For ICMP Echo Request, select Custom ICMP - IPv4 and type 8, code 0 if the console asks. Keep default outbound allow-all rules for this learning lab. Use default network ACLs; custom network ACLs require explicit return-traffic rules.

## Least-privilege notes

- Never use `0.0.0.0/0` as the SSH source.
- The application hosts do not need public IP addresses.
- When SSH is proxied through the bastion, App-B sees the bastion's private IP as the source.
- If the bastion private address changes, update both application security groups.
- During the controlled failure test, remove only the App-B ICMP Echo Request rule. Do not remove SSH access.

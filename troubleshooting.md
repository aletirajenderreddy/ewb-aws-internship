# Troubleshooting quick reference

- Bastion SSH timeout: verify current Bastion public IPv4, your public IPv4 `/32` in `ewb-sg-bastion`, public subnet association, attached IGW, and `0.0.0.0/0` route.
- App-A SSH failure: verify App-A private IP, TCP/22 from `10.10.1.10/32`, key pair, `ec2-user`, and instance status.
- App-B SSH failure: verify peering Active, public subnet A route to VPC B, VPC B return route, App-B SSH source `10.10.1.10/32`.
- Ping failure after peering: verify both private route tables, correct `pcx-...`, destination ICMP Echo Request rule, and actual host IPs.
- Peering creation failure: check all primary and secondary VPC CIDRs for overlap.
- `Permission denied (publickey)`: check correct PEM, local file permissions, IdentityFile and `ec2-user`.
- Private instance package downloads fail: expected; this lab has no NAT gateway or private internet egress.

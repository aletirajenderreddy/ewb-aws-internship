# Troubleshooting Guide

## Peering status is not Active

Confirm the request was accepted, requester and accepter VPCs are correct, and both VPCs are in the intended account and Region. Wait for the connection status to become Active before adding routes.

## Ping fails after peering

Check all of the following:
1. App-A and App-B are using the intended private IPv4 addresses.
2. `ewb-rt-a-private` contains `10.20.0.0/16` → peering.
3. `ewb-rt-b-private` contains `10.10.0.0/16` → peering.
4. App-A security group permits ICMP Echo Request from `10.20.1.10/32`.
5. App-B security group permits ICMP Echo Request from `10.10.2.10/32`.
6. The peering connection is Active and the VPC CIDRs do not overlap.
7. The instances are running and the operating-system firewall is not blocking ICMP.

## SSH to App-B fails

Confirm:
- Bastion has a public IPv4 address and VPC A public route table has `0.0.0.0/0` → Internet Gateway.
- Bastion security group allows TCP/22 from the student's current public IPv4 `/32`.
- App-B security group allows TCP/22 from `10.10.1.10/32`.
- `ewb-rt-a-public` and `ewb-rt-b-private` contain the appropriate peering routes.
- SSH uses the correct key file and `ec2-user` username.
- Key permissions are restrictive (`chmod 400`).

## Common mistakes

- Adding the remote route only to one VPC.
- Adding the route to a route table that is not associated with the instance subnet.
- Entering the source CIDR in the Port field rather than Source.
- Using a public IP as the ping destination instead of the peer's private IP.
- Giving App-A or App-B a public IPv4 address.
- Expecting VPC peering to provide transitive internet access.

# Architecture and Design Rationale

## Objective

Establish private IPv4 connectivity between an application workload in VPC A and a second application workload in VPC B using VPC Peering. Administration is performed through one public bastion host in VPC A.

## Addressing

The VPC CIDRs are `10.10.0.0/16` and `10.20.0.0/16`. They do not overlap, which is a prerequisite for ordinary VPC peering routing. Each subnet is a `/24` contained within its parent VPC.

| Network | CIDR | Purpose |
|---|---|---|
| VPC A | `10.10.0.0/16` | Bastion and App-A |
| Public subnet A | `10.10.1.0/24` | Bastion administration entry |
| Private subnet A | `10.10.2.0/24` | Private App-A workload |
| VPC B | `10.20.0.0/16` | App-B workload |
| Private subnet B | `10.20.1.0/24` | Private App-B workload |

## Traffic paths

**Administration to App-B:** Laptop → internet → VPC A Internet Gateway → bastion public IPv4 → SSH ProxyJump → App-B private IPv4. The bastion initiates a separate SSH connection to App-B using source address `10.10.1.10`.

**Application traffic:** App-A (`10.10.2.10`) → VPC A private route table → VPC peering connection → VPC B private route table → App-B (`10.20.1.10`). The return packet follows the reverse route through the peering connection.

## Design boundaries

- Only the bastion receives a public IPv4 address.
- App-A and App-B remain private.
- VPC B has no Internet Gateway and no NAT Gateway.
- VPC peering is not transitive routing.
- Peering alone does not create routes or security permissions.
- Both directions require appropriate route-table entries; security groups must allow the intended inbound traffic.

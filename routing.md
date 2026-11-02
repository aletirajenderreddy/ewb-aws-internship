# Routing and traffic flow

VPC peering is a private, one-to-one connection between VPCs. It is non-transitive. Peering alone does not install routes or grant security-group permission.

## Forward path: App-A to App-B
App-A (`10.10.2.10`) -> VPC A private route table -> `10.20.0.0/16` via active peering -> VPC B -> App-B (`10.20.1.10`).

## Return path
App-B -> VPC B private route table -> `10.10.0.0/16` via the same peering -> VPC A -> App-A.

## Bastion path to App-B
Laptop -> Bastion public IPv4 (SSH/22) -> Bastion private IP `10.10.1.10` -> VPC A public route table -> `10.20.0.0/16` via peering -> App-B private IP `10.20.1.10`.

The public route table needs a peering route because ProxyJump makes the bastion establish a separate SSH connection to App-B. Peering does not give VPC B internet access through VPC A's Internet Gateway.

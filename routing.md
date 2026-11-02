# Route Table Configuration

VPC peering is not a router that automatically edits VPC route tables. Each participating subnet's route table needs a destination route for the remote VPC CIDR.

| Route table | Subnet association | Destination | Target |
|---|---|---|---|
| `ewb-rt-a-public` | `ewb-a-public` | `10.10.0.0/16` | local |
| `ewb-rt-a-public` | `ewb-a-public` | `0.0.0.0/0` | `ewb-igw-a` |
| `ewb-rt-a-public` | `ewb-a-public` | `10.20.0.0/16` | `ewb-a-b-peer` |
| `ewb-rt-a-private` | `ewb-a-private` | `10.10.0.0/16` | local |
| `ewb-rt-a-private` | `ewb-a-private` | `10.20.0.0/16` | `ewb-a-b-peer` |
| `ewb-rt-b-private` | `ewb-b-private` | `10.20.0.0/16` | local |
| `ewb-rt-b-private` | `ewb-b-private` | `10.10.0.0/16` | `ewb-a-b-peer` |

## Why each peering route exists

- Public route table A: permits the bastion subnet to route to VPC B's private network.
- Private route table A: permits App-A to route to App-B.
- Private route table B: provides the return route from App-B to VPC A.

The route target is the actual peering connection created in the AWS account. In the console, it appears as a `pcx-...` identifier. The repository uses the connection name for readability; the AWS route table stores the actual connection target ID.

## Route verification

For each route table, inspect the Routes tab and Subnet associations tab. Confirm the correct subnet association and that the peering route status is active. A route in the wrong route table does not help a subnet associated with another table.

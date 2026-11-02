# Validation Plan and Expected Results

The expected results below are acceptance criteria. They are not recorded execution results. Replace no results with assumptions: capture the terminal output produced by the actual AWS instances.

| Test | Where | Command / action | Expected result |
|---|---|---|---|
| Baseline | App-A before peering | `ping -c 4 10.20.1.10` | No replies |
| Forward path | App-A after routes | `ping -c 4 10.20.1.10` | Four replies; 0% packet loss |
| Reverse path | App-B after routes | `ping -c 4 10.10.2.10` | Four replies; 0% packet loss |
| Private SSH | Student laptop | `ssh ewb-app-b` | Shell on App-B through bastion |
| Isolation | EC2 instance details | Inspect App-A and App-B | No public IPv4 on either host |
| Controlled failure | App-A after removing App-B ICMP rule | `ping -c 4 10.20.1.10` | No replies |
| Recovery | App-A after restoring rule | `ping -c 4 10.20.1.10` | Four replies; 0% packet loss |

## Commands

On App-A:
```bash
hostname
hostname -I
ping -c 4 10.20.1.10
```

On App-B:
```bash
hostname
hostname -I
ping -c 4 10.10.2.10
```

From the laptop:
```bash
ssh ewb-app-b
```

If the first ping loses a packet while the instance is still initializing, wait briefly and repeat the four-packet test. Save the real output for both attempts if relevant.

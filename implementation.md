# Implementation runbook

Follow the EWB workbook sequence. Console labels may vary slightly.

## 1. Sign in and select Region
1. Sign in at https://console.aws.amazon.com/.
2. Select Asia Pacific (Mumbai), `ap-south-1`.
3. Check Billing/Credits and current pricing before launching resources.

## 2. Build VPCs and subnets
Create VPC A (`10.10.0.0/16`) and VPC B (`10.20.0.0/16`) using **VPC only**.
Create:
- VPC A public subnet `ewb-a-public`: `10.10.1.0/24`
- VPC A private subnet `ewb-a-private`: `10.10.2.0/24`
- VPC B private subnet `ewb-b-private`: `10.20.1.0/24`
Use the same AZ where available for this lab. Disable auto-assign public IPv4 on private subnets.

## 3. Internet gateway and route tables
Create `ewb-igw-a`, attach it to VPC A.
Create and explicitly associate:
- `ewb-rt-a-public` -> `ewb-a-public`
- `ewb-rt-a-private` -> `ewb-a-private`
- `ewb-rt-b-private` -> `ewb-b-private`
Initially keep only local routes in private route tables. Public route table gets `0.0.0.0/0` -> `ewb-igw-a`.

## 4. Security groups
Create the three groups in the correct VPCs:
- `ewb-sg-bastion`: inbound SSH TCP/22 from your current public IPv4 `/32`.
- `ewb-sg-app-a`: SSH TCP/22 from `10.10.1.10/32`; ICMPv4 Echo Request from `10.20.1.10/32`.
- `ewb-sg-app-b`: SSH TCP/22 from `10.10.1.10/32`; ICMPv4 Echo Request from `10.10.2.10/32`.
Keep default outbound rules. Use default allow-all network ACLs for this beginner lab.

## 5. EC2 instances
Create RSA key pair `ewb-lab`, download PEM and protect it locally (`chmod 400 ~/.ssh/ewb-lab.pem`). Do not upload it.
Launch Amazon Linux 2023 x86 instances using instructor-approved small instance type:
- `ewb-bastion`: VPC A public subnet, private IP `10.10.1.10`, public IPv4 enabled, `ewb-sg-bastion`.
- `ewb-app-a`: VPC A private subnet, private IP `10.10.2.10`, no public IPv4, `ewb-sg-app-a`.
- `ewb-app-b`: VPC B private subnet, private IP `10.20.1.10`, no public IPv4, `ewb-sg-app-b`.
Wait for Running and 2/2 status checks.

## 6. Configure SSH on Linux laptop
Copy PEM into `~/.ssh/ewb-lab.pem`, then:
```bash
chmod 400 ~/.ssh/ewb-lab.pem
nano ~/.ssh/config
```
Use `scripts/ssh-config.example`, replacing `BASTION_PUBLIC_IP` with the actual current public IPv4. Then:
```bash
chmod 600 ~/.ssh/config
ssh ewb-bastion
ssh ewb-app-a
```
Before peering, App-B SSH is expected to fail. From App-A run baseline:
```bash
ping -c 4 10.20.1.10
```
Save the real failed result.

## 7. Create VPC peering
Create `ewb-a-b-peer`, requester VPC A, accepter VPC B, same account and Region. Accept the request. Wait for Active and record `pcx-...`.

## 8. Add peering routes
Add the active peering target:
- `ewb-rt-a-private`: `10.20.0.0/16` -> `pcx-...`
- `ewb-rt-b-private`: `10.10.0.0/16` -> `pcx-...`
- `ewb-rt-a-public`: `10.20.0.0/16` -> `pcx-...`
Do not remove local or Internet Gateway routes.

## 9. Validate
From App-A:
```bash
ping -c 4 10.20.1.10
```
From App-B:
```bash
ping -c 4 10.10.2.10
```
From laptop:
```bash
ssh ewb-app-b
```
Capture actual terminal output. Verify App-A/App-B have no public IPv4.

## 10. Controlled failure and recovery
Temporarily remove only App-B inbound ICMPv4 Echo Request from `10.10.2.10/32`. Repeat forward ping; it should fail. Restore the exact rule and repeat; it should succeed. Keep SSH rule intact.

## 11. Cleanup
After evidence/report is saved: terminate three instances; verify lab EBS volumes/snapshots; delete peer routes and peering; delete SGs after ENIs disappear; remove subnet associations and custom route tables; delete subnets; detach/delete IGW; delete VPCs; remove unused key pair. Check Billing for residual resources.

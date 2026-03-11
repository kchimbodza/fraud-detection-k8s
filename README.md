# fraud-detection-k8s

A Kubernetes demo using a financial transaction processor that flags suspicious amounts above the FINTRAC $10,000 CAD reporting threshold. Built to demonstrate core Kubernetes concepts on a self-hosted 3-node k3s cluster running on KVM/QEMU.

## What This Demonstrates

| Concept | How |
|---|---|
| **Self-healing** | Delete a pod — Kubernetes restarts it automatically |
| **Horizontal autoscaling (HPA)** | Flood with traffic — pods scale from 1 → 5, back to 1 when idle |
| **Load balancing** | Every response includes `handled_by: <pod-name>` showing traffic distributed across replicas |
| **Rolling updates** | Apply v2 manifest — old pods replaced one by one, zero downtime |
| **Namespaces** | All workloads isolated in the `fintech` namespace |

## Infrastructure

- **Hypervisor:** KVM/QEMU on Nobara Linux
- **Nodes:** 3x Ubuntu 22.04 VMs (k3s-control, k3s-worker-1, k3s-worker-2)
- **Kubernetes:** k3s
- **App:** Python 3.11 + FastAPI

## API

**Health check**
```
GET /
```
```json
{ "status": "ok", "pod": "transaction-processor-abc123", "version": "v1" }
```

**Process transaction**
```
POST /transaction
{ "merchant": "TD Bank", "amount": 15000, "currency": "CAD" }
```
```json
{
  "status": "flagged",
  "merchant": "TD Bank",
  "amount": 15000.0,
  "currency": "CAD",
  "fintrac_report_required": true,
  "handled_by": "transaction-processor-abc123",
  "version": "v1"
}
```

## Deploy

### 1. Build and push the image
```bash
cd app/
docker build -t kchimbodza/fraud-detection-k8s:v1 .
docker push kchimbodza/fraud-detection-k8s:v1
```

### 2. Deploy to cluster
```bash
kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
kubectl apply -f k8s/hpa.yaml
```

### 3. Verify
```bash
kubectl get pods -n fintech
kubectl get svc -n fintech
```

## Demos

### Self-healing
```bash
bash scripts/demo-self-healing.sh
```

### Load test (triggers HPA)
```bash
# Terminal 1 - watch pods scale
kubectl get pods -n fintech -w

# Terminal 2 - send traffic
bash scripts/load-test.sh
```

### Rolling update
```bash
bash scripts/demo-rolling-update.sh
```

## Project Structure

```
fraud-detection-k8s/
├── app/
│   ├── main.py
│   ├── Dockerfile
│   └── requirements.txt
├── infrastructure/
│   └── create-vms.sh
├── k8s/
│   ├── namespace.yaml
│   ├── deployment.yaml
│   ├── service.yaml
│   ├── hpa.yaml
│   └── rolling-update/
│       └── deployment-v2.yaml
└── scripts/
    ├── demo-self-healing.sh
    ├── demo-rolling-update.sh
    └── load-test.sh
```

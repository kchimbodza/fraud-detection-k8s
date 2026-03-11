#!/bin/bash
SERVICE_IP=$(kubectl get svc transaction-processor -n fintech -o jsonpath="{.status.loadBalancer.ingress[0].ip}")
URL="http://$SERVICE_IP/transaction"

echo "=== Rolling Update Demo ==="
echo ""

echo "[1] Current version:"
curl -s http://$SERVICE_IP/ | python3 -c "import sys,json; r=json.load(sys.stdin); print(f\"  version: {r['version']} | pod: {r['pod']}\")"
echo ""

echo "[2] Applying v2 deployment..."
kubectl apply -f k8s/rolling-update/deployment-v2.yaml
echo ""

echo "[3] Watching pods update one by one (zero downtime)..."
kubectl rollout status deployment/transaction-processor -n fintech
echo ""

echo "[4] New version:"
curl -s http://$SERVICE_IP/ | python3 -c "import sys,json; r=json.load(sys.stdin); print(f\"  version: {r['version']} | pod: {r['pod']}\")"

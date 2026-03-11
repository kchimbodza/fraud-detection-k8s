#!/bin/bash
SERVICE_IP=$(kubectl get svc transaction-processor -n fintech -o jsonpath="{.status.loadBalancer.ingress[0].ip}")
URL="http://$SERVICE_IP/transaction"

echo "=== Load Test — triggers HPA scaling ==="
echo "Sending requests to $URL"
echo "Watch pods in another terminal: kubectl get pods -n fintech -w"
echo ""

for i in $(seq 1 200); do
  curl -s -X POST $URL \
    -H "Content-Type: application/json" \
    -d "{\"merchant\": \"Test Merchant\", \"amount\": $((RANDOM % 20000))}" \
    | python3 -c "import sys,json; r=json.load(sys.stdin); print(f\"[{$i}] {r['status']} | pod: {r['handled_by']} | version: {r['version']}\")"
  sleep 0.1
done

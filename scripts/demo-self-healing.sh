#!/bin/bash
echo "=== Self-Healing Demo ==="
echo ""

echo "[1] Current pods:"
kubectl get pods -n fintech
echo ""

POD=$(kubectl get pod -n fintech -l app=transaction-processor -o jsonpath="{.items[0].metadata.name}")
echo "[2] Deleting pod: $POD"
kubectl delete pod $POD -n fintech
echo ""

echo "[3] Watching Kubernetes restart it automatically..."
kubectl get pods -n fintech -w

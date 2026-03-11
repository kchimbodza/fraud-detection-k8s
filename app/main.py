import os
from fastapi import FastAPI
from pydantic import BaseModel

app = FastAPI()

POD_NAME = os.getenv("POD_NAME", "local")
APP_VERSION = os.getenv("APP_VERSION", "v1")
FINTRAC_THRESHOLD = 10000.00


class Transaction(BaseModel):
    merchant: str
    amount: float
    currency: str = "CAD"


@app.get("/")
def health():
    return {"status": "ok", "pod": POD_NAME, "version": APP_VERSION}


@app.post("/transaction")
def process_transaction(tx: Transaction):
    flagged = tx.amount >= FINTRAC_THRESHOLD
    return {
        "status": "flagged" if flagged else "approved",
        "merchant": tx.merchant,
        "amount": tx.amount,
        "currency": tx.currency,
        "fintrac_report_required": flagged,
        "handled_by": POD_NAME,
        "version": APP_VERSION,
    }

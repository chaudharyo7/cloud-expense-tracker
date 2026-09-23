from datetime import date

from flask import Blueprint, jsonify, request

from .db import get_connection

api = Blueprint("api", __name__)


@api.get("/health")
def health():
    return jsonify({"status": "ok", "service": "expense-api"})


@api.get("/expenses")
def list_expenses():
    with get_connection() as conn:
        with conn.cursor() as cur:
            cur.execute(
                """
                SELECT id, amount, category, description, expense_date, created_at
                FROM expenses
                ORDER BY expense_date DESC, id DESC
                """
            )
            rows = cur.fetchall()

    for row in rows:
        row["amount"] = float(row["amount"])
        row["expense_date"] = row["expense_date"].isoformat()
        row["created_at"] = row["created_at"].isoformat()

    return jsonify(rows)


@api.post("/expenses")
def create_expense():
    data = request.get_json(silent=True) or {}

    amount = data.get("amount")
    category = data.get("category")
    description = data.get("description", "")
    expense_date = data.get("expense_date")

    if amount in (None, "") or not category or not expense_date:
        return jsonify({
            "error": "amount, category and expense_date are required"
        }), 400

    try:
        amount = float(amount)
        parsed_date = date.fromisoformat(expense_date)
    except (ValueError, TypeError):
        return jsonify({"error": "Invalid amount or date"}), 400

    if amount <= 0:
        return jsonify({"error": "Amount must be greater than 0"}), 400

    with get_connection() as conn:
        with conn.cursor() as cur:
            cur.execute(
                """
                INSERT INTO expenses (amount, category, description, expense_date)
                VALUES (%s, %s, %s, %s)
                RETURNING id, amount, category, description, expense_date, created_at
                """,
                (amount, category, description, parsed_date),
            )
            row = cur.fetchone()
        conn.commit()

    row["amount"] = float(row["amount"])
    row["expense_date"] = row["expense_date"].isoformat()
    row["created_at"] = row["created_at"].isoformat()

    return jsonify(row), 201


@api.delete("/expenses/<int:expense_id>")
def delete_expense(expense_id):
    with get_connection() as conn:
        with conn.cursor() as cur:
            cur.execute(
                "DELETE FROM expenses WHERE id = %s RETURNING id",
                (expense_id,),
            )
            deleted = cur.fetchone()
        conn.commit()

    if not deleted:
        return jsonify({"error": "Expense not found"}), 404

    return jsonify({"message": "Expense deleted successfully"})

const API_BASE = "http://localhost:8000/api";

const form = document.getElementById("expense-form");
const amount = document.getElementById("amount");
const category = document.getElementById("category");
const description = document.getElementById("description");
const expenseDate = document.getElementById("expense-date");
const message = document.getElementById("message");
const list = document.getElementById("expense-list");
const empty = document.getElementById("empty");
const total = document.getElementById("total");
const monthTotal = document.getElementById("month-total");
const expenseCount = document.getElementById("expense-count");
const health = document.getElementById("health");

expenseDate.value = new Date().toISOString().slice(0, 10);

function money(value) {
  return new Intl.NumberFormat("en-IN", {
    style: "currency",
    currency: "INR",
  }).format(value);
}

async function checkHealth() {
  try {
    const response = await fetch(`${API_BASE}/health`);
    if (!response.ok) throw new Error();
    health.textContent = "API online";
  } catch {
    health.textContent = "API offline";
  }
}

async function loadExpenses() {
  try {
    const response = await fetch(`${API_BASE}/expenses`);
    if (!response.ok) throw new Error("Failed to load expenses");

    const expenses = await response.json();

    list.innerHTML = "";
    empty.style.display = expenses.length ? "none" : "block";

    let allTotal = 0;
    let currentMonthTotal = 0;
    const currentMonth = new Date().toISOString().slice(0, 7);

    expenses.forEach((expense) => {
      allTotal += Number(expense.amount);

      if (expense.expense_date.slice(0, 7) === currentMonth) {
        currentMonthTotal += Number(expense.amount);
      }

      const row = document.createElement("tr");
      row.innerHTML = `
        <td>${expense.expense_date}</td>
        <td>${escapeHtml(expense.category)}</td>
        <td>${escapeHtml(expense.description || "-")}</td>
        <td>${money(expense.amount)}</td>
        <td>
          <button class="delete" data-id="${expense.id}">Delete</button>
        </td>
      `;

      list.appendChild(row);
    });

    total.textContent = money(allTotal);
    monthTotal.textContent = money(currentMonthTotal);
    expenseCount.textContent = `${expenses.length} expense${expenses.length === 1 ? "" : "s"}`;
  } catch (error) {
    message.textContent = error.message;
  }
}

form.addEventListener("submit", async (event) => {
  event.preventDefault();

  message.textContent = "Saving...";

  try {
    const response = await fetch(`${API_BASE}/expenses`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        amount: amount.value,
        category: category.value,
        description: description.value,
        expense_date: expenseDate.value,
      }),
    });

    const data = await response.json();

    if (!response.ok) {
      throw new Error(data.error || "Failed to save expense");
    }

    form.reset();
    expenseDate.value = new Date().toISOString().slice(0, 10);
    message.textContent = "Expense added successfully.";
    await loadExpenses();
  } catch (error) {
    message.textContent = error.message;
  }
});

list.addEventListener("click", async (event) => {
  if (!event.target.classList.contains("delete")) return;

  const id = event.target.dataset.id;

  try {
    const response = await fetch(`${API_BASE}/expenses/${id}`, {
      method: "DELETE",
    });

    const data = await response.json();

    if (!response.ok) throw new Error(data.error || "Delete failed");

    await loadExpenses();
  } catch (error) {
    message.textContent = error.message;
  }
});

document.getElementById("refresh").addEventListener("click", loadExpenses);

function escapeHtml(value) {
  return String(value)
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll('"', "&quot;")
    .replaceAll("'", "&#039;");
}

checkHealth();
loadExpenses();

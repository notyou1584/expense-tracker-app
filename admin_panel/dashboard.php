<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Admin Dashboard</title>
  
  <style>
    body {
      font-family: Arial, sans-serif;
      margin: 0;
      padding: 0;
    }
    .container {
      display: flex;
      height: 100vh;
    }   
    .sidebar {
      flex: 0 0 200px;  
      background-color: #333;
      color: white;
      padding-top: 20px;  
    }
    .sidebar label {
      display: block;
      margin: 10px 0;
      padding-left: 10px;
    }
    .sidebar select {
      width: 100%;
      padding: 10px;
      margin: 0 0 10px;
      border: none;
      background-color: #555;
      color: white;
      font-size: 16px;
      cursor: pointer;
    }
    .content {
      flex: 1;
      padding: 20px;
    }
    h2 {
      margin-top: 0;
    }
    table {
      width: 100%;
      border-collapse: collapse;
    }
    th, td {
      padding: 8px;
      border-bottom: 1px solid #ddd;
      text-align: left;
    }
    th {
      background-color: #f2f2f2;
    }
  </style>
</head>
<body>

<div class="container">
  <div class="sidebar">
    <label for="dashboard-option">Expense-O</label>
    <select id="dashboard-option" onchange="selectOption(this)">
      <option value="dashboard">Dashboard</option>
      <option value="datatables">Data Tables</option> <!-- Added Data Tables option -->
    </select>
    <div id="datatables-options" style="display:none;">
      <select id="datatables-option" onchange="openDataTable(this)">
        <option value="user">User Table</option>
        <option value="expense">Expense Table</option>
      </select>
    </div>
  </div>

  <div class="content" id="dashboard">
    <h2>Admin Dashboard</h2>
    <div id="expense" style="display:none;">
      <h3>Expense Overview</h3>
      <table>
        <thead>
          <tr>
            <th>Date</th>
            <th>Amount</th>
            <th>Description</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td>2024-02-14</td>
            <td>$50</td>
            <td>Office Supplies</td>
          </tr>
          <tr>
            <td>2024-02-15</td>
            <td>$100</td>
            <td>Internet Bill</td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</div>

<script>
  function selectOption(select) {
    var selectedOption = select.value;
    var dashboardDiv = document.getElementById("dashboard");
    var datatablesOptionsDiv = document.getElementById("datatables-options");

    if (selectedOption === "dashboard") {
      dashboardDiv.style.display = "block";
      datatablesOptionsDiv.style.display = "none";
    } else if (selectedOption === "datatables") {
      dashboardDiv.style.display = "none";
      datatablesOptionsDiv.style.display = "block";
    }
  }

  function openDataTable(select) {
    var selectedOption = select.value;
    if (selectedOption === "user") {
      window.open("data.php", "_blank"); // Open data.php in a new window/tab
    } else if (selectedOption === "expense") {
      window.open("expense_tbl.php", "_blank"); // Open expense_data.php in a new window/tab
    }
  }
</script>

</body>
</html>

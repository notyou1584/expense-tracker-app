<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Data Tables</title>
  <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.11.5/css/jquery.dataTables.css">
  <style>
    body {
      font-family: Arial, sans-serif;
      margin: 0;
      padding: 0;
      background-color: #f5f5f5;
    }
    .container {
      max-width: 1200px;
      margin: 20px auto;
      padding: 20px;
      background-color: #fff;
      border-radius: 8px;
      box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
    }
    h1 {
      text-align: center;
      margin-bottom: 20px;
    }
    table.dataTable {
      width: 100%;
      border-collapse: collapse;
      margin-top: 20px;
    }
    table.dataTable th, table.dataTable td {
      padding: 10px;
      border-bottom: 1px solid #ddd;
      text-align: left;
    }
    table.dataTable th {
      background-color: #f2f2f2;
      font-weight: bold;
    }
    table.dataTable tbody tr:nth-child(even) {
      background-color: #f9f9f9;
    }
    table.dataTable tbody tr:hover {
      background-color: #f0f0f0;
    }
  </style>
</head>
<body>

<div class="container">
  <h1>Expense Data</h1>

  <table id="dataTable" class="display">
    <thead>
        <tr>
            <th>firebase_id</th>
            <th>amount</th>
            <th>currency</th>
            <th>description</th>
            <th>category</th>
            <th>date</th>
            <th>timestamp</th>
            <th>status</th>
        </tr>
    </thead>
    <tbody>
        <?php
        // Database connection parameters
        $servername = "localhost";  // Change to your server name
        $username = "root";          // Change to your database username
        $password = "";              // Change to your database password
        $dbname = "expense-o";   // Change to your database name

        // Create connection
        $conn = new mysqli($servername, $username, $password, $dbname);

        // Check connection
        if ($conn->connect_error) {
            die("Connection failed: " . $conn->connect_error);
        }

        // Query to retrieve data from the SQL table
        $sql = "SELECT firebase_id, amount, currency, description, category, date, timestamp, status FROM expenses";  // Replace 'your_table' with your actual table name
        $result = $conn->query($sql);

        // Check if query was successful
        if ($result->num_rows > 0) {
            // Loop through each row of the result and output table rows
            while($row = $result->fetch_assoc()) {
                echo "<tr>";
                echo "<td>" . $row['firebase_id'] . "</td>";      // Output 'firebase_id' column value
                echo "<td>" . $row['amount'] . "</td>";           // Output 'amount' column value
                echo "<td>" . $row['currency'] . "</td>";         // Output 'currency' column value
                echo "<td>" . $row['description'] . "</td>";      // Output 'description' column value
                echo "<td>" . $row['category'] . "</td>";         // Output 'category' column value
                echo "<td>" . $row['date'] . "</td>";             // Output 'date' column value
                echo "<td>" . $row['timestamp'] . "</td>";        // Output 'timestamp' column value
                echo "<td>" . $row['status'] . "</td>";           // Output 'status' column value
                echo "</tr>";
            }
        } else {
            echo "<tr><td colspan='8'>No data found</td></tr>";
        }

        // Close the database connection
        $conn->close();
        ?>
    </tbody>
</table>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.datatables.net/1.11.5/js/jquery.dataTables.js"></script>
<script>
$(document).ready(function() {
    // Initialize DataTable without AJAX (commented out AJAX code above)
    $('#dataTable').DataTable({
        "paging": false,  // Disable pagination
        "searching": false,  // Disable search bar
        "info": false,  // Disable table information
        "ordering": false,  // Disable column ordering
    });
});
</script>

</body>
</html>

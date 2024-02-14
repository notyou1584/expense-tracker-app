<?php
// Database connection parameters
$servername = "localhost";  // Change to your server name
$username = "root";          // Change to your database username
$password = "";              // Change to your database password
$dbname = "expense-o";       // Change to your database name

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Query to retrieve data from the SQL table
$sql = "SELECT firebase_id, mobile, status FROM users";  // Replace 'users' with your actual table name
$result = $conn->query($sql);

// Check if query was successful
if ($result->num_rows > 0) {
    // Loop through each row of the result and output table rows
    while($row = $result->fetch_assoc()) {
        echo "<tr>";
        echo "<td>" . $row['firebase_id'] . "</td>";  // Output 'firebase_id' column value		
        echo "<td>" . $row['mobile'] . "</td>";       // Output 'mobile' column value
        echo "<td>" . $row['status'] . "</td>";       // Output 'status' column value
        echo "</tr>";
    }
} else {
    echo "<tr><td colspan='3'>No data found</td></tr>";
}

// Close the database connection
$conn->close();
?>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Data Tables</title>
  <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.11.5/css/jquery.dataTables.css">
</head>
<body>

<table id="dataTable" class="display">
    <thead>
        <tr>
            <th>firebase_id</th>
            <th>mobile</th>
            <th>status</th>
        </tr>
    </thead>
    <tbody>
    </tbody>
</table>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.datatables.net/1.11.5/js/jquery.dataTables.js"></script>
<script>
$(document).ready(function() {
    // Fetch data from data.php using AJAX
    /*
    $.ajax({
        url: 'data.php',
        type: 'GET',
        dataType: 'json',
        success: function(data) {
            // Populate data table with fetched data
            $.each(data, function(index, row) {
                $('#dataTable tbody').append(
                    '<tr>' +
                        '<td>' + row.firebase_id + '</td>' +
                        '<td>' + row.mobile + '</td>' +
                        '<td>' + row.status + '</td>' +
                    '</tr>'
                );
            });
            
            // Initialize DataTable
            $('#dataTable').DataTable();
        },
        error: function(xhr, status, error) {
            console.error(xhr.responseText);
        }
    });
    */
    
    $('#dataTable').DataTable();
});
</script>

</body>
</html>

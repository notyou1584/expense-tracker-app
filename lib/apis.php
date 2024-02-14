<?php
session_start();
include('library/crud.php');

$db = new Database();
$db->connect();
$db->sql("SET NAMES 'utf8'");

$response = array();
$access_key = "5505";

if (isset($_POST['access_key']) && isset($_POST['user_signup'])) {
    if ($access_key != $_POST['access_key']) {
        $response['error'] = true;
        $response['message'] = "Invalid Access Key";
    } else {
            $firebase_id = $db->escapeString($_POST['firebase_id']);
            $mobile = $db->escapeString($_POST['mobile']);
            $status = $db->escapeString($_POST['status']);

            if (empty($firebase_id) || empty($mobile) || empty($status)) {
                $response['error'] = true;
                $response['message'] = "Please provide all required fields";
            } else {
                $sql = "SELECT * FROM users WHERE firebase_id='$firebase_id'";
                $db->sql($sql);
                $res = $db->getResult();

                if (!empty($res)) {
                    $response['error'] = false;
                    $response['message'] = "User already exists";
                    // Only keep firebase_id, mobile, and status fields in the response
                    $response['data'] = array(
                        'firebase_id' => $res[0]['firebase_id'],
                        'mobile' => $res[0]['mobile'],
                        'status' => $res[0]['status']
                    );
                } else {
                    $data = array(
                        'firebase_id' => $firebase_id,
                        'mobile' => $mobile,
                        'status' => $status
                    );
                    $sql = $db->insert('users', $data);
                    $res = $db->getResult();

                    if ($sql) {
                        $response['error'] = false;
                        $response['message'] = "User registered successfully";
                        // Only keep firebase_id, mobile, and status fields in the response
                        $response['data'] = array(
                            'firebase_id' => $firebase_id,
                            'mobile' => $mobile,
                            'status' => $status
                        );
						echo json_encode($response);
                    } else {
                        $response['error'] = true;
                        $response['message'] = "Failed to register user";
                    }
                }
            }
        }
    }
 else {
    $response['error'] = true;
    $response['message'] = "Access key and user signup data are required";
}

if (isset($_POST['access_key']) && isset($_POST['add_expense'])) {
	 if ($access_key != $_POST['access_key']) {
        $response['error'] = true;
        $response['message'] = "Invalid Access Key";
    } else {
            $user_id = $db->escapeString($_POST['user_id']);
            $amount = $db->escapeString($_POST['amount']);
            $currency = $db->escapeString($_POST['currency']);
			$category = $db->escapeString($_POST['category']);
			$description = $db->escapeString($_POST['description']);
			$status = $db->escapeString($_POST['status']);

            //if (empty($user_id) || empty($amount) || empty($category)) {
            //    $response['error'] = true;
            //    $response['message'] = "Please provide all required fields";
			//	echo json_encode($response);
            //} else {
				 $data = array(
                        'user_id' => $user_id,
                        'amount' => $amount,
						'currency' => $currency,
						'category' => $category,
						'description'=> $description,
						'status' => $status
                    );
                    $sql = $db->insert('expenses', $data);
                    $res = $db->getResult();

                    if ($sql) {
                        $response['error'] = false;
                        $response['message'] = "expense added successfully";
                        $response['data'] = array(
                            'user_id' => $user_id,
                        'amount' => $amount,
						'currency' => $currency,
						'category' => $category,
						'description'=> $description,
						'status' => $status
                        );
						echo json_encode($response);
                    } else {
                        $response['error'] = true;
                        $response['message'] = "Failed to register user";
						echo json_encode($response);
					}
			// }
		}
} else {
    $response['error'] = true;
    $response['message'] = "Access key and user signup data are required";
	echo json_encode($response);

}
				
    
?>


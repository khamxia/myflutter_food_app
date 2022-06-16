<?php
	include 'connected.php';
	header("Access-Control-Allow-Origin: *");

if (!$link) {
    echo "Error: Unable to connect to MySQL." . PHP_EOL;
    echo "Debugging errno: " . mysqli_connect_errno() . PHP_EOL;
    echo "Debugging error: " . mysqli_connect_error() . PHP_EOL;
    
    exit;
}

if (!$link->set_charset("utf8")) {
    printf("Error loading character set utf8: %s\n", $link->error);
    exit();
	}


if (isset($_GET)) {
	if ($_GET['isAdd'] == 'true') {
		
		$id = $_GET['id'];	
		$nameshop = $_GET['nameshop'];		
		$addressshop = $_GET['addressshop'];
		$phoneshop = $_GET['phoneshop'];
		$urlpicture = $_GET['urlpicture'];
		$lat = $_GET['lat'];
		$lng = $_GET['lng'];
				
		
							
		$sql = "UPDATE `shoptb` SET `nameshop` = '$nameshop', `addressshop` = '$addressshop',`phoneshop` = '$phoneshop',`urlpicture` = '$urlpicture',`lat` = '$lat',`lng` = '$lng' WHERE id = '$id'";

		$result = mysqli_query($link, $sql);

		if ($result) {
			echo "true";
		} else {
			echo "false";
		}

	} else echo "success";
   
}

	mysqli_close($link);
?>
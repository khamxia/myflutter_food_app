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
				
		$name = $_GET['name'];
		$email = $_GET['email'];
		$user = $_GET['user'];
		$password = $_GET['password'];
		$typeuser = $_GET['typeuser'];
		
							
		$sql = "INSERT INTO `shoptb`(`id`,`name`,`email`, `user`, `password`, `typeuser`,`nameshop`, `addressshop`, `phoneshop`, `urlpicture`, `lat`, `lng`, `token`) VALUES (Null,'$name','$email','$user','$password','$typeuser','','','','','','','')";

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
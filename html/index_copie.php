<!DOCTYPE html>
<html>
	<head>
		<meta charset="US-ASCII">
		<link rel="stylesheet" type="text/css" href="../CSS/entete.css" media="all"/>
		<link rel="stylesheet" type="text/css" href="../CSS/menu.css" media="all"/>
		<link rel="stylesheet" type="text/css" href="../CSS/contenu.css" media="all"/>
		<link rel="stylesheet" type="text/css" href="../CSS/footer.css" media="all"/>
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
		  		<h1>
		  			<?php
		  				require_once '../php/controleurs/CIndex.php';
		  			
		  				$cIndex = new CIndex();
		  				
		  				$cIndex->test();
						
		  		 	?>
		  		</h1>	
				<form method="post" action="NewContact">
				<div class="divArrondiContenu">
				<div class=".divTitre">
				<span class="titreDiv">Etat civile :</span>
				</div>
				<br/>
					<table>
					<tr><td class="labelText"><label class="labelText">Prénom :</label></td><td><input type="text" name="firstName" class="inputText"/></td></tr>
						<tr><td class="labelText"><label class="labelText">Nom :</label></td><td><input type="text" name="lastName" class="inputText"/></td></tr>
						<tr><td class="labelText"><label class="labelText">E-mail :</label></td><td><input type="text" name="email" class="inputText"/></td></tr>
					</table>
				</div>
				<div class="divArrondiContenu">
				<div class=".divTitre">
				<span class="titreDiv">Contact :</span>
				</div>
				<br/>
				<table>
					<tr><td class="labelText"><label class="labelText">Rue :</label></td><td><input type="text" name="street" class="inputText"/></td></tr>
					<tr><td class="labelText"><label class="labelText">Ville :</label></td><td><input type="text" name="city" class="inputText"/></td></tr>
					<tr><td class="labelText"><label class="labelText">Code postal :</label></td><td><input type="text" name="zip" class="inputText"/></td></tr>
					<tr><td class="labelText"><label class="labelText">Pays :</label></td><td><input type="text" name="country" class="inputText"/></td></tr>
				</table>
				</div>
				<div class="divArrondiContenu">
					<div class=".divTitre">
				<span class="titreDiv">Adresse :</span>
				</div>
				<br/>
				<table>
					<tr><td class="labelText"><label>Mobile :</label></td><td><input type="text" name="mobile" class="inputText"/></td></tr>
					<tr><td class="labelText"><label class="labelText">Maison :</label></td><td><input type="text" name="maison" class="inputText"/></td></tr>
					<tr><td class="labelText"><label class="labelText">Bureau :</label></td><td><input type="text" name="bureau" class="inputText"/></td></tr>
				</table>
				</div>
				<div class="divArrondiContenu">
				<div class=".divTitre">
				<span class="titreDiv">Groupes :</span>
				</div>
				<br/>
				<table>
					<tr><td style ="padding-left: 30px"><input type="checkbox" name="choix" value="Ami" /></td><td>Ami</td></tr>
					<tr><td style ="padding-left: 30px"><input type="checkbox" name="choix" value="Collègue" /></td><td>Collègue</td></tr>
					<tr><td style ="padding-left: 30px"><input type="checkbox" name="choix"  value="Famille" /></td><td>Famille</td></tr>
				</table>
				</div>
				<div class="divArrondiContenu">
				<div class=".divTitre">
				<span class="titreDiv">Groupes :</span>
				</div>
				<br/>
				<table>
					<tr><td>
						<select multiple style="width:470px">
			  				<option value="volvo">Volvo</option>
			  				<option value="saab" style="background : #FF3366">Saab</option>
			  				<option value="opel">Opel</option>
			  				<option value="audi" style="background : #FF3366">Audi</option>
						</select>
					</td></tr>
				</table>
				</div>
				<div class="divArrondiContenu">
				<table align="center">
					<tr><td colspan=2><input type="submit" value="Submit" /><span style="margin-left:20px"></span><input type="reset" value="Reset" /></td></tr>
				</table>
				</div>		
				</form>
			</div>
		</div>
		<!-- Bas de page -->
		<div id="footer">
		 Pied de Page
		</div>
	</body>
</html>
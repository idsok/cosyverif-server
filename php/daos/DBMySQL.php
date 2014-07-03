<?php

class DBMySQL
{   
	
	public static function connect(){
		try
		{
			// On se connecte à MySQL
			return new PDO('mysql:host=127.0.0.1;dbname=db_rokysaroi_site', 'root', 'root');
		}catch(Exception $e){
		    // En cas d'erreur, on affiche un message et on arrête tout
		    die('Erreur : '.$e->getMessage());

		    return NULL;
		}
	}
}

?>
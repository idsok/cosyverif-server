<?php

class Array
{   
	
	ppublic static $tableau_pizzas = array();
    
    /**
     *    Ajoute un objet pizza au tableau de pizzas 
     */
    public static function add($object, $array, $index)
    {
        // On ajoute la pizza que si elle n'existe pas déjà (par exemple)
        // A contrario on pourrait choisir de remplacer toute entrée existante
        if(!isset($array[$index])
        { 
            $array[$index] = $object;
        }
    }
    
    /**
     *    Crée un nouvel objet pizza et l'ajoute au tableau
     *    Typiquement, cette fonction permettrait de charger les objets pizzas,
     *    suite à la récupération des infos en base de données.
     */
    public static function chargerPizza($pId, $pNom,$pPrixPetite,$pPrixGrande,$pBase,$pIngredients)
    {
        $pizza = new Pizza($pId, $pNom,$pPrixPetite,$pPrixGrande,$pBase,$pIngredients);
        self::ajouterPizza($pizza);
    }    
    
    /**
     *    Affiche une liste des pizzas actuellement chargées dans le tableau
     */
    public static function listerNomsDesPizzas()
    {
        foreach(self::$tableau_pizzas as $id => $objetPizza)
        {
            echo $objetPizza->id . " : " . $objetPizza->nom . PHP_EOL; 
        }
    }


    public function getCompetancesParType($id){
        
        $bdd = DBMySQL::connect();

        if(is_null($bdd))
            return 0 | Util::errorSupport();

        $reponse1 = $bdd->query('SELECT DISTINCT TypeCompetance.id, TypeCompetance.libelle FROM Competance, TypeCompetance WHERE Competance.idType = TypeCompetance.id AND idCV ='.$id.' ORDER BY TypeCompetance.ordre');
        
        $listeType = array();
        $i = 0;

        foreach ($reponse1->fetchAll() as $row) {
            $listeType[$i] = Factory::newTypeCompetance();
            $listeType[$i]->setId($row['id']);
            $listeType[$i]->setLibelle($row['libelle']);
            
            $reponse2 = $bdd->query('SELECT * FROM Competance WHERE Competance.idType = '.$listeType[$i]->getId().' AND idCV ='.$id);


            $liste = array();
            $j = 0;

            foreach ($reponse1->fetchAll() as $row) {
                $liste[$j] = Factory::newCompetance();
                $liste[$j]->setId($row['id']);
                $liste[$j]->setLibelle($row['libelle']);
                $liste[$j]->setNiveau($row['niveau']);
                $liste[$j]->setStatus($row['status']);
                $j++;
            }

            $listeType[$i]->setCompetances($liste);

            $i++;
            
        }

        return $listeType;
        
    }
}

?>
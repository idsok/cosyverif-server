<?php
require_once dirname(__FILE__).'/DBMySQL.php';
require_once dirname(__FILE__).'/../interfaces/Factory.php';
require_once dirname(__FILE__).'/../utils/Util.php';

class DaoCV 
{   


	public function getCV($id){
		
        $bdd = DBMySQL::connect();

        if(is_null($bdd))
            return 0 | Util::errorSupport();
        
        $reponse = $bdd->query('SELECT * FROM CV WHERE idUser ='.$id);

        $data = $reponse->fetch();

        if($data == FALSE)
        	return 0 | Util::errorCV();

        $obj = Factory::newCV();
        $obj->setId($data['id']);
        $obj->setTitle($data['title']);
        $obj->setStatus($data['status']);
        $obj->setPhoto($data['photo']);

        $obj->setExperiences($this->getExperiences($obj->getId()));
        $obj->setFormations($this->getFormations($obj->getId()));
        $obj->setCompetances($this->getCompetances($obj->getId()));
        $obj->setCentreInterets($this->getCentreInterets($obj->getId()));

        return $obj;
        
    }

    public function getFormations($id){
        
        $bdd = DBMySQL::connect();

        if(is_null($bdd))
            return 0 | Util::errorSupport();
        
        $reponse = $bdd->query('SELECT * FROM Formation WHERE idCV ='.$id.' ORDER BY ordre');


        $liste = array();
        $i = 0;

        foreach ($reponse->fetchAll() as $row) {
            $liste[$i] = Factory::newExperience();
            
            $liste[$i]->setId($row['id']);
            $liste[$i]->setLibelle($row['libelle']);
            $liste[$i]->setDescription($row['description']);
            $liste[$i]->setEtablissement($row['etablissement']);
            $liste[$i]->setLieu($row['lieu']);
            $liste[$i]->setDateBegin($row['dateBegin']);
            $liste[$i]->setDateEnd($row['dateEnd']);
            $liste[$i]->setOrdre($row['ordre']);

            $i++;
        }

        return $liste;
        
    }

    public function getExperiences($id){
        
        $bdd = DBMySQL::connect();

        if(is_null($bdd))
            return 0 | Util::errorSupport();
        
        $reponse = $bdd->query('SELECT * FROM Experience, TypeExperience WHERE Experience.idType = TypeExperience.id AND idCV ='.$id.' ORDER BY ordre');


        $liste = array();
        $i = 0;

        foreach ($reponse->fetchAll() as $row) {
            $liste[$i] = Factory::newExperience();
            
            $liste[$i]->setId($row[0]);
            $liste[$i]->setLibelle($row[1]);
            $liste[$i]->setDescription($row[2]);
            $liste[$i]->setEtablissement($row[3]);
            $liste[$i]->setLieu($row[4]);
            $liste[$i]->setDateBegin($row[5]);
            $liste[$i]->setDateEnd($row[6]);
            $liste[$i]->setOrdre($row[7]);

            $liste[$i]->setType(Factory::newTypeExperience());
            $liste[$i]->getType()->setId($row[10]);
            $liste[$i]->getType()->setLibelle($row[11]);
            $liste[$i]->setTasks($this->getTasks($liste[$i]->getId()));

            $i++;
        }

        return $liste;
        
    }

    public function getTasks($id){
        
        $bdd = DBMySQL::connect();

        if(is_null($bdd))
            return 0 | Util::errorSupport();
        
        $reponse = $bdd->query('SELECT * FROM Task WHERE idExperience ='.$id);


        $liste = array();
        $i = 0;

        foreach ($reponse->fetchAll() as $row) {
            $liste[$i] = Factory::newTask();
            
            $liste[$i]->setId($row['id']);
            $liste[$i]->setLibelle($row['libelle']);
            $liste[$i]->setDescription($row['description']);

            $i++;
        }

        return $liste;
        
    }

    public function getCompetances($id){
        
        $bdd = DBMySQL::connect();

        if(is_null($bdd))
            return 0 | Util::errorSupport();
        
        $reponse = $bdd->query('SELECT * FROM Competance WHERE idCV ='.$id);


        $liste = array();
        $i = 0;

        foreach ($reponse->fetchAll() as $row) {
            $liste[$i] = Factory::newCompetance();
            
            $liste[$i]->setId($row['id']);
            $liste[$i]->setLibelle($row['libelle']);
            $liste[$i]->setNiveau($row['niveau']);
            $liste[$i]->setStatus($row['status']);

            $liste[$i]->setType(Factory::newTypeCompetance());
            $liste[$i]->getType()->setId($row['idType']);

            $liste[$i]->setDomaine(Factory::newDomaineCompetance());
            $liste[$i]->getDomaine()->setId($row['idDomaine']);

            $i++;
        }

        return $liste;
        
    }

    public function getTypeCompetances($id){
        
        $bdd = DBMySQL::connect();

        if(is_null($bdd))
            return 0 | Util::errorSupport();

        $reponse = $bdd->query('SELECT DISTINCT TypeCompetance.id, TypeCompetance.libelle FROM Competance, TypeCompetance WHERE Competance.idType = TypeCompetance.id AND idCV ='.$id.' ORDER BY TypeCompetance.ordre');
        
        $liste = array();
        $i = 0;

        foreach ($reponse->fetchAll() as $row) {
            $liste[$i] = Factory::newTypeCompetance();
            $liste[$i]->setId($row['id']);
            $liste[$i]->setLibelle($row['libelle']);
            
            $i++;
            
        }

        return $liste;  
    }

    public function getCentreInterets($id){
        
        $bdd = DBMySQL::connect();

        if(is_null($bdd))
            return 0 | Util::errorSupport();
        
        $reponse = $bdd->query('SELECT * FROM CentreInteret WHERE idCV ='.$id);


        $liste = array();
        $i = 0;

        foreach ($reponse->fetchAll() as $row) {
            $liste[$i] = Factory::newCentreInteret();
            
            $liste[$i]->setId($row['id']);
            $liste[$i]->setLibelle($row['libelle']);

            $liste[$i]->setType(Factory::newTypeCentreInteret());
            $liste[$i]->getType()->setId($row['idType']);

            $i++;
        }

        return $liste;
        
    }

    public function getTypeCentreInterets($id){
        
        $bdd = DBMySQL::connect();

        if(is_null($bdd))
            return 0 | Util::errorSupport();

        $reponse = $bdd->query('SELECT DISTINCT TypeCentreInteret.id, TypeCentreInteret.libelle FROM CentreInteret, TypeCentreInteret WHERE CentreInteret.idType = TypeCentreInteret.id AND idCV ='.$id);
        
        $liste = array();
        $i = 0;

        foreach ($reponse->fetchAll() as $row) {
            $liste[$i] = Factory::newTypeCentreInteret();
            $liste[$i]->setId($row['id']);
            $liste[$i]->setLibelle($row['libelle']);
            
            $i++;
            
        }

        return $liste;  
    }


}

?>
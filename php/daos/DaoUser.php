<?php
require_once dirname(__FILE__).'/DBMySQL.php';
require_once dirname(__FILE__).'/../interfaces/Factory.php';
require_once dirname(__FILE__).'/../utils/Util.php';

class DaoUser 
{   


	public function getUser($id){
		
        $bdd = DBMySQL::connect();

        if(is_null($bdd))
            return 0 | Util::errorSupport();
        
        $reponse = $bdd->query('SELECT * FROM User WHERE id ='.$id);

        $data = $reponse->fetch();

        if($data == FALSE)
        	return 0 | Util::errorUser();

        $obj = Factory::newUser();
        $obj->setId($data['id']);
        $obj->setFirstName($data['firstName']);
        $obj->setLastName($data['lastName']);
        $obj->setSurName($data['surName']);
        $obj->setEmail($data['email']);

        $obj->setAddress($this->getAddress($obj->getId()));
        $obj->setPhones($this->getPhones($obj->getId()));

        return $obj;
        
    }

    public function getAddress($id){
        
        $bdd = DBMySQL::connect();

        if(is_null($bdd))
            return 0 | Util::errorSupport();
        
        $reponse = $bdd->query('SELECT * FROM Address WHERE status = 1 AND idUser ='.$id);

        $data = $reponse->fetch();

        if($data == FALSE)
            return 0 | errorAddress();

        $obj = Factory::newAddress();
        $obj->setId($data['id']);
        $obj->setStreet($data['street']);
        $obj->setCity($data['city']);
        $obj->setZip($data['zip']);
        $obj->setCountry($data['country']);

        return $obj;
        
    }

    public function getPhones($idUser){
        
        $bdd = DBMySQL::connect();

        if(is_null($bdd))
            return 0 | Util::errorSupport();
        
        $reponse = $bdd->query('SELECT * FROM Phone WHERE idUser ='.$idUser.' ORDER BY id');

        $liste = array();
        $i = 0;

        foreach ($reponse->fetchAll() as $row) {
            $liste[$i] = Factory::newPhone();
            $liste[$i]->setId($row['id']);
            $liste[$i]->setNumber($row['number']);
            $liste[$i]->setType(Factory::newTypePhone());
            $liste[$i]->getType()->setId($row['idType']);

            $i++;
        }

        return $liste;
        
    }
    
}

?>
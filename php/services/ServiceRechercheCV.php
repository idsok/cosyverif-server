<?php
require_once dirname(__FILE__).'/../daos/DaoCV.php';
require_once dirname(__FILE__).'/../interfaces/Factory.php';
require_once dirname(__FILE__).'/../utils/Util.php';

class ServiceRechercheCV
{   

    public static function getCV($id){

        $dao = new DaoCV();
        return $dao->getCV($id);

    }

    public static function getTypeCompetances($id){

        $dao = new DaoCV();
        return $dao->getTypeCompetances($id);

    }


    public static function getCompetancesType($array, $id){
        $liste = array();

        foreach($array as $competance){
            if($competance->getType()->getId() == $id){
                $liste[] = $competance;
            }
        }

        return $liste;

    }

    public static function getCompetancesDomaine($array, $id){
        $liste = array();

        foreach($array as $competance){
            if($competance->getDomaine()->getId() == $id){
                $liste[] = $competance;
            }
        }

        return $liste;

    }

    public static function getCompetancesInformatique($array){ 
        return self::getCompetancesDomaine($array, 1); 
    }

    public static function getTypeCentreInterets($id){

        $dao = new DaoCV();
        return $dao->getTypeCentreInterets($id);

    }


    public static function getCentreInteretsType($array, $id){
        $liste = array();

        foreach($array as $centreInteret){
            if($centreInteret->getType()->getId() == $id){
                $liste[] = $centreInteret;
            }
        }

        return $liste;

    }


}

?>
<?php
require_once dirname(__FILE__).'/../daos/DaoUser.php';
require_once dirname(__FILE__).'/../interfaces/Factory.php';
require_once dirname(__FILE__).'/../services/ServiceRechercheCV.php';
require_once dirname(__FILE__).'/../utils/Util.php';

class ServiceRechercheUser
{   

    public static function getUser($id){
                    
        $dao = new DaoUser();
        return $dao->getUser($id);

    }

    public static function getUserCV($id){
                    
        $dao = new DaoUser();
        $data = $dao->getUser($id);

        $data->setCv(ServiceRechercheCV::getCV($data->getId()));

        return $data;

    }


}

?>
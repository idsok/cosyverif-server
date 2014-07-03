<?php
require_once dirname(__FILE__).'/../metiers/User.php';
require_once dirname(__FILE__).'/../metiers/Address.php';
require_once dirname(__FILE__).'/../metiers/Phone.php';
require_once dirname(__FILE__).'/../metiers/CV.php';

class Factory 
{   

	public static function newUser(){
    	return new User();
    }

    public static function newAddress(){
    	return new Address();
    }

    public static function newCV(){
    	return new CV();
    }

    public static function newFormation(){
        return new Formation();
    }

    public static function newExperience(){
    	return new Experience();
    }

    public static function newTypeExperience(){
    	return new TypeExperience();
    }

    public static function newTask(){
        return new Task();
    }

    public static function newCompetance(){
        return new Competance();
    }

    public static function newTypeCompetance(){
        return new TypeCompetance();
    }

    public static function newDomaineCompetance(){
        return new DomaineCompetance();
    }

    public static function newCentreInteret(){
        return new CentreInteret();
    }

    public static function newTypeCentreInteret(){
        return new TypeCentreInteret();
    }

    public static function newPhone(){
        return new Phone();
    }

    public static function newTypePhone(){
        return new TypePhone();
    }    

}

?>
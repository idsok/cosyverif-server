<?php

class Phone
{   
	private $id;
	private $number;
	private $type;


	public function getId(){
    	return $this->id;
    }

    public function setId($value){
    	$this->id = $value;
    }

    public function getNumber(){
    	return $this->number;
    }

    public function setNumber($value){
    	$this->number = $value;
    }

    public function getType(){
    	return $this->type;
    }

    public function setType($value){
    	$this->type = $value;
    }

}

class TypePhone
{   
    private $id;
    private $Libelle;


    public function getId(){
        return $this->id;
    }

    public function setId($value){
        $this->id = $value;
    }

    public function getLibelle(){
        return $this->libelle;
    }

    public function setLibelle($value){
        $this->libelle = $value;
    }

}

?>
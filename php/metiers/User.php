<?php

class User
{   
	private $id;
	private $firstName;
	private $lastName;
	private $surName;
    private $email;
	private $address;
    private $phones;
    private $cv;

	public function getId(){
    	return $this->id;
    }

    public function setId($value){
    	$this->id = $value;
    }

    public function getFirstName(){
    	return $this->firstName;
    }

    public function setFirstName($value){
    	$this->firstName = $value;
    }

    public function getLastName(){
    	return $this->lastName;
    }

    public function setLastName($value){
    	$this->lastName = $value;
    }

    public function getSurName(){
    	return $this->surName;
    }

    public function setSurName($value){
    	$this->surName = $value;
    }

    public function getAddress(){
    	return $this->address;
    }

    public function setAddress($value){
    	$this->address = $value;
    }

    public function getCv(){
        return $this->cv;
    }

    public function setCv($value){
        $this->cv = $value;
    }

    public function getEmail(){
        return $this->email;
    }

    public function setEmail($value){
        $this->email = $value;
    }

    public function getPhones(){
        return $this->phones;
    }

    public function setPhones($value){
        $this->phones = $value;
    }
}

?>
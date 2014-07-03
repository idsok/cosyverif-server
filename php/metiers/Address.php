<?php

class Address
{   
	private $id;
	private $street;
	private $city;
	private $zip;
    private $country;
    private $status;


	public function getId(){
    	return $this->id;
    }

    public function setId($value){
    	$this->id = $value;
    }

    public function getStreet(){
    	return $this->street;
    }

    public function setStreet($value){
    	$this->street = $value;
    }

    public function getCity(){
    	return $this->city;
    }

    public function setCity($value){
    	$this->city = $value;
    }

    public function getZip(){
    	return $this->zip;
    }

    public function setZip($value){
    	$this->zip = $value;
    }

    public function getCountry(){
        return $this->country;
    }

    public function setCountry($value){
        $this->country = $value;
    }

    public function getStatus(){
        return $this->surName;
    }

    public function setStatus($value){
        $this->status = $value;
    }
}

?>
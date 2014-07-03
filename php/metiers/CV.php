<?php

class CV 
{   
	private $id;
	private $title;
	private $status;
	private $photo;
    private $experiences;
    private $formations;
    private $competances;
    private $centreInterets;

	public function getId(){
    	return $this->id;
    }

    public function setId($value){
    	$this->id = $value;
    }

    public function getTitle(){
    	return $this->title;
    }

    public function setTitle($value){
    	$this->title = $value;
    }

    public function getStatus(){
    	return $this->status;
    }

    public function setStatus($value){
    	$this->status = $value;
    }

    public function getPhoto(){
    	return $this->photo;
    }

    public function setPhoto($value){
    	$this->photo = $value;
    }

    public function getFormations(){
        return $this->formations;
    }

    public function setFormations($value){
        $this->formations = $value;
    }

    public function getExperiences(){
        return $this->experiences;
    }

    public function setExperiences($value){
        $this->experiences = $value;
    }

    public function getCompetances(){
        return $this->competances;
    }

    public function setCompetances($value){
        $this->competances = $value;
    }

    public function getCentreInterets(){
        return $this->centreInterets;
    }

    public function setCentreInterets($value){
        $this->centreInterets = $value;
    }

    
}

class Formation
{   
    private $id;
    private $libelle;
    private $etablissement;
    private $lieu;
    private $description;
    private $dateBegin;
    private $dateEnd;
    private $ordre;

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

    public function getEtablissement(){
        return $this->etablissement;
    }

    public function setEtablissement($value){
        $this->etablissement = $value;
    }

    public function getLieu(){
        return $this->lieu;
    }

    public function setLieu($value){
        $this->lieu = $value;
    }

    public function getDescription(){
        return $this->description;
    }

    public function setDescription($value){
        $this->description = $value;
    }

    public function getDateBegin(){
        return $this->dateBegin;
    }

    public function setDateBegin($value){
        $this->dateBegin = $value;
    }

    public function getDateEnd(){
        return $this->dateEnd;
    }

    public function setDateEnd($value){
        $this->dateEnd = $value;
    }

    public function getOrdre(){
        return $this->ordre;
    }

    public function setOrdre($value){
        $this->ordre = $value;
    }
    
}

class Experience 
{   
    private $id;
    private $libelle;
    private $etablissement;
    private $lieu;
    private $description;
    private $dateBegin;
    private $dateEnd;
    private $ordre;
    private $type;
    private $tasks;

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

    public function getEtablissement(){
        return $this->etablissement;
    }

    public function setEtablissement($value){
        $this->etablissement = $value;
    }

    public function getLieu(){
        return $this->lieu;
    }

    public function setLieu($value){
        $this->lieu = $value;
    }

    public function getDescription(){
        return $this->description;
    }

    public function setDescription($value){
        $this->description = $value;
    }

    public function getDateBegin(){
        return $this->dateBegin;
    }

    public function setDateBegin($value){
        $this->dateBegin = $value;
    }

    public function getDateEnd(){
        return $this->dateEnd;
    }

    public function setDateEnd($value){
        $this->dateEnd = $value;
    }

    public function getOrdre(){
        return $this->ordre;
    }

    public function setOrdre($value){
        $this->ordre = $value;
    }

    public function getType(){
        return $this->type;
    }

    public function setType($value){
        $this->type = $value;
    }

    public function getTasks(){
        return $this->tasks;
    }

    public function setTasks($value){
        $this->tasks = $value;
    }
    
}

class TypeExperience 
{   
    private $id;
    private $libelle;
    private $experiences;


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

    public function getExperiences(){
        return $this->experiences;
    }

    public function setExperiences($value){
        $this->experiences = $value;
    }
    
}

class Task 
{   
    private $id;
    private $libelle;
    private $description;
    private $experience;


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

    public function getDescription(){
        return $this->description;
    }

    public function setDescription($value){
        $this->description = $value;
    }

    public function getExperience(){
        return $this->experience;
    }

    public function setExperience($value){
        $this->experience = $value;
    }
    
}

class Competance
{   
    private $id;
    private $libelle;
    private $niveau;
    private $status;
    private $type;
    private $domaine;

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

    public function getNiveau(){
        return $this->niveau;
    }

    public function setNiveau($value){
        $this->niveau = $value;
    }

    public function getStatus(){
        return $this->status;
    }

    public function setStatus($value){
        $this->status = $value;
    }

    public function getType(){
        return $this->type;
    }

    public function setType($value){
        $this->type = $value;
    }

    public function getDomaine(){
        return $this->domaine;
    }

    public function setDomaine($value){
        $this->domaine = $value;
    }
    
}

class TypeCompetance
{   
    private $id;
    private $libelle;
    private $ordre;

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

    public function getOrdre(){
        return $this->ordre;
    }

    public function setOrdre($value){
        $this->ordre = $value;
    }
    
}

class DomaineCompetance
{   
    private $id;
    private $libelle;

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

class CentreInteret
{   
    private $id;
    private $libelle;
    private $type;

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

    public function getType(){
        return $this->type;
    }

    public function setType($value){
        $this->type = $value;
    }
    
}

class TypeCentreInteret
{   
    private $id;
    private $libelle;

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
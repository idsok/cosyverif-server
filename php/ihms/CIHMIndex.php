<?php
require_once dirname(__FILE__).'/../interfaces/Factory.php';
require_once dirname(__FILE__).'/../services/ServiceRechercheUser.php';

class CIHMIndex
{   
	private $user;

    public function printFormation($formation){

        echo"<div class='divFormation'>
                <span class='divFormationDate'>"; echo $formation->getDateBegin()." - ".$formation->getDateEnd(); echo "</span>
                <div class='divFormationText'>
                    <span class='divFormationTitre'>"; echo $formation->getLibelle(); echo "</span>
                    <span class='divFormationEtablissement'>, "; echo $formation->getEtablissement(); echo "</span>
                    <span class='divFormationLieu'>, "; echo $formation->getLieu(); echo "</span>.
                </div>
             </div>";

    }

    public function printExperience($experience, $isVisible){

        echo"<div class='divExperience'>
                <a href='#'>
                <div class='divExperienceEntete'>
                    <span class='divExperienceType'>"; echo $experience->getType()->getLibelle(); echo "</span>
                    <span class='divExperienceDate'>"; echo $experience->getDateBegin()." - ".$experience->getDateEnd(); echo "</span>
                    <span class='divExperienceTitre'>"; echo $experience->getLibelle().', '.$experience->getEtablissement(); echo (($isVisible == 1)? '' : " <span class='cache'>(...)</span>"); echo "</span>
                </div> 
                </a>
                <div class='divExperienceContenu"; echo (($isVisible == 1)? 'Visible' : 'NotVisible'); echo"'>";
                    
                    foreach($experience->getTasks() as $task){
                       echo"<span class='divTache'>- "; echo $task->getLibelle(); echo "</span>";
                    }
                    
                echo"</div>
             </div>";

    }

    public function printCompetanceInformatique($type){

        echo"<div class='divCompetance'>
                <div class='divCompetanceType'>"; echo $type->getLibelle(); echo "</div>
                <div class='divCompetanceCorps'>"; 

                    $ok = 0;

                    foreach(ServiceRechercheCV::getCompetancesType(ServiceRechercheCV::getCompetancesInformatique($this->user->getCV()->getCompetances()), $type->getId()) as $competance){
                        if($ok == 0)
                            $ok = 1; 
                        else
                            echo ', ';
                            

                        echo $competance->getLibelle();
                    }
                    echo", ...";
                echo "</div>
             </div>";

    }

    public function printCentreInteret($type){

        echo"<div class='divCompetance'>
                <div class='divCompetanceType'>"; echo $type->getLibelle(); echo "</div>
                <div class='divCompetanceCorps'>"; 

                    $ok = 0;

                    foreach(ServiceRechercheCV::getCentreInteretsType($this->user->getCV()->getCentreInterets(), $type->getId()) as $centreInteret){
                        if($ok == 0)
                            $ok = 1; 
                        else
                            echo ', ';
                            

                        echo $centreInteret->getLibelle();
                    }
                    echo", ...";
                echo "</div>
             </div>";

    }

    public function printCV(){
        $this->user = ServiceRechercheUser::getUserCV(1);
        
        echo"<link rel='stylesheet' type='text/css' href='../CSS/cv.css' media='all'/>";
        echo"<div id='divCV'>
                <div id='divEntete'>
                    <div id='divContactPhoto'>
                        <div id='divPhoto'>
                        </div>
                        <div id='divContact'>
                            <span id='rue'>"; echo $this->user->getAddress()->getStreet(); echo "</span>
                            <span id='ville'>"; echo $this->user->getAddress()->getZip().' '.$this->user->getAddress()->getCity(); echo "</span>
                            <span id='email'>"; echo $this->user->getEmail(); echo "</span>
                            <span id='tel'>"; $phones = $this->user->getPhones(); echo $phones[0]->getNumber(); echo "</span>
                        </div>
                    </div>
                    <div id='divName'>
                        <span id='name'>"; echo $this->user->getFirstName().' '.$this->user->getLastName(); echo "</span>
                        <span id='title'>"; echo $this->user->getCV()->getTitle(); echo "</span>
                    </div>
                    <div id='divStatus'>
                        <span id='status'>"; echo $this->user->getCV()->getStatus(); echo "</span>
                    </div>
                </div>
                <div id='divCorps'>

                    <div class='divParty'>
                            <div class='divPartyEntete'>
                                <span class='divPartyEnteteTrait'><hr /></span>
                                <span class='divPartyEnteteTitre'>FORMATION</span>

                            </div>";

                            echo"<div class='divPartyCorps'>";

                                foreach($this->user->getCV()->getFormations() as $formation){
                                    $this->printFormation($formation);
                                }
                            echo"</div>
                    </div>

                    <div class='divParty'>
                            <div class='divPartyEntete'>
                                <span class='divPartyEnteteTrait'><hr /></span>
                                <span class='divPartyEnteteTitre'>EXPERIENCES PROFESSIONNELLES</span>

                            </div>

                            <div class='divPartyCorps'>";
                                $i = 0;

                                foreach($this->user->getCV()->getExperiences() as $experience){
                                    

                                    $this->printExperience($experience, ($i < 5)? 1:0);

                                    $i++;
                                }
                            echo"</div>
                    </div>

                    <div class='divParty'>
                            <div class='divPartyEntete'>
                                <span class='divPartyEnteteTrait'><hr /></span>
                                <span class='divPartyEnteteTitre'>COMPETENCES IMFORMATIQUES</span>

                            </div>

                            <div class='divPartyCorps'>";

                                foreach(ServiceRechercheCV::getTypeCompetances($this->user->getCV()->getId()) as $type){
                                    $this->printCompetanceInformatique($type);
                                }
                            echo"</div>
                    </div>

                    <div class='divParty'>
                            <div class='divPartyEntete'>
                                <span class='divPartyEnteteTrait'><hr /></span>
                                <span class='divPartyEnteteTitre'>CENTRES D'INTERET</span>

                            </div>

                            <div class='divPartyCorps'>";

                                foreach(ServiceRechercheCV::getTypeCentreInterets($this->user->getCV()->getId()) as $type){
                                    $this->printCentreInteret($type);
                                }
                            echo"</div>
                    </div>
            </div>
            </div>";

            echo"
            <script type='text/javascript' src='../javascript/cv.js'></script>
            <script type='text/javascript'>
                $('document').ready(function(){
                                        experienceTasksVisibility();
                                        animerStatus();
                                        
                                    });
            </script>";
    }

}

?>
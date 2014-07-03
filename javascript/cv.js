function animerStatus(){
	jQuery('#status').queue(function(){ $(this).css('color','#669933'); $(this).dequeue();})
					 .delay(500)
					 .queue(function(){ $(this).css('color','#FF4E6F'); $(this).dequeue();})
					 .delay(500)
					 .queue(function(){ $(this).css('color','#2E1FFF'); $(this).dequeue();})
					 .delay(500)
					 .queue(function(){ $(this).css('color','#FF40E2'); $(this).dequeue();})
					 .delay(500)
					 .queue(function(){ $(this).css('color','#AB0FFF'); $(this).dequeue();})
					 .delay(500)
					 .queue(function(){ $(this).css('color','#080412'); $(this).dequeue();})
					 .delay(500)
					 .queue(function(){ $(this).css('color','#0000cd'); $(this).dequeue();})
					 .delay(500)
					 .queue(function(){ $(this).css('color','#295f11'); $(this).dequeue();})
					 .delay(500);

	//animerStatus();
}

function experienceTasksVisibility(){
	jQuery('.divExperience a').click(function(){

		var tampoHeight = $(this).next().height();
		var divTampo = $('.divExperienceContenuVisibleTampo');


		divTampo.css('display', 'none')
				.css('visibility','hidden');

		$('.lienVisible .cache').css('display', 'inline')
								.css('visibility','visible');
								
		$('.lienVisible').attr('class','');

					  
        if($(this).next().attr('class') != divTampo.attr('class')){

			$(this).next().css('height','0px')
						  .css('display', 'block')
						  .css('visibility','visible')
						  .animate({height : tampoHeight + 'px'}, 
						  	       {duration : Math.abs( 0 - tampoHeight) / 0.050, 
						  	       	easing: 'linear', 
						  	       	queue: true});


			$(this).attr('class','lienVisible');

			$('.' + $(this).attr('class')+ ' ' + '.cache').css('display', 'none')
												          .css('visibility','hidden');


	    	$(this).next().attr('class','divExperienceContenuVisibleTampo');
	    }

	    divTampo.attr('class','divExperienceContenuNotVisible');

		return false;

	});

}

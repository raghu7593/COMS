$(document).ready(function() {
	$("#start-date").datepicker({
	  	minDate: 0,
	  	maxDate: "+60D",
	   onSelect: function(selected) {
		$("#end-date").datepicker("option","minDate", selected)
	  }
  	});
 	$("#end-date").datepicker({ 
		minDate: 0,
	  	maxDate:"+80D",
	  	onSelect: function(selected) {
		  	$("#start-date").datepicker("option","maxDate", selected)
	  	}
 	});  
});

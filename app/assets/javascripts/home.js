$(document).ready(function() {
	var on_streets;
	var cross_streets;
	var substringMatcher = function(strs) {
	  return function findMatches(q, cb) {
	    var matches, substrRegex;
	 
	    // an array that will be populated with substring matches
	    matches = [];
	 
	    // regex used to determine if a string contains the substring `q`
	    substrRegex = new RegExp(q, 'i');
	 
	    // iterate through the pool of strings and for any string that
	    // contains the substring `q`, add it to the `matches` array
	    $.each(strs, function(i, str) {
	      if (substrRegex.test(str)) {
	        // the typeahead jQuery plugin expects suggestions to a
	        // JavaScript object, refer to typeahead docs for more info
	        matches.push({ value: str });
	      }
	    });
	 
	    cb(matches);
	  };
	};
	// Get the full list of cross streets and streets to load into autocomplete
		$('#on-street.typeahead').typeahead({
			hint: true,
			highlight: true,
			minLength: 1
		}, {
			name: 'on_streets',
			displayKey: 'value',
			source: substringMatcher(gon.on_streets)
		});
		$('#cross-street.typeahead').typeahead({
			hint: true,
			highlight: true,
			minLength: 1
		}, {
			name: 'cross_streets',
			displayKey: 'value',
			source: substringMatcher(gon.cross_streets)
		});

	// TODO: Remove markers on new search

  var mapOptions = {
    center: { lat: 41.880161, lng: -87.630955},
    zoom: 12
  };
  var map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);

	var markers = [];
	// Animations for the two different query types
	$('.search-by-cross-street').click(function(event) {
		event.preventDefault();
		$('.multi-stops').animate({
			left: '100%'
		});
		$('.single-stop').animate({
			left: '0'
		});
		$('.search-by-cross-street').hide();
		$('.search-by-params').show();
	});
	$('.search-by-params').click(function(event) {
		$('.multi-stops').animate({
			left: '0'
		});
		$('.single-stop').animate({
			left: '-100%'
		});
		$('.search-by-cross-street').show();
		$('.search-by-params').hide();
	});
	
  // Event for clicking the query button
  $('#query-button').click(function(event) {
  	var number = $('.results-number').val();
  	var order = $('.results-order').val();
  	var filter = $('.results-filter').val();

  	// Get the stops according to the parameters
  	$.get('/bus_stops/multi_stops?number='+number+'&order='+order+'&filter='+filter, function(data, status, xhr) {
  		// Remove the previous rows in the table
    	$('.added-row').remove();
      displayStops(data);
    });
  });

  //Event for clicking the cross street search btton
  $('#cross-streets-button').click(function(event) {
  	var onStreet = $('#on-street').val();
		var crossStreet = $('#cross-street').val();


		// Get the stops according to the cross streets
		$.get('/bus_stops/streets?on_street='+onStreet+'&cross_street='+crossStreet, function(data) {
			$('.added-row').remove();
			// Remove previous markers
			if(markers.length !== 0) {removeMarkers();}
			//Parse routes out of the data routes (it gives it as objects)
			if(data.error !== undefined) {
				var html = '<tr class="added-row"><td colspan="4">Unable to find a stop at those cross streets.</td></tr>';
	  		$('.data-display').append(html);
			} else {
				var routes = '';
	  		for(var j=0; j<data.routes.length; j++) {
	  			routes += data.routes[j].route_id + ' ';
	  		}
				var html = '<tr class="added-row"><td>'+data.on_street+' and '+data.cross_street+'</td><td>'+routes+'</td><td>'+data.boardings+'</td><td>'+data.alightings+'</td></tr>';
	  		$('.data-display').append(html);

	  		displayMarker({'latitude': data.location.latitude, 'longitude': data.location.longitude, 'stop_id': data.id});
			}
		});
  });

	// Function to display the stops in the table
  function displayStops(stops)  {
  	// Remove previous markers
  	if(markers.length !== 0) {removeMarkers();}
  	for(var i = 0; i <stops.length; i++) {
  		var stop = stops[i];
  		var routes = '';
  		for(var j=0; j<stop.routes.length; j++) {
  			routes += stop.routes[j].route_id + ' ';
  		}
  		var html = '<tr class="added-row"><td>'+stop.on_street+' and '+stop.cross_street+'</td><td>'+routes+'</td><td>'+stop.boardings+'</td><td>'+stop.alightings+'</td></tr>';
  		$('.data-display').append(html);

  		displayMarker({'latitude': stop.location.latitude, 'longitude': stop.location.longitude, 'stop_id': stop.id});
  	}
  }

  // Display the markers on the map
  function displayMarker(coords) {
		var newLatlng = new google.maps.LatLng(coords.latitude, coords.longitude);
		var marker = new google.maps.Marker({
		    position: newLatlng,
		    map: map,
		    title: ''+coords.stop_id
		});
			markers.push(marker);
  }

  function removeMarkers() {
  	var mLength = markers.length;
  	for(var i=0; i<mLength; i++) {
  		marker = markers.pop();
  		marker.setMap(null);
  	}
  }


});

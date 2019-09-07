/* ------------------------------------------------------------------------------
*
*  # Vector maps
*
*  Specific JS code additions for maps_vector.html page
*
*  Version: 1.0
*  Latest update: Aug 1, 2015
*
* ---------------------------------------------------------------------------- */

$(function() {


//console.log(mymarker[2].size);
    // Choropleth map
    var mapObj = new jvm.WorldMap({
    	container: $('.map-choropleth'),
        map: 'world_mill_en',
        backgroundColor: 'transparent',
        series: {
        	markers: [{
        		attribute: 'r',
                scale: [3,10]	
        	}],
            regions: [{
                values: gdpData,
                scale: ['#E5DBD2', '#E6CEC3'],
                normalizeFunction: 'polynomial'
            }]
        },
        markerStyle: {
                initial: {
                    r: 3,
                    'fill': '#F26247',
                    'fill-opacity': 0.8,
                    'stroke': '#fff',
                    'stroke-width' : 1.5,
                    'stroke-opacity': 0.9
                },
                hover: {
                    'stroke': '#fff',
                    'fill-opacity': 1,
                    'stroke-width': 1.5
                }
            },
            focusOn: {
                x: 0.5,
                y: 0.5,
                scale: 1
            },
            markers:[],
           // markers: mymarker,
        onRegionLabelShow: function(e, el, code){
            el.html(el.html()
            		// remove the data count
            		//+'<br>'+
            		//gdpData[code]
            );
        }
                 
    });
    var mapMarkers = [];
    var mapMarkersValues = [];
    mapMarkers.length = 0;
    mapMarkersValues.length = 0;
    //console.log(mymarker.length);
    for (var i = 0, l= mymarker.length; i < l; i++) {
    	//console.log(mymarker[i].name)      
     mapMarkers.push({name: mymarker[i].name, latLng: mymarker[i].latLng, r:mymarker[i].r *10});
    }
    mapObj.addMarkers(mapMarkers, []); 
    
    for (var i = 0, l= mymarker.length; i < l; i++) {
    	//console.log(mapObj.markers[i].element);
    	if(mymarker[i].r >=1 && mymarker[i].r < 3)
    		{
    		mapObj.markers[i].element.style.initial.r = (mymarker[i].r / 0.75) * 1.5;
    		}
    	
    	else if(mymarker[i].r > 30)
    		{
    		mapObj.markers[i].element.style.initial.r = mymarker[i].r/8;
    		}
    	else{
    		mapObj.markers[i].element.style.initial.r = mymarker[i].r;
    	}
        
    }
    mapObj.applyTransform();

});

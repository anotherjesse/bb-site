var showLibraries = function(library_id, libraries, map, sidebar) {

  setTimeout(function() {
    var cm_map;
    var cm_mapMarkers = [];
    var cm_mapHTMLS = [];
    var sidebarDIV = document.getElementById(sidebar);

    function cm_createMarker(point, title, html) {
      var marker = new GMarker(point, {title: title});

      GEvent.addListener(marker, "click", function() {
        marker.openInfoWindowHtml(html);
      });

      return marker;
    }

    function cm_markerClicked(markerNum) {
      cm_mapMarkers[markerNum].openInfoWindowHtml(cm_mapHTMLS[markerNum]);
    }

    function cm_loadMapJSON() {
      var usingRank = false;

      var bounds = new GLatLngBounds();

      for (var i = 0; i < libraries.length; i++) {
        var library = libraries[i];
        if (library["lat"]) {
          var point = new GLatLng(library.lat,library.lng);
          var html = "<div style='font-size:12px'>";
          if (library.id == library_id) {
            html += "<strong>" + library.name + "</strong>";
          }
          else {
            html += "<strong><a href='/libraries/"+library.id+"'>" + library.name + "</a></strong>";
          }
          html += '<br/>'+library.full_address;
          html += "</div>";

          // create the marker
          var marker = cm_createMarker(point, library.name, html);
          cm_map.addOverlay(marker);
          cm_mapMarkers.push(marker);
          cm_mapHTMLS.push(html);
          bounds.extend(point);

          if (library.id == library_id) {
            var p = document.createElement("p");
            p.appendChild(document.createTextNode(library.name));
            sidebarDIV.appendChild(p);
          }
          else {
            var markerA = document.createElement("a");
            markerA.href = "/libraries/" + library.id;
            markerA.appendChild(document.createTextNode(library.name));
            sidebarDIV.appendChild(markerA);
            sidebarDIV.appendChild(document.createElement("br"));
          }
        }
      }
      cm_map.setZoom(cm_map.getBoundsZoomLevel(bounds));
      cm_map.setCenter(bounds.getCenter());
    }
  
    if (GBrowserIsCompatible()) {
      // create the map
      cm_map = new GMap2(document.getElementById(map));
      cm_map.addControl(new GLargeMapControl());
      cm_map.addControl(new GMapTypeControl());
      cm_map.setCenter(new GLatLng( 43.907787,-79.359741), 1);
      cm_loadMapJSON();
    } else {
      alert("Sorry, the Google Maps API is not compatible with this browser");
    }
  }, 0);
}


class DirectionController < UIViewController

  def loadView 
    @waypoints = []
    @waypointStrings = []
    camera = GMSCameraPosition.cameraWithLatitude( 37.778376, longitude: -122.409853, zoom: 13 );
    @mapView = GMSMapView.mapWithFrame( CGRectZero, camera:camera )
    @mapView.delegate = self
    self.view = @mapView
  end

  def mapView( mapView, didTapAtCoordinate: coordinate )
    
    position = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude);
    marker = GMSMarker.markerWithPosition( position )
    marker.map = @mapView;

    @waypoints.push( marker )
    positionString = "#{coordinate.latitude}, #{coordinate.longitude}"
    @waypointStrings.push( positionString )
    
    if @waypoints.count > 1
      sensor = "false"
      parameters = [ sensor, @waypointStrings ]
      keys = ["sensor", "waypoints"];
      query = NSDictionary.dictionaryWithObjects( parameters, forKeys:keys )

      ds = DirectionService.alloc.init 
      
      ds.setDirectionsQuery( query, withSelector:'addDirections:', withDelegate:self );
    end
  end

  def addDirections( json )
    routes = json[:routes][0];
    
    route = routes[:overview_polyline]
    overview_route = route[:points];
    path = GMSPath.pathFromEncodedPath( overview_route )
    polyline = GMSPolyline.polylineWithPath( path )
    polyline.map = @mapView;
  end

end
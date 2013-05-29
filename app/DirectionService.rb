
class DirectionService
  def initialize

    @_sensor
    @_alternatives
    @_directionsURL
    @_waypoints

    @directionsUrl = "http://maps.googleapis.com/maps/api/directions/json?"

    puts @directionsUrl
  end

  def setDirectionsQuery( query, withSelector: selector, withDelegate: delegate )
    waypoints = query.objectForKey("waypoints");
    origin = waypoints.objectAtIndex( 0 );
    waypointCount = waypoints.count;
    destinationPos = waypointCount - 1;
    destination = waypoints.objectAtIndex( destinationPos )
    sensor = query.objectForKey("sensor")
    url = "#{@directionsUrl}&origin=#{origin}&destination=#{destination}&sensor=#{sensor}"
    
    if waypointCount > 2
      url.appendString("&waypoints=optimize:true")
      
      wpCount = waypointCount - 2
      
      for i in 1..wpCount
        url.appendString( "|" )
        url.appendString( waypoints.objectAtIndex[i] )
      end
    end
    
    url = url.stringByAddingPercentEscapesUsingEncoding( NSASCIIStringEncoding )

    @directionsUrl = NSURL.URLWithString( url )
    
    self.retrieveDirections( selector, withDelegate:delegate )
  end

  def retrieveDirections( selector, withDelegate: delegate )
    @url = @directionsUrl

    BW::HTTP.get( @directionsUrl ) do |response|
     p response
      data = NSData.dataWithContentsOfURL( @url  )
      puts data 

      #self.fetchedData( data, withSelector:selector, withDelegate:delegate )
    end
  end


  def fetchedData( data, withSelector: selector, withDelegate: delegate )
  
    error_ptr = Pointer.new(:object)
    json = NSJSONSerialization.JSONObjectWithData( data, options: kNilOptions, error: error_ptr )
    delegate.performSelector( selector, withObject: json )
  end
end
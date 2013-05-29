class DirectionService
  def initialize

    @directionsUrl = "http://maps.googleapis.com/maps/api/directions/json?"
  end

  def setDirectionsQuery( query, withSelector: selector, withDelegate: delegate )
    
    waypoints = query[:waypoints];
    origin = waypoints[ 0 ]
    waypointCount = waypoints.count;
    destinationPos = waypointCount - 1;
    destination = waypoints[ destinationPos ]
    sensor = query[:sensor]
    url = "#{@directionsUrl}&origin=#{origin}&destination=#{destination}&sensor=#{sensor}"
    
    if waypointCount > 2
      url.appendString("&waypoints=optimize:true")
      
      wpCount = waypointCount - 1
      
      for i in 0..wpCount
        url.appendString( "|" )
        url.appendString( waypoints[i] )
      end
    end
    
    url = url.stringByAddingPercentEscapesUsingEncoding( NSASCIIStringEncoding )

    @directionsUrl = NSURL.URLWithString( url )

    self.retrieveDirections( selector, withDelegate:delegate )
  end

  def retrieveDirections( selector, withDelegate: delegate )
    # queue = Dispatch::Queue.concurrent('com.company.app.task')
    # queue.async do
    #   data = NSData.dataWithContentsOfURL( @directionsUrl  )
    #   puts data
    # end

    data = NSData.dataWithContentsOfURL( @directionsUrl  )
    self.fetchedData( data, withSelector:selector, withDelegate:delegate )
    
  end


  def fetchedData( data, withSelector: selector, withDelegate: delegate )
    error_ptr = Pointer.new(:object)
    json = BW::JSON.parse( data )
    delegate.performSelector( selector, withObject: json )
  end
end
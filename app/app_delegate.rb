GOOGLE_MAP_API_KEY = "AIzaSyDI2uVPaGc_V-tCnvSyQ_AsaXFJCu66C0U"

class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    GMSServices.provideAPIKey(GOOGLE_MAP_API_KEY)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.rootViewController = DirectionController.new #GoogleMapsController.new
    @window.makeKeyAndVisible
    true
  end
end


class GoogleMapsController < UIViewController
  def loadView
    camera = GMSCameraPosition.cameraWithLatitude(47.592011, longitude: -122.313043, zoom: 15)
    @map_view = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
    @map_view.myLocationEnabled = true
    self.view = @map_view

    marker = GMSMarker.alloc.init
    marker.position = CLLocationCoordinate2DMake(47.592011,-122.313043)
    marker.title = "Shinjuku"
    marker.snippet = "Japan"
    marker.map = @map_view

    ds = DirectionService.new
  end

end

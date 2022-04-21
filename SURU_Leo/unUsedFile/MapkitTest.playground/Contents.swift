import MapKit
import PlaygroundSupport
let mapView = MKMapView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
mapView.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 25.09108, longitude: 121.5598), latitudinalMeters: 50000, longitudinalMeters: 50000)
PlaygroundPage.current.liveView = mapView


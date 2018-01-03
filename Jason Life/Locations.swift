import Foundation
import CoreLocation

class Locations : NSObject, CLLocationManagerDelegate {
    var locationManager: CLLocationManager!;
    
    func start() {
        locationManager = CLLocationManager();
        
        locationManager.delegate = self;
        
        //Only allows foreground unless set
        locationManager.allowsBackgroundLocationUpdates = true;
        
        locationManager.requestAlwaysAuthorization()
        
        //Only need these if live location is needed
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        locationManager.startMonitoringSignificantLocationChanges();
        
        locationManager.requestLocation();
        
        self.initGeofencing()
    }
    
    //required to request location
    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error) {
        //no-op
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        print("got location");
        let loc = locations.first;
        self.saveLocationToCloud(lat: loc!.coordinate.latitude, long: loc!.coordinate.longitude, speed: loc!.speed);
    }
    
    func checkLocationAccess() {
        let status = CLLocationManager.authorizationStatus();
        if status == .notDetermined || status == .denied {
            print("No location access");
        }
    }
    
    func saveLocationToCloud(lat:Double, long:Double, speed:Double) {
        var deviceId:Int;
        
        if(Util.isSimulator) {
            deviceId = -1;
        } else {
            deviceId = 1;
        }
        
        let urlBase = AppSettings.getLocationFunctionUrl()
        
        let url = URL(string: urlBase + "&lat=" + String(lat) + "&long=" + String(long) + "&speed=" + String(speed) + "&device=" + String(deviceId));
        
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            guard error == nil else {
                print(error!)
                return
            }
            
            print("Location sent to cloud");
        }
        task.resume();
    }
    
    func getSettings() -> NSDictionary? {
        if let path = Bundle.main.path(forResource: "Settings", ofType: "plist") {
            return NSDictionary(contentsOfFile: path)
        }
        return nil;
    }
    
    // Geofencing
    
    func initGeofencing() {
        let settings = self.getSettings()
        if let set = settings {
            if let locations = set["Locations"] as? [NSDictionary] {
                for loc in locations {
                    if let name = loc["Name"] as? String,
                        let lat = loc["Lat"] as? NSString,
                        let long = loc["Long"] as? NSString {
                            let geo = CLLocationCoordinate2D(latitude: lat.doubleValue, longitude: long.doubleValue);
                            self.monitorRegionAtLocation(center: geo, identifier: name)
                        
                        print("Added location " + name)
                    }
                }
            }
        }
    }
    
    func monitorRegionAtLocation(center: CLLocationCoordinate2D, identifier: String ) {
        // Make sure the app is authorized.
        if CLLocationManager.authorizationStatus() == .authorizedAlways {
            // Make sure region monitoring is supported.
            if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
                // Register the region.
                let region = CLCircularRegion(center: center,
                                              radius: 100, identifier: identifier)
                region.notifyOnEntry = true
                region.notifyOnExit = false
                
                locationManager.startMonitoring(for: region)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        let app = UIApplication.shared.delegate as? AppDelegate
        app?.notifications.showNotification(message: "Entered " + region.identifier);
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        let app = UIApplication.shared.delegate as? AppDelegate
        app?.notifications.showNotification(message: "Exited " + region.identifier);
    }
}

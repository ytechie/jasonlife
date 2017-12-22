import UIKit
import CoreLocation
import UserNotifications
import Foundation;

class FirstViewController: UIViewController {
    //var locationManager: CLLocationManager!;
    
    //let locations = Locations();
    
    @IBOutlet weak var tollTextArea: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let appDelegate = UIApplication.shared.delegate as! AppDelegate;
        //appDelegate.locations.
        
        //locations = Locations();
        
        /*
        checkLocationAccess();
        
        locationManager = CLLocationManager();
        
        //Requests permission to use location services whenever the app is running
        locationManager.delegate = self;
        //Only allows foreground unless set
        locationManager.allowsBackgroundLocationUpdates = true;
        locationManager.requestAlwaysAuthorization()
        
        //Only need these if live location is needed
        //locationManager.startUpdatingLocation();
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        locationManager.startMonitoringSignificantLocationChanges();
        
        locationManager.requestLocation();
 */
        
        
        registerLocalNotifications();
        refreshTollData();
    }
    
    func registerLocalNotifications() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            // Enable or disable features based on authorization
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

    struct Trip : Codable {
        let TripName: String
        let CurrentToll: Int
        let CurrentMessage: String?
        let StateRoute: String
        let TravelDirection: String
        let StartMilepost: Double
        let StartLocationName: String
        let StartLatitude: Double
        let StartLongitude: Double
        let EndMilepost: Double
        let EndLocationName: String
        let EndLatitude: Double
        let EndLongitude: Double
    }
    
    func refreshTollData() {
        
        tollTextArea.text = "";
        
        let url = URL(string: "https://wsdot.wa.gov/traffic/api/api/tolling?AccessCode=" + AppSettings.getWADOTKey())
        
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            guard error == nil else {
                print(error!)
                return
            }
            guard let data = data else {
                print("Data is empty")
                return
            }
            
            let decoder = JSONDecoder()
            let trips = try! decoder.decode([Trip].self, from: data)
            
            self.setTollText(text:"Loaded \(trips.count) trips");
            self.tripsLoaded(trips: trips);
        }
        
        task.resume()
    }
    
    func tripsLoaded(trips:Array<Trip>) {
        //Some sample trip names
        let southbound = trips.filter { $0.TripName == "405tp02784" }
        let northbound = trips.filter { $0.TripName == "405tp01587" }
        
        var txt:String = "";
        
        txt += "Southbound: " + String(describing: southbound.first!.CurrentToll) + "\n";
        txt += "Northbound: " + String(describing: northbound.first!.CurrentToll) + "\n";
        
        setTollText(text: txt);
    }
    
    func setTollText(text:String) {
        DispatchQueue.main.async {
            self.tollTextArea.text = text;
        }
    }
    

/*
    func checkLocationAccess() {
        let status = CLLocationManager.authorizationStatus()
        if status == .NotDetermined || status == .Denied || status == .AuthorizedWhenInUse {
            
            // present an alert indicating location authorization required
            // and offer to take the user to Settings for the app via
            // UIApplication -openUrl: and UIApplicationOpenSettingsURLString
            dispatch_async(dispatch_get_main_queue(), {
                let alert = UIAlertController(title: "Error!", message: "GPS access is restricted. In order to use tracking, please enable GPS in the Settigs app under Privacy, Location Services.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Go to Settings now", style: UIAlertActionStyle.Default, handler: { (alert: UIAlertAction!) in
                    print("")
                    UIApplication.sharedApplication().openURL(NSURL(string:UIApplicationOpenSettingsURLString)!)
                }))
                // self.presentViewController(alert, animated: true, completion: nil)
                self.window?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
            })
            
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        }
    }*/
}


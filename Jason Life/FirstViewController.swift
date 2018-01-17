import UIKit
import CoreLocation
import UserNotifications
import Foundation;

class FirstViewController: UIViewController {
    @IBOutlet weak var tollTextArea: UITextView!
    var tollUpdateTimer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerLocalNotifications();
        refreshTollData();
        
        tollUpdateTimer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(refreshTollData), userInfo: nil, repeats: true)
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
    
    @objc  func refreshTollData() {
        
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
        //setTollText(text: Date().timeIntervalSinceReferenceDate.description) //Just for testing UI refresh
    }
    
    func setTollText(text:String) {
        DispatchQueue.main.async {
            self.tollTextArea.text = text;
        }
    }
}


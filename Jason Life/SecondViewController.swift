import UIKit
import CoreLocation
import UserNotifications

class SecondViewController: UIViewController {
    


    override func viewDidLoad() {
        super.viewDidLoad()
        //locationManager.delegate = self
        
        let app = UIApplication.shared.delegate as? AppDelegate
        app?.notifications.showNotification();

        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}


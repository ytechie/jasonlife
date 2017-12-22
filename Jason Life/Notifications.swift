import UIKit
import CoreLocation
import UserNotifications

class Notifications: NSObject, UNUserNotificationCenterDelegate {
    override init() {
        super.init()
        let center = UNUserNotificationCenter.current()
        center.delegate = self
    }
    
    func showNotification() {
        self.showNotification(message:"message body")
    }

    func showNotification(message:String) {
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        
        content.title = "notification title"
        content.subtitle = "It's a notification"
        content.body = message
        //content.categoryIdentifier = "foo"
        
        
        content.sound = UNNotificationSound.default()
        
        //let comp = Calendar.current.dateComponents([.hour, .minute], from: date)
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.01, repeats: false)
        
        let request = UNNotificationRequest(identifier: "test", content: content, trigger: trigger)
        
        center.add(request, withCompletionHandler: { error in
            if error != nil {
                print("\(String(describing:error))")
            } else {
                print("Notification sent")
            }
        })
        
        
        //let alert = UIAlertController(title: "Hello!", message: "Message", preferredStyle: UIAlertControllerStyle.alert)
        //alert.show(., sender: self)
    }
    
    //Called when a notification is delivered to a foreground app
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.alert);
    }

}

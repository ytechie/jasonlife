import Foundation

class AppSettings {
    static var settingsRoot: NSDictionary? {
        if let path = Bundle.main.path(forResource: "Settings", ofType: "plist") {
            return NSDictionary(contentsOfFile: path)
        }
        return nil;
    }
    
    static func getLocationFunctionUrl() -> String {
        let settings = AppSettings.settingsRoot
        if settings == nil {
            return "";
        }
        
        return settings!["LocationFunctionURL"] as! String;
    }

    static func getWADOTKey() -> String {
        let settings = AppSettings.settingsRoot
        if settings == nil {
            return "";
        }
        
        return settings!["WADOTKey"] as! String;
    }
}

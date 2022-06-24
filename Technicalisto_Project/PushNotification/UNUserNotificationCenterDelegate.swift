
import Foundation
import UIKit

// [START ios_10_message_handling]
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
// Receive displayed notifications for iOS 10 devices.
func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
let userInfo = notification.request.content.userInfo
if let messageID = userInfo[gcmMessageIDKey] {
print("Message ID: \(messageID)")
}
 
completionHandler([.alert,.badge, .sound])
}
    
func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse,
 withCompletionHandler completionHandler: @escaping () -> Void) {
 let userInfo = response.notification.request.content.userInfo

print(userInfo)
        
completionHandler()
}
    
}
